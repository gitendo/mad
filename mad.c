#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "mad.h"

// globals
unsigned char   *g_tp = NULL;   // tune data pointer
FILE            *g_fp = NULL;   // file pointer


// program info
void banner(void)
{
    printf("\nMAD v%.2f - Music Assembler song Dumper\n", VERSION);
    printf("Programmed by: tmk, email: tmk@tuta.io\n");
    printf("Project page: https://github.com/gitendo/mad/\n\n");
}


// how to use
void usage(void)
{
    banner();
    printf("Syntax: mad.exe [-n|-u] tune.prg\n\n");
    printf("-n\tchange notation to German\n");
    printf("-u\tunroll sequences and disable order info and commands\n\n");
}


// release allocated memory and close file handle, this uses global vars
void cleanup(void) {
    if(g_tp)
        free(g_tp);
    if(g_fp)
        fclose(g_fp);
}


// check if file is supported and update tune struct and psid if header is present
void identify(struct tune *tn, struct header *psid) {

    int i, result;
    // player init code
    const unsigned char magic[] = {0xA9, 0x1F, 0x8D, 0x18, 0xD4, 0xA9, 0xF0, 0x8D, 0x17, 0xD4, 0x29, 0x0F, 0x8D};

    // confirm psid file
    if(PSID_ID == *(int *)tn->ptr) {
        // populate psid header
        memcpy(psid, tn->ptr, sizeof(*psid));
        // skip psid header, move pointer to prg header
        tn->ptr += be2le(psid->data);
        // get tune base address
        tn->adr = *(short int *)tn->ptr;
        // move pointer to tune data
        tn->ptr += PRG_HEADER;
        // adjust file size to raw tune data
        tn->size -= (be2le(psid->data) + PRG_HEADER);
        tn->psid = true;
    // assume regular .prg
    } else {
        // get tune base address
        tn->adr = *(short int *)tn->ptr;
        // move pointer to tune data
        tn->ptr += PRG_HEADER;
        // adjust file size to raw tune data
        tn->size -= PRG_HEADER;
        // clear psid header
        memset(psid, 0, sizeof(*psid));
        tn->psid = false;
    }

    // scan whole tune
    for(i = 0; i < tn->size - (int) sizeof(magic); i++) {
        // and confirm player code
        result = memcmp(tn->ptr + i, magic, sizeof(magic));
        // found it!
        if(!result)
            break;
    }

    // not supported
    if(i == (int)(tn->size - sizeof(magic))) {
        printf("Error: Music Assembler / Voice Tracker / Music Mixer tune not recognized!\n");
        exit(EXIT_FAILURE);
    } else {
        // base will be used to calculate order and pattern locations later
        tn->base = tn->ptr + i;
        // version check
        switch(tn->base[sizeof(magic)]) {
            case V1_TAG: 
                tn->ver = V1;
                break;
            case V2_TAG:
                tn->ver = V2;
                break;
            default:
                printf("Error: replay routine version not recognized!\n");
                exit(EXIT_FAILURE);
                break;
        }
    }
}


// get order list for all channels
void get_order_lists(struct tune *tn, struct track *trk) {

    unsigned char chnl;
    short int lsb, msb;

    for(chnl = CHNL1; chnl < MAX_CHNLS; chnl++) {
        // player version
        if(tn->ver == V1) {
            lsb = V1_TRACKS_LSB;
            msb = V1_TRACKS_MSB;
        } else {
            lsb = V2_TRACKS_LSB;
            msb = V2_TRACKS_MSB;
        }

        // extract array address at which least significant bytes are stored
        lsb = *(short int *)(tn->base + lsb) + chnl;
        // make offset
        lsb -= tn->adr;
        // extract array address at which most significant bytes are stored
        msb = *(short int *)(tn->base + msb) + chnl;
        // make offset
        msb -= tn->adr;
        // get order list address from msb,lsb pair
        trk[chnl].ptr = tn->ptr + ((tn->ptr[msb] << 8) - tn->adr + tn->ptr[lsb]);
        // reset
        trk[chnl].ofs = 0;
        trk[chnl].play = true;
    }
}


