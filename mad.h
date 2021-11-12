#ifndef MAD_H
#define MAD_H

#define VERSION         1.0

#define FLAG_GERMAN     1
#define FLAG_UNROLL     2

#define CHNL1           0
#define CHNL2           1
#define CHNL3           2
#define MAX_CHNLS       3
#define OCTAVE_LEN      12
#define B_NOTE          11
#define MIN_NOTE        0       // C-0
#define MAX_NOTE        0x5F    // B-7 | H-7
#define RLSE_00         0x60
#define RLSE_1F         0x7F
#define INST_00         0x80
#define INST_1F         0x9F
#define SUST_00         0xA0
#define SUST_1F         0xBF
#define SEQUENCE_END    0xFF
#define CMD_JUMP        0xFD
#define CMD_STOP        0xFE
#define CMD_LOOP        0xFF

#define PRG_HEADER      2
#define PSID_ID         0x44495350
#define MAGIC_OFFSET    0x48

#define V1              1
#define V1_TAG          0x62
#define V1_TRACKS_LSB   0x1A
#define V1_TRACKS_MSB   0x1F
#define V1_SEQUENCE_LSB 0x5A
#define V1_SEQUENCE_MSB 0x5F

#define V2              2
#define V2_TAG          0xA6
#define V2_TUNE_INFO    0x12
#define V2_INFO_LEN     0x12
#define V2_TRACKS_LSB   0x1A
#define V2_TRACKS_MSB   0x1F
#define V2_SEQUENCE_LSB 0x85
#define V2_SEQUENCE_MSB 0x8A

#define be2le(val) (((val & 0x00FF) << 8) | ((val & 0xFF00) >> 8))

// structs
struct tune {
    unsigned char *ptr;        // auxiliary pointer to tune data
    unsigned short int adr;    // tune address in C64 memory
    unsigned char *base;       // player init pointer used to calculate relative addresses of order and pattern data
    int size;                  // tune size
    char ver;                  // replay routine version
    bool psid;                 // file type
};

struct track {
    unsigned char *ptr;        // order list pointer
    unsigned char ofs;         // current entry
    bool play;                 // on / off switch
};

struct sequence {
    unsigned char *ptr;        // sequence data pointer
    unsigned char ofs;         // current instruction / note to play
    unsigned char trns;        // transpose value
    char rpt;                  // repeat value
    char num;                  // sequence being played
    char mark;                 // sequence to loop / jump to when track ends
    bool prnt;                 // print sequence info flag
    bool valid;                // must contains at least one note or off instruction
    bool end;                  // sequence end code is next
};

struct note {
    unsigned char sym;         // note being played
    char ins;                  // instrument
    char len;                  // length
    char rlse;                  // volume fade out steps
    bool prnt;                 // print / skip printing note flag
};

#pragma pack(push, 1)

struct header {                // V1, all values are big endian
    int id;                    // 'PSID'
    short int ver;             // 0x0001, 0x0002 or 0x0003
    short int data;            // offset to binary data in file
    unsigned short int load;   // C64 address to load file to
    unsigned short int init;   // C64 address of init subroutine
    unsigned short int play;   // C64 address of play subroutine
    short int songs;           // number of songs
    short int start;           // start song out of [1..256]
    int speed;                 // 32-bit speed info
                               // bit: 0=50 Hz, 1=CIA 1 Timer A (default: 60 Hz)
    char name[32];             // zero terminated ASCII strings
    char author[32];           //
    char released[32];         //
};

#pragma pack(pop)

#endif /* MAD_H */
