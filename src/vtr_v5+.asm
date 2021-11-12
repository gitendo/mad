; VoiceTracker V5+ replay routine disassembly
; This one has nothing common with V5, it's more like V2, V3, V4 with zeroed arpeggios, presets, etc.
; https://github.com/gitendo/mad

*		= $1000

loc_1000:
		JMP	sub_1048	; player init

loc_1003:
		JMP	sub_1021	; player update

sub_1006:				; raster player
		SEI
		JSR	loc_1000

loc_100A:
		LDA	#$FF

loc_100C:
		CMP	$D012
		BNE	loc_100C
		JSR	loc_1003
		LDA	$DC01
		AND	#$10
		BNE	loc_100A
		STA	$D418
		CLI
		RTS

		.BYTE $33 

sub_1021:				; player update
		LDX	#0
		DEC	byte_1090
		BMI	loc_1034
		JSR	loc_1226
		JSR	sub_1225
		JMP	sub_1225

unk_1031:
		.BYTE $FF
		.BYTE $FF
		.BYTE $FF

loc_1034:
		LDA	#2
		STA	byte_1090
		JSR	loc_1040
		JSR	loc_103F

loc_103F:
		INX

loc_1040:
		DEC	unk_108A,X
		BMI	loc_1091
		JMP	loc_1226

sub_1048:				; player init
		LDA	#$1F
		STA	$D418
		LDA	#$F0 
		STA	$D417
		AND	#$F
		STA	loc_1261+1
		LDX	#$F

loc_1059:
		STA	unk_1081,X
		DEX
		BPL	loc_1059
		LDX	#2

loc_1061:
		LDA	unk_14B9,X	; track	array lsb
		STA	$FA
		LDA	unk_14BC,X	; track	array msb
		STA	$FB
		LDY	#0
		LDA	($FA),Y
		STA	unk_108D,X
		INY
		LDA	($FA),Y
		STA	unk_10E6,X
		AND	#$F
		STA	unk_10E9,X
		DEX
		BPL	loc_1061
		RTS

unk_1081:
		.BYTE	0
		.BYTE	0
		.BYTE	0
unk_1084:
		.BYTE	0
		.BYTE $FF
		.BYTE	0
unk_1087:
		.BYTE	0
		.BYTE	0
		.BYTE	0
unk_108A:
		.BYTE $1F
		.BYTE $15
		.BYTE $15
unk_108D:
		.BYTE	0
		.BYTE	0
		.BYTE	0
byte_1090:
		.BYTE	0

loc_1091:
		LDY	unk_108D,X
		CPY	#$FE 
		BNE	loc_10A1

sub_1098:
		LDA	unk_1084,X
		AND	#$FE 
		STA	unk_1084,X
		RTS

loc_10A1:
		LDA	byte_16AE,Y	; sequence address lsb
		STA	$FA
		LDA	byte_1670,Y	; sequence address msb
		STA	$FB
		LDY	unk_1081,X
		LDA	($FA),Y
		BMI	loc_10D2
		CMP	#$60 
		BCC	loc_10F9

loc_10B6:
		AND	#$1F
		STA	unk_108A,X
		LDA	#$FE 
		STA	unk_1031,X
		JSR	sub_1098

loc_10C3:
		JMP	loc_1187

unk_10C6:
		.BYTE	0
		.BYTE	7
		.BYTE  $E
unk_10C9:
		.BYTE $60
		.BYTE $60
		.BYTE $60
unk_10CC:
		.BYTE	0
		.BYTE $ED
		.BYTE $EB
unk_10CF:
		.BYTE $5E
		.BYTE $FA
		.BYTE $15

loc_10D2:
		CMP	#$A0 
		BCC	loc_10EC
		AND	#$1F
		STA	unk_108A,X
		BCS	loc_10C3

loc_10DD:

		BRK
		.BYTE $42
		.BYTE $6F
unk_10E0:
		.BYTE	0
		.BYTE	0
		.BYTE $7E
unk_10E3:
		.BYTE	0
		.BYTE	0
		.BYTE	0