// mark sequences that are loop / restart points in order list (presentation purposes only)
void mark_restart_sequences(struct sequence *seq, struct track *trk) {
    
    unsigned char chnl;

    for(chnl = CHNL1; chnl < MAX_CHNLS; chnl++) {
        // skip all entries except commands
        while(trk[chnl].ptr[trk[chnl].ofs] < CMD_JUMP) {
            trk[chnl].ofs += 2;
        }
        // identify command
        switch(trk[chnl].ptr[trk[chnl].ofs]) {

            case CMD_JUMP:
                // move to command attribute
                trk[chnl].ofs++;
                // order entry consists of 2 bytes
                trk[chnl].ofs = trk[chnl].ptr[trk[chnl].ofs] * 2;
                // get actual sequence number to mark
                seq[chnl].mark = trk[chnl].ptr[trk[chnl].ofs];
                break;

            case CMD_STOP:
                // no need to mark
                seq[chnl].mark = -1;
                break;

            case CMD_LOOP:
                // this is easy
                trk[chnl].ofs = 0;
                seq[chnl].mark = trk[chnl].ptr[trk[chnl].ofs];
                break;
        }
        // reset to default
        trk[chnl].ofs = 0;
    }
}


// fill sequence structure
void get_sequence(struct tune *tn, struct track *trk, struct sequence *seq) {

    short int   lsb = 0, msb = 0;

    // player version
    if(tn->ver == V1) {
        lsb = V1_SEQUENCE_LSB;
        msb = V1_SEQUENCE_MSB;
    // V2
    } else {
        lsb = V2_SEQUENCE_LSB;
        msb = V2_SEQUENCE_MSB;
    }
    // extract array address at which least significant bytes are stored
    lsb = *(short int *)(tn->base + lsb);
    // extract array address at which most significant bytes are stored
    msb = *(short int *)(tn->base + msb);
    // get sequence number
    seq->num = trk->ptr[trk->ofs];
    // create offsets pointing to current sequence address
    lsb = (lsb - tn->adr) + seq->num;
    msb = (msb - tn->adr) + seq->num;
    // get sequence address from msb,lsb pair
    seq->ptr = tn->ptr + ((tn->ptr[msb] << 8) - tn->adr + tn->ptr[lsb]);
    // start from beginning
    seq->ofs = 0;
    // set transpose & length
    trk->ofs++;
    seq->trns = (trk->ptr[trk->ofs] & 0xF0) >> 4;
    seq->rpt = trk->ptr[trk->ofs] & 0x0F;
    // defaults
    seq->prnt = false;
    seq->valid = false;
    // next order entry
    trk->ofs++;
}


// fill note structure
void get_note(struct sequence *seq, struct note *nt) {

    // notes (C-0 to B-7)
    if(seq->ptr[seq->ofs] <= MAX_NOTE) {
        // get note and transpose it if neccessary
        nt->sym = seq->ptr[seq->ofs] + seq->trns;
        seq->ofs++;
        // note duration
        nt->len = (seq->ptr[seq->ofs] & 0x1F);
        // this prevents printing symbolic instruction
        nt->prnt = true;
        // sound pitch
        if(seq->ptr[seq->ofs] & 0x20) {
            seq->ofs += 2;
        // filters
        } else if(seq->ptr[seq->ofs] & 0x80) {
            seq->ofs += 2;
        }
        seq->ofs++;
        // sequence is valid when it has at least one note or RLSE instruction
        seq->valid = true;
    // symbolic instructions
    // fade out
    } else if(seq->ptr[seq->ofs] >= RLSE_00 && seq->ptr[seq->ofs] <= RLSE_1F) {
        nt->sym = seq->ptr[seq->ofs] & 0xE0;
        nt->rlse = seq->ptr[seq->ofs] & 0x1F;
        seq->ofs++;
        seq->valid = true;
    // instrument
    } else if(seq->ptr[seq->ofs] >= INST_00 && seq->ptr[seq->ofs] <= INST_1F) {
        nt->sym = seq->ptr[seq->ofs] & 0xE0;
        nt->ins = seq->ptr[seq->ofs] & 0x1F;
        seq->ofs++;
        get_note(seq, nt);
    // sustain
    } else if(seq->ptr[seq->ofs] >= SUST_00 && seq->ptr[seq->ofs] <= SUST_1F) {
        nt->sym = seq->ptr[seq->ofs] & 0xE0;
        nt->len += (seq->ptr[seq->ofs] & 0x1F);
        seq->ofs++;
    // sequence end
    } else if(seq->ptr[seq->ofs] == SEQUENCE_END) {
        nt->sym = seq->ptr[seq->ofs];
        return;
    // debug
    } else {
        printf("Error: unknown symbolic instruction found %02X %02X %02X\n", seq->ptr[seq->ofs], seq->ptr[seq->ofs + 1], seq->ptr[seq->ofs + 2]);
        exit(EXIT_FAILURE);
    }
    // prefetch, used to display loop / jump codes
    if(seq->ptr[seq->ofs] == SEQUENCE_END && !seq->rpt)
        seq->end = true;
    else
        seq->end = false;
}


