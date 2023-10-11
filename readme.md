### Notice
Starting October 12th, 2023 GitHub is enforcing mandatory [two-factor authentication](https://github.blog/2023-03-09-raising-the-bar-for-software-security-github-2fa-begins-march-13/) on my account.  
I'm not going to comply and move all my activity to GitLab instead.  
Any future updates / releases will be available at: [https://gitlab.com/gitendo/mad](https://gitlab.com/gitendo/mad)  
Thanks and see you there!
___

# Music Assembler song Dumper
Back in the days, when I was happy C64 + 1541 II user, my mate borrowed me a floppy with original release of Voice Tracker 4. Unfortunately without C64 manual, SID technical information and basic knowledge of music tracking I could have only listened to a few amazing tunes... 

Taking a trip down memory line I ended up writing a small utility that presents .prg and [.sid](https://hvsc.c64.org/download/C64Music/DOCUMENTS/SID_file_format.txt) tunes from [HVSC](https://hvsc.c64.org/) in more readable, mod-tracker like format (something like C=+P in Voice Tracker v4). This might faciliate conversion and serve as a base for new features.

During the process I've discovered that the Voice Tracker was [built on top of replay routine from Music Assembler](https://csdb.dk/forums/?roomid=14&topicid=26354&showallposts=1#45052) and apart from five different versions there's another editor called Music Mixer (also written by Polonus) which is compatible. Basically there're two versions of replay routine:
- v1 used by Music Assembler and Voice Tracker v1 to v4.2
- v2 used by Voice Tracker v5 and Music Mixer

I didn't bother to compare the code but the tune format seems to be the same. If you're curious `src` directory contains some disassemblies in [64tass](http://sourceforge.net/projects/tass64/) format. These are empty tunes though.

Default output with description:

```
Music Assembler / Voice Tracker tune found!
Tune addres: $1021

PSID info:
Space Invadarz on Vacation
Richard Bayliss
2001 The New Dimension

+----+---------------------+---------------------+---------------------+
| 00 | *[00](01) C-1 02 01 | *[01](01) A-3 00 07 | *[02](01) C-5 03 01 |
| 01 |           ... .. 00 |           ... .. 06 |           ... .. 00 |
| 02 |           C-2 02 01 |           ... .. 05 |           C-4 03 01 |
| 03 |           ... .. 00 |           ... .. 04 |           ... .. 00 |
| 04 |           C-3 02 01 |           ... .. 03 |           C-6 03 01 |
| 05 |           ... .. 00 |           ... .. 02 |           ... .. 00 |
| 06 |           C-1 02 01 |           ... .. 01 |           C-4 03 01 |
| 07 |           ... .. 00 |           ... .. 00 |  LOOP     ... .. 00 |
| 08 |           C-2 02 01 |           A-3 01 07 |           --- -- -- |
| 09 |           ... .. 00 |           ... .. 06 |           --- -- -- |
| 0A |           C-3 02 01 |           ... .. 05 |           --- -- -- |
| 0B |           ... .. 00 |           ... .. 04 |           --- -- -- |
| 0C |           C-1 02 01 |           ... .. 03 |           --- -- -- |
| 0D |           ... .. 00 |           ... .. 02 |           --- -- -- |
| 0E |           C-2 02 01 |           ... .. 01 |           --- -- -- |
| 0F |           ... .. 00 |  LOOP     ... .. 00 |           --- -- -- |
| 10 |           C-1 02 01 |           --- -- -- |           --- -- -- |
| 11 |           ... .. 00 |           --- -- -- |           --- -- -- |
| 12 |           C-3 02 01 |           --- -- -- |           --- -- -- |
| 13 |           ... .. 00 |           --- -- -- |           --- -- -- |
| 14 |           C-2 02 01 |           --- -- -- |           --- -- -- |
| 15 |           ... .. 00 |           --- -- -- |           --- -- -- |
| 16 |           C-1 02 01 |           --- -- -- |           --- -- -- |
| 17 |           ... .. 00 |           --- -- -- |           --- -- -- |
| 18 |           C-2 02 01 |           --- -- -- |           --- -- -- |
| 19 |           ... .. 00 |           --- -- -- |           --- -- -- |
| 1A |           C-3 02 01 |           --- -- -- |           --- -- -- |
| 1B |           ... .. 00 |           --- -- -- |           --- -- -- |
| 1C |           C#3 02 01 |           --- -- -- |           --- -- -- |
| 1D |           ... .. 00 |           --- -- -- |           --- -- -- |
| 1E |           C-3 02 01 |           --- -- -- |           --- -- -- |
| 1F |  LOOP     ... .. 00 |           --- -- -- |           --- -- -- |
+----+---------------------+---------------------+---------------------+

 * - marks one pattern per channel that will be used as restart point if order list ends with LOOP or JUMP command
[] - pattern number
() - pattern repeat value
C-1 02 01 - note, instrument, note length (decreasing)
... - length change of previous note
--- - fade out if lenght is specified or no output (channel stopped)

```
There're two possible options to use:
```
-n  change notation to German
-u  unroll sequences and disable order info and commands
```

High Voltage SID Collection: Update #75 seems to contain around [5472 compatible tunes](tunes.md) however some of them won't work due to minor bugs, code relocation, multi tune structure, etc. Here's what I mean:
- `Acid_Mix.sid` - modified player; init code is relocated to the tune end and original replaced with note: -ACID MIX BY DOUBLE-N '90-- MUSIC AND ROUTINE(C)SYMBOLIX -- USE PLAYER ON $1060/DOUBLE-N -
- `Oriental_Dirge.sid` - pattern 00 contains DEL.08 entry stored as $E8 instead of $A8 (this is due to a bug in the v2 & v3 editor which allows entry of bogus values and saves them without checking)
- `Agent_UOP.sid` - multi tune with additional code