unk_10E6:
		.BYTE	0
		.BYTE	0
		.BYTE	0
unk_10E9:
		.BYTE	0
		.BYTE	0
		.BYTE	0

loc_10EC:
		ASL	A
		ASL	A
		ASL	A
		STA	unk_13D9,X
		INY
		LDA	($FA),Y
		CMP	#$60 
		BCS	loc_10B6

loc_10F9:
		STA	$FC
		INY
		LDA	unk_10E6,X
		LSR	A
		LSR	A
		LSR	A
		LSR	A
		CLC
		ADC	$FC
		STA	unk_10C9,X
		STY	$FC
		TAY
		LDA	byte_1437,Y	; sid frequency	array lsb
		STA	unk_10CC,X
		STA	unk_13E2,X
		LDA	byte_11C5,Y	; sid frequency	array msb
		STA	unk_10CF,X
		STA	unk_12B6,X
		LDY	$FC
		LDA	($FA),Y
		STA	unk_1141,X
		AND	#$1F
		STA	unk_108A,X
		LDA	($FA),Y
		BMI	loc_1150
		AND	#$20 
		BEQ	loc_1177
		INY
		LDA	($FA),Y
		STA	unk_1147,X
		INY
		LDA	($FA),Y
		STA	unk_114A,X
		JMP	loc_1177

unk_1141:
		.BYTE $5F
		.BYTE $57
		.BYTE $5F
unk_1144:
		.BYTE	3
		.BYTE	0
		.BYTE  $F
unk_1147:
		.BYTE $E0
		.BYTE $50
		.BYTE $50
unk_114A:
		.BYTE $FF
		.BYTE	0
		.BYTE	0
unk_114D:
		.BYTE	0
		.BYTE	0
		.BYTE	0

loc_1150:
		STX	loc_1261+1
		INY
		LDA	($FA),Y
		STA	loc_1265+1
		AND	#$F
		ASL	A
		SEC
		SBC	#$10
		STA	loc_129F+1
		INY
		LDA	($FA),Y
		BNE	loc_116E
		LDA	#$F0 
		STA	$D417
		BNE	loc_1177

loc_116E:
		STA	loc_126A+1
		LDA	unk_12B3,X
		STA	$D417

loc_1177:
		LDA	#$FF
		STA	unk_1031,X
		STA	unk_12B9,X
		LDA	#0
		STA	loc_10DD,X
		STA	unk_12BD,X

loc_1187:
		INY
		LDA	($FA),Y
		CMP	#$FF
		BNE	loc_11C0
		DEC	unk_10E9,X
		BPL	loc_11BE
		LDA	unk_14B9,X	; track	array lsb
		STA	$FA
		LDA	unk_14BC,X	; track	array msb
		STA	$FB
		LDY	unk_1087,X
		INY
		JSR	loc_14BF
		CMP	#$FF
		BNE	loc_11AA
		LDY	#0

loc_11AA:
		TYA
		STA	unk_1087,X
		LDA	($FA),Y
		STA	unk_108D,X
		INY
		LDA	($FA),Y
		STA	unk_10E6,X
		AND	#$F
		STA	unk_10E9,X

loc_11BE:
		LDY	#0

loc_11C0:
		TYA
		STA	unk_1081,X
		RTS

byte_11C5:
		.BYTE	1,  1,	1,  1,	1,  1,	1,  1,	1,  1,	1,  2,	2,  2,	2,  2 ;	sid frequency array msb
		.BYTE	2,  2,	3,  3,	3,  3,	3,  4,	4,  4,	4,  5,	5,  5,	6,  6
		.BYTE	6,  7,	7,  8,	8,  9,	9, $A, $A, $B, $C, $D, $D, $E, $F,$10
		.BYTE $11,$12,$13,$14,$15,$17,$18,$1A,$1B,$1D,$1F,$20,$22,$24,$27,$29
		.BYTE $2B,$2E,$31,$34,$37,$3A,$3E,$41,$45,$49,$4E,$52,$57,$5C,$62,$68
		.BYTE $6E,$75,$7C,$83,$8B,$93,$9C,$A5,$AF,$B9,$C4,$D0,$DD,$EA,$F8,$FD