// process track order commands
char track_ctrl(char chnl, struct track *trk, char *options, char state) {

    bool    set;

    if(*options & FLAG_UNROLL)
        set = true;
    else
        set = false;

    switch(trk->ptr[trk->ofs]) {
        // Voice Tracker / Music Mixer only
        case CMD_JUMP:
            trk->ofs++;
            // track order entry to jump to
            trk->ofs = trk->ptr[trk->ofs];
            trk->play = set;
            // mark track as finished
            state &= (char) ~(1 << chnl);
            break;

        case CMD_STOP:
            trk->play = set;
            // mark track as finished
            state &= (char) ~(1 << chnl);
            break;

        case CMD_LOOP:
            // restart
            trk->ofs = 0;
            trk->play = set;
            // mark track as finished
            state &= (char) ~(1 << chnl);
            break;
        // sequences
        default:
            break;
    }

    return state;
}


// tracker like presentation
void print_notes(struct note *nt, struct sequence *seq, struct track *trk, char *options, char state) {
    
    static char *notation[] = {"C-", "C#", "D-", "D#", "E-", "F-", "F#", "G-", "G#", "A-", "A#", "B-"};
    static char row = 0;
    unsigned char chnl;

    // change notation to german if needed
    if(*options & FLAG_GERMAN) {
        notation[B_NOTE] = "H-";
        *options ^= FLAG_GERMAN;
    }

    // do not proceed when each track's order list has been finished, this prevents unnecessary output
    if(state) {
        // row counter reset happens when new sequences on all channels are being fetched at the same time
        if(seq[CHNL1].num >= 0 && seq[CHNL2].num >= 0 && seq[CHNL3].num >= 0) {
            row = 0;
            // no pattern info if flag is set, num is checked below
            if(*options & FLAG_UNROLL) {
                seq[CHNL1].num = -1;
                seq[CHNL2].num = -1;
                seq[CHNL3].num = -1;
            }
        }
        // opening / dividing line
        if(!row)
            printf("+----+---------------------+---------------------+---------------------+\n");
        // print pattern row counter
        printf("| %02X ", row);
        // print columns / channels
        for(chnl = CHNL1; chnl < MAX_CHNLS; chnl++) {
            // track must be unmuted and its order list not finished
            if(trk[chnl].play && seq[chnl].valid) {
                // do not print pattern information and track commands
                if(*options & FLAG_UNROLL) {
                    printf("|           ");
                // print pattern information and track commands
                } else {
                    // print pattern and repeat amount
                    if(seq[chnl].num >= 0) {
                        // normal pattern
                        if(seq[chnl].num != seq[chnl].mark) {
                            printf("|  [%02X](%02X) ", seq[chnl].num, seq[chnl].rpt + 1);
                        // marked pattern (one that order list loops / jumps to)
                        } else {
                            printf("| *[%02X](%02X) ", seq[chnl].num, seq[chnl].rpt + 1);
                            seq[chnl].mark = -1;
                        }
                        // done until next sequence is fetched
                        seq[chnl].num = -1;
                    // print pattern repeat count
                    } else if (seq[chnl].prnt) {
                        printf("|      (%02X) ", seq[chnl].rpt + 1);
                        seq[chnl].prnt = false;
                    // padding or special command
                    } else {
                        // true when last note entry and last note in pattern
                        if(!nt[chnl].len && !nt[chnl].rlse && seq[chnl].end) {
                            switch(trk[chnl].ptr[trk[chnl].ofs]) {
                                case CMD_JUMP:
                                    printf("|  JUMP     ");
                                    break;
                                case CMD_STOP:
                                    printf("|  STOP     ");
                                    break;
                                case CMD_LOOP:
                                    printf("|  LOOP     ");
                                    break;
                                default:
                                    printf("|           ");
                                    break;
                            }
                        } else {
                            printf("|           ");
                        }
                    }
                }
                // print note
                if(nt[chnl].prnt) {
                    printf("%s%d %02X %02X ", notation[nt[chnl].sym % OCTAVE_LEN], nt[chnl].sym / OCTAVE_LEN, nt[chnl].ins, nt[chnl].len);
                    nt[chnl].prnt = false;
                // sustain
                } else if(nt[chnl].sym <= MAX_NOTE || nt[chnl].sym == SUST_00) {
                    printf("... .. %02X ", nt[chnl].len);
                // release
                } else if(nt[chnl].sym == RLSE_00) {
                    printf("--- -- %02X ", nt[chnl].rlse);
                // debug
                } else {
                    printf("Failure: %02X\n", nt[chnl].sym);
                    exit(EXIT_FAILURE);
                }
            // muted
            } else {
                printf("|           --- -- -- ");
            }
        }
        // next row
        printf("|\n");
        row = (row + 1) & 63;
    } else {
        // closing line
        printf("+----+---------------------+---------------------+---------------------+\n");
    }
}