sub_1225:
		INX

loc_1226:
		LDY	unk_13D9,X
		STY	$FC
		LDA	unk_1141,X
		AND	#$40 
		BNE	loc_1290
		STA	unk_1144,X
		LDA	unk_14ED,Y	; presets
					; 00
		STA	$FA
		LDA	unk_14EE,Y
		LDY	unk_10C6,X
		STA	$D406,Y
		LDA	$FA
		STA	$D405,Y
		LDA	unk_1084,X
		AND	#$FE 
		STA	$D404,Y
		LDY	$FC
		LDA	unk_14EF,Y
		STA	unk_1084,X
		LDA	unk_14F0,Y
		STA	unk_13DC,X
		STA	unk_13DF,X

loc_1261:
		CPX	#0
		BNE	loc_126F

loc_1265:
		LDA	#$87 
		STA	loc_129D+1

loc_126A:
		LDA	#8
		STA	loc_1295+1

loc_126F:
		LDA	#0
		STA	unk_10E0,X
		STA	unk_10E3,X
		LDA	unk_14F2,Y
		LSR	A
		LSR	A
		LSR	A
		STA	unk_114D,X
		LDA	unk_1141,X
		ORA	#$40 
		STA	unk_1141,X
		LDA	unk_14F4,Y
		STA	$FD,X
		JMP	loc_1385

loc_1290:
		CPX	loc_1261+1
		BNE	loc_12A7

loc_1295:
		LDA	#0
		BEQ	loc_12A7
		DEC	loc_1295+1
		CLC

loc_129D:
		LDA	#$FF

loc_129F:
		ADC	#$FE 
		STA	loc_129D+1
		STA	$D416

loc_12A7:
		LDA	$FD,X
		AND	#$F
		BEQ	loc_12C7
		JSR	loc_13E5
		JMP	loc_1322

unk_12B3:
		.BYTE $F1
		.BYTE $F3
		.BYTE $F7
unk_12B6:
		.BYTE $1A
		.BYTE $34
		.BYTE $10
unk_12B9:
		.BYTE $FF
		.BYTE $FF
		.BYTE $FF
		.BYTE	0
unk_12BD:
		.BYTE	0
		.BYTE $E3
		.BYTE	4
		.BYTE	0
		.BYTE	0
		.BYTE	0
unk_12C3:
		.BYTE	0
		.BYTE	1
		.BYTE	1
		.BYTE	0

loc_12C7:
		LDA	unk_1141,X
		AND	#$20 
		BNE	loc_1322
		LDA	$FD,X
		AND	#$10
		BEQ	loc_1322
		DEC	unk_114D,X
		BPL	loc_1322
		INC	unk_114D,X
		LDA	unk_12BD,X
		AND	#3
		TAY
		LDA	unk_12C3,Y
		BNE	loc_12FA
		LDY	$FC
		SEC
		LDA	unk_10CC,X
		SBC	unk_14F3,Y
		STA	unk_10CC,X
		BCS	loc_130D
		DEC	unk_10CF,X
		BNE	loc_130D

loc_12FA:
		LDY	$FC
		CLC
		LDA	unk_10CC,X
		ADC	unk_14F3,Y
		STA	unk_10CC,X
		BCC	loc_130D
		INC	unk_10CF,X
		BCS	loc_130D

loc_130D:
		INC	loc_10DD,X
		LDA	unk_14F2,Y
		AND	#$F
		CMP	loc_10DD,X
		BNE	loc_1322
		LDA	#0
		STA	loc_10DD,X
		INC	unk_12BD,X

loc_1322:
		LDY	$FC
		LDA	unk_14F1,Y
		STA	$FC
		LDA	$FD,X
		AND	#$40 
		BEQ	loc_1343
		CLC
		LDA	$FC
		ADC	unk_13DC,X
		STA	unk_13DC,X
		LDA	$FC
		ADC	unk_13DF,X
		STA	unk_13DF,X
		JMP	loc_1385

loc_1343:
		LDA	$FD,X
		AND	#$20 
		BEQ	loc_1385
		LDA	unk_10E3,X
		BEQ	loc_135E
		CLC
		LDA	unk_13DC,X
		ADC	$FC
		STA	unk_13DC,X
		BCC	loc_136C
		INC	unk_13DF,X
		BCS	loc_136C

loc_135E:
		SEC
		LDA	unk_13DC,X
		SBC	$FC
		STA	unk_13DC,X
		BCS	loc_136C
		DEC	unk_13DF,X

loc_136C:
		INC	unk_10E0,X
		LDA	$FC
		AND	#$F
		CMP	unk_10E0,X
		BNE	loc_1385
		LDA	#0
		STA	unk_10E0,X
		LDA	unk_10E3,X
		EOR	#1
		STA	unk_10E3,X

loc_1385:
		LDY	unk_10C6,X
		LDA	unk_1084,X
		STA	$D404,Y
		LDA	unk_13DF,X
		STA	$D403,Y
		LDA	unk_13DC,X
		STA	$D402,Y
		LDA	unk_1141,X
		AND	#$20 
		BEQ	loc_13CC
		LDA	unk_1147,X
		AND	#1
		BEQ	loc_13B2
		LDA	unk_12B9,X
		EOR	#$FF
		STA	unk_12B9,X
		BNE	loc_13CC

loc_13B2:
		CLC
		LDA	unk_13E2,X
		ADC	unk_1147,X
		STA	unk_13E2,X
		STA	$D400,Y
		LDA	unk_12B6,X
		ADC	unk_114A,X
		STA	unk_12B6,X
		STA	$D401,Y
		RTS

loc_13CC:

		LDA	unk_10CC,X
		STA	$D400,Y
		LDA	unk_10CF,X
		STA	$D401,Y
		RTS

unk_13D9:
		.BYTE $90
		.BYTE $60
		.BYTE $80
unk_13DC:
		.BYTE $D4
		.BYTE $48
		.BYTE $64
unk_13DF:
		.BYTE $1C
		.BYTE $CE
		.BYTE $44
unk_13E2:
		.BYTE $13
		.BYTE $26
		.BYTE $6E

loc_13E5:
		TAY
		LDA	byte_1498,Y	; arpeggio array lsb
		STA	$FA
		LDA	byte_14A8,Y	; arpeggio array msb
		STA	$FB
		LDY	unk_1144,X
		LDA	($FA),Y
		AND	unk_1031,X
		STA	unk_1084,X
		INY
		LDA	($FA),Y
		BMI	loc_1404
		CLC
		ADC	unk_10C9,X

loc_1404:
		AND	#$7F 
		STA	loc_1428+1
		INY
		LDA	($FA),Y
		BEQ	loc_1411
		STA	loc_129D+1

loc_1411:
		INY
		LDA	($FA),Y
		CMP	#$FE 
		BCC	loc_1424
		BEQ	loc_141E
		LDY	#0
		BEQ	loc_1424

loc_141E:
		LDA	$FD,X
		AND	#$F0 
		STA	$FD,X

loc_1424:
		TYA
		STA	unk_1144,X

loc_1428:
		LDY	#$7F 
		LDA	byte_1437,Y	; sid frequency	array lsb
		STA	unk_10CC,X
		LDA	byte_11C5,Y	; sid frequency	array msb
		STA	unk_10CF,X
		RTS