// dumps tune data to stdout
int dump(struct tune *tn, char *options) {

    unsigned char chnl;
    char   state = (1 << CHNL1) | (1 << CHNL2) | (1 << CHNL3);
    struct header  psid = {0};
    struct track   trk[MAX_CHNLS] = {0};
    struct sequence seq[MAX_CHNLS] = {0};
    struct note    nt[MAX_CHNLS] = {0};

    // check input file first
    identify(tn, &psid);
    // check version and print tune info
    switch(tn->ver) {
        case V1:
            printf("Music Assembler / Voice Tracker tune found!\n");
            break;
        case V2:
            printf("Voice Tracker / Music Mixer tune found!\n");
            // native tune info
            printf("Tune info: %.*s\n", V2_INFO_LEN, tn->base - V2_TUNE_INFO);
            break;
    }
    // tune address
    printf("Tune addres: $%4X\n\n", tn->adr);
    // psid info if present
    if(tn->psid) {
        printf("PSID info:\n");
        printf("%s\n%s\n%s\n\n", psid.name, psid.author, psid.released);
    }

    // sequence order for each channel
    get_order_lists(tn, trk);
    // loop / restart points
    mark_restart_sequences(seq, trk);
    // sequence data for each channel
    get_sequence(tn, &trk[CHNL1], &seq[CHNL1]);
    get_sequence(tn, &trk[CHNL2], &seq[CHNL2]);
    get_sequence(tn, &trk[CHNL3], &seq[CHNL3]);

    // play until order lists for all channels have been processed
    while(state) {
        // 3 channels
        for(chnl = CHNL1; chnl < MAX_CHNLS; chnl++) {
            // is channel muted?
            if(trk[chnl].play) {
                // note already printed?
                if(nt[chnl].len > 0) {
                    nt[chnl].len--;
                // release volume?
                } else if(nt[chnl].rlse > 0) {
                    nt[chnl].rlse--;
                // next note /instruction
                } else {
                    get_note(&seq[chnl], &nt[chnl]);
                }
                // sequence end reached
                if(nt[chnl].sym == SEQUENCE_END) {
                    // need to repeat?
                    if(seq[chnl].rpt > 0) {
                        seq[chnl].ofs = 0;
                        seq[chnl].rpt--;
                        seq[chnl].prnt = true;
                    // no more repeats
                    } else {
                        // check if order list end is reached
                        state = track_ctrl(chnl, &trk[chnl], options, state);
                        // next sequence
                        get_sequence(tn, &trk[chnl], &seq[chnl]);
                    }
                    // next note /instruction
                    get_note(&seq[chnl], &nt[chnl]);
                }
            }
        }
        // print row
        print_notes(nt, seq, trk, options, state);
    }
    return(EXIT_SUCCESS);
}


// program entry
int main (int argc, char *argv[])
{
    char    options = 0;
    int     arg, fname = 0;
    struct  tune tn;

    // at least file name is needed
    if(argc < 2) {
        usage();
        exit(EXIT_FAILURE);
    }
    // parse arguments if any
    for(arg = 1; arg < argc; arg++)
    {
        if((argv[arg][0] == '-') || (argv[arg][0] == '/'))
        {
            switch(tolower(argv[arg][1]))
            {
                case 'n':
                    options |= FLAG_GERMAN;
                    break;

                case 'u':
                    options |= FLAG_UNROLL;
                    break;

                default:
                    usage();
                    exit(EXIT_FAILURE);
                    break;
            }
        } else {
            fname = arg;
        }
    }
    // no file name, no work
    if(!fname) {
        usage();
        exit(EXIT_FAILURE);
    }

    // release everything that is going to be allocated at program exit
    atexit(cleanup);

    // get file handle
    g_fp = fopen(argv[fname], "rb+");
    if(!g_fp) {
        printf("Error: unable to access %s\n", argv[fname]);
        exit(EXIT_FAILURE);
    }
    // get file size
    fseek(g_fp, 0L, SEEK_END);
    tn.size = ftell(g_fp);
    rewind(g_fp);
    // data buffer
    g_tp = (unsigned char *) malloc(tn.size);
    if(!g_tp) {
        printf("Error: unable to allocate memory for %s\n", argv[fname]);
        exit(EXIT_FAILURE);
    }
    tn.ptr = g_tp;
    // read file
    fread(tn.ptr, tn.size, 1, g_fp);
    if(dump(&tn, &options))
        exit(EXIT_FAILURE);

    exit(EXIT_SUCCESS);
}