byte_1437:
		.BYTE $16,$27,$38,$4B,$5F,$73,$8A,$A1,$BA,$D4,$F0, $E,$2D,$4E,$71,$96 ;	sid frequency array lsb
		.BYTE $BD,$E7,$13,$42,$74,$A9,$E0,$1B,$5A,$9B,$E2,$2C,$7B,$CE,$27,$85
		.BYTE $E8,$51,$C1,$37,$B4,$37,$C4,$57,$F5,$9C,$4E,  9,$D0,$A3,$82,$6E
		.BYTE $68,$6E,$88,$AF,$EB,$39,$9C,$13,$A1,$46,	4,$DC,$D0,$DC,$10,$5E
		.BYTE $D6,$72,$38,$26,$42,$8C,	8,$B8,$A0,$B8,$20,$BC,$AC,$E4,$70,$4C
		.BYTE $84,$18,$10,$70,$40,$70,$40,$78,$58,$C8,$E0,$98,	8,$30,$20,$2E
		.BYTE $67

byte_1498:
		.BYTE $69,$DE,$DF,$E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7,$E8,$E9,$EA,$EB,$EC ; arpeggio array lsb
byte_14A8:
		.BYTE $E0,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14 ; arpeggio array msb
		.BYTE $22
unk_14B9:
		.BYTE $ED		; track array lsb
		.BYTE $F0
		.BYTE $F3
unk_14BC:
		.BYTE $15		; track	array msb
		.BYTE $15
		.BYTE $15

loc_14BF:
		INY

loc_14C0:
		LDA	($FA),Y
		CMP	#$FD 
		BEQ	loc_14C7
		RTS

loc_14C7:
		INY
		LDA	($FA),Y
		ASL	A
		STA	unk_1087,X
		TAY
		CLC
		BCC	loc_14C0

		.TEXT 'VOICETRACK 5'

arpeggio_01:
		.BYTE $FF
arpeggio_02:
		.BYTE $FF
arpeggio_03:
		.BYTE $FF
arpeggio_04:
		.BYTE $FF
arpeggio_05:
		.BYTE $FF
arpeggio_06:
		.BYTE $FF
arpeggio_07:
		.BYTE $FF
arpeggio_08:
		.BYTE $FF
arpeggio_09:
		.BYTE $FF
arpeggio_0A:
		.BYTE $FF
arpeggio_0B:
		.BYTE $FF
arpeggio_0C:
		.BYTE $FF
arpeggio_0D:
		.BYTE $FF
arpeggio_0E:
		.BYTE $FF
arpeggio_0F:
		.BYTE $FF

unk_14ED:	.BYTE	0		; presets
					; 00
unk_14EE:	.BYTE	0
unk_14EF:	.BYTE	0
unk_14F0:	.BYTE	0
unk_14F1:	.BYTE	0
unk_14F2:	.BYTE	0
unk_14F3:	.BYTE	0
unk_14F4:	.BYTE	0
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	01
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	02
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	03
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	04
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	05
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	06
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	07
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	08
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	09
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	0A
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	0B
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	0C
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	0D
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	0E
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	0F
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	10
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	11
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	12
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	13
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	14
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	15
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	16
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	17
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	18
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	19
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	1A
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	1B
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	1C
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	1D
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	1E
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	1F

ch1_tracks:
		.BYTE	0,  0
		.BYTE $FF
ch2_tracks:
		.BYTE	0,  0
		.BYTE $FF
ch3_tracks:
		.BYTE	0,  0
		.BYTE $FF

		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;	sequence data will follow here
		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

byte_1670:
		.BYTE $15,$15,$15,$15,$15,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16 ;	sequence address msb
		.BYTE $16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16
		.BYTE $16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16
		.BYTE $16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,  0
byte_16AE:
		.BYTE $F6,$F8,$FA,$FC,$FE,  0,	2,  4,	6,  8, $A, $C, $E,$10,$12,$14 ;	sequence address lsb
		.BYTE $16,$18,$1A,$1C,$1E,$20,$22,$24,$26,$28,$2A,$2C,$2E,$30,$32,$34
		.BYTE $36,$38,$3A,$3C,$3E,$40,$42,$44,$46,$48,$4A,$4C,$4E,$50,$52,$54
		.BYTE $56,$58,$5A,$5C,$5E,$60,$62,$64,$66,$68,$6A,$6C,$6E,  0

		.TEXT '**END OF MUSIC**'

		.END
