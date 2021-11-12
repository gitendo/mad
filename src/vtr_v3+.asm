; VoiceTracker V3+ replay routine disassembly
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

		.BYTE	0

sub_1021:				; player update
		LDX	#0
		DEC	byte_1090
		BMI	loc_1034
		JSR	loc_1226
		JSR	sub_1225
		JMP	sub_1225

unk_1031:
		.BYTE $FE
		.BYTE $FE
		.BYTE $FE

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
		LDA	unk_14B9,X	; track	order lsb
		STA	$FA
		LDA	unk_14BC,X	; track	order msb
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
		.BYTE	0
		.BYTE	0
unk_1087:
		.BYTE	0
		.BYTE	0
		.BYTE	0
unk_108A:
		.BYTE $1F
		.BYTE	0
		.BYTE	0
unk_108D:
		.BYTE	0
		.BYTE	1
		.BYTE	1
byte_1090:
		.BYTE	1

loc_1091:
		LDY	unk_108D,X
		CPY	#$FE 
		BNE	loc_10A1

loc_1098:
		LDA	unk_1084,X
		AND	#$FE 
		STA	unk_1084,X
		RTS

loc_10A1:
		LDA	byte_17D5,Y	; sequence array Lsb
		STA	$FA
		LDA	byte_1797,Y	; sequence array msb
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
		JSR	loc_1098

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
		.BYTE $5E
		.BYTE $D0
		.BYTE $D0
unk_10CF:
		.BYTE $1B
		.BYTE $22
		.BYTE $22

loc_10D2:
		CMP	#$A0
		BCC	loc_10EC
		AND	#$1F
		STA	unk_108A,X
		BCS	loc_10C3

loc_10DD:

		ASL	A
		BRK
		.BYTE	0

unk_10E0:
		.BYTE	0
		.BYTE	0
		.BYTE	0
unk_10E3:
		.BYTE	0
		.BYTE	0
		.BYTE	0
unk_10E6:
		.BYTE	0
		.BYTE	1
		.BYTE	1
unk_10E9:
		.BYTE	0
		.BYTE	1
		.BYTE	1

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
		.BYTE $40
		.BYTE $40
		.BYTE $40
unk_1144:
		.BYTE	0
		.BYTE $24
		.BYTE $24
unk_1147:
		.BYTE	9
		.BYTE	0
		.BYTE	0
unk_114A:
		.BYTE	0
		.BYTE	1
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
		LDA	unk_14B9,X	; track	order lsb
		STA	$FA
		LDA	unk_14BC,X	; track	order msb
		STA	$FB
		LDY	unk_1087,X
		INY
		INY
		LDA	($FA),Y
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
		LDA	unk_1613,Y	; presets
					; 00
		STA	$FA
		LDA	unk_1614,Y
		LDY	unk_10C6,X
		STA	$D406,Y
		LDA	$FA
		STA	$D405,Y
		LDA	unk_1084,X
		AND	#$FE 
		STA	$D404,Y
		LDY	$FC
		LDA	unk_1615,Y
		STA	unk_1084,X
		LDA	unk_1616,Y
		STA	unk_13DC,X
		STA	unk_13DF,X

loc_1261:

		CPX	#0
		BNE	loc_126F

loc_1265:
		LDA	#$78 
		STA	loc_129D+1

loc_126A:
		LDA	#$18
		STA	loc_1295+1

loc_126F:
		LDA	#0
		STA	unk_10E0,X
		STA	unk_10E3,X
		LDA	unk_1618,Y
		LSR	A
		LSR	A
		LSR	A
		STA	unk_114D,X
		LDA	unk_1141,X
		ORA	#$40 
		STA	unk_1141,X
		LDA	unk_161A,Y
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
		LDA	#$78 

loc_129F:
		ADC	#0
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
		.BYTE $11
		.BYTE $22
		.BYTE $22
unk_12B9:
		.BYTE $FF
		.BYTE $FF
		.BYTE $FF
		.BYTE	0
unk_12BD:
		.BYTE $16
		.BYTE	0
		.BYTE	0
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
		SBC	unk_1619,Y
		STA	unk_10CC,X
		BCS	loc_130D
		DEC	unk_10CF,X
		BNE	loc_130D

loc_12FA:
		LDY	$FC
		CLC
		LDA	unk_10CC,X
		ADC	unk_1619,Y
		STA	unk_10CC,X
		BCC	loc_130D
		INC	unk_10CF,X
		BCS	loc_130D

loc_130D:
		INC	loc_10DD,X
		LDA	unk_1618,Y
		AND	#$F
		CMP	loc_10DD,X
		BNE	loc_1322
		LDA	#0
		STA	loc_10DD,X
		INC	unk_12BD,X

loc_1322:
		LDY	$FC
		LDA	unk_1617,Y
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
		.BYTE	0
		.BYTE $18
		.BYTE $18
unk_13DC:
		.BYTE	0
		.BYTE $EC
		.BYTE $D4
unk_13DF:
		.BYTE	0
		.BYTE $70
		.BYTE $54
unk_13E2:
		.BYTE $68
		.BYTE $D0
		.BYTE $D0

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
		LDY	#$3C 
		LDA	byte_1437,Y	; sid frequency	array lsb
		STA	unk_10CC,X
		LDA	byte_11C5,Y	; sid frequency	array msb
		STA	unk_10CF,X
		RTS

byte_1437:	.BYTE $16,$27,$38,$4B,$5F,$73,$8A,$A1,$BA,$D4,$F0, $E,$2D,$4E,$71,$96 ;	sid frequency array lsb
		.BYTE $BD,$E7,$13,$42,$74,$A9,$E0,$1B,$5A,$9B,$E2,$2C,$7B,$CE,$27,$85
		.BYTE $E8,$51,$C1,$37,$B4,$37,$C4,$57,$F5,$9C,$4E,  9,$D0,$A3,$82,$6E
		.BYTE $68,$6E,$88,$AF,$EB,$39,$9C,$13,$A1,$46,	4,$DC,$D0,$DC,$10,$5E
		.BYTE $D6,$72,$38,$26,$42,$8C,	8,$B8,$A0,$B8,$20,$BC,$AC,$E4,$70,$4C
		.BYTE $84,$18,$10,$70,$40,$70,$40,$78,$58,$C8,$E0,$98,	8,$30,$20,$2E
		.BYTE $67
byte_1498:	
		.BYTE $69,$DE,$EB,$FB,	5,$12,$37,$4A,$5A,$64,$7D,$96,$AF,$C8,$E1,$FA ; arpeggio array lsb
byte_14A8:
		.BYTE $E0,$14,$14,$14,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15 ; arpeggio array msb
		.BYTE $22

unk_14B9:
		.BYTE $13		; track	order lsb
		.BYTE $16
		.BYTE $19
unk_14BC:
		.BYTE $17		; track	order msb
		.BYTE $17
		.BYTE $17

		.TEXT ' -VOICETRACKER V2+ SCIENCE 451 '

arpeggio_01:
		.BYTE $81,$FF,	0
		.BYTE $41,$A9,	0
		.BYTE $10,$A9,	0
		.BYTE $10,$A3,	0
		.BYTE $FE
arpeggio_02:
		.BYTE $81,$DF,	0
		.BYTE $11,$A4,	0
		.BYTE $40,$A9,	0
		.BYTE $80,$FF,	0
		.BYTE $80,$C1,	0
		.BYTE $FE
arpeggio_03:
		.BYTE $81,$FF,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $FE
arpeggio_04:
		.BYTE $11,  0,	0
		.BYTE $41,  0,	0
		.BYTE $21,  0,	0
		.BYTE $21,  0,	0
		.BYTE $FE
arpeggio_05:
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $FE
arpeggio_06:
		.BYTE $11,  0,	0
		.BYTE $11,  0,	0
		.BYTE $41, $C,	0
		.BYTE $41, $C,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $FF
arpeggio_07:
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $FE
arpeggio_08:
		.BYTE $81,  0,	0
		.BYTE $81, $C,	0
		.BYTE $81,  0,	0
		.BYTE $FF
arpeggio_09:
		.BYTE $41, $C,	0
		.BYTE $41, $C,	0
		.BYTE $41,  6,	0
		.BYTE $41,  6,	0
		.BYTE $41,  3,	0
		.BYTE $41,  3,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $FF
arpeggio_0A:
		.BYTE $41, $C,	0
		.BYTE $41, $C,	0
		.BYTE $41,  7,	0
		.BYTE $41,  7,	0
		.BYTE $41,  3,	0
		.BYTE $41,  3,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $FF
arpeggio_0B:
		.BYTE $41, $C,	0
		.BYTE $41, $C,	0
		.BYTE $41,  8,	0
		.BYTE $41,  8,	0
		.BYTE $41,  3,	0
		.BYTE $41,  3,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $FF
arpeggio_0C:
		.BYTE $41, $C,	0
		.BYTE $41, $C,	0
		.BYTE $41,  5,	0
		.BYTE $41,  5,	0
		.BYTE $41,  3,	0
		.BYTE $41,  3,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $FF
arpeggio_0D:
		.BYTE $41, $C,	0
		.BYTE $41, $C,	0
		.BYTE $41,  7,	0
		.BYTE $41,  7,	0
		.BYTE $41,  4,	0
		.BYTE $41,  4,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $FF
arpeggio_0E:
		.BYTE $41, $C,	0
		.BYTE $41, $C,	0
		.BYTE $41,  9,	0
		.BYTE $41,  9,	0
		.BYTE $41,  4,	0
		.BYTE $41,  4,	0
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $FF
arpeggio_0F:
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $11, $C,	0
		.BYTE $11,  0,	0
		.BYTE $11,  0,	0
		.BYTE $11,  0,	0
		.BYTE $11,  0,	0
		.BYTE $11,  0,	0
		.BYTE $FE

unk_1613:	.BYTE  $E		; presets
					; 00
unk_1614:	.BYTE $98
unk_1615:	.BYTE	9
unk_1616:	.BYTE	8
unk_1617:	.BYTE	8
unk_1618:	.BYTE	0
unk_1619:	.BYTE	0
unk_161A:	.BYTE $51
		.BYTE  $F,$A7,	9,  8,	0,  0,	0,  2 ;	01
		.BYTE  $B,$42,$11,$45,$30,  0,	0,$53 ;	02
		.BYTE	9,$88,	9,$44,$40,  0,	0,$44 ;	03
		.BYTE	9,$88,	9,$44,$40,  0,	0,$45 ;	04
		.BYTE	9,$88,	9,$44,$40,  0,	0,$46 ;	05
		.BYTE	9,$45,	9,$12,$40,  0,	0,$56 ;	06
		.BYTE  $C,$79,$21,  2,$30,$22,$F1,$55 ;	07
		.BYTE  $C,$89,$41,$2C,$40,$22,$40,$57 ;	08
		.BYTE	9,$84,$11,  8,$21,  0,	0,  4 ;	09
		.BYTE	6,  0,	9,  0,	0,  0,	0,  7 ;	0A
		.BYTE	6,  0,	9,  0,	0,  0,	0,  8 ;	0B
		.BYTE	9,$89,$41,$40,$40,$F2,$40,$50 ;	0C
		.BYTE	7,$69,$43,$40,$40,  0,	0,$40 ;	0D
		.BYTE	6,  8,	9,  8,	0,  0,$FF,$1B ;	0E
		.BYTE	3,$38,	9,  8,	0,  0,	0,$42 ;	0F
		.BYTE  $A,$40,$41,$12,$40,  0,	0,$5A ;	10
		.BYTE  $A,$40,$41,$12,$40,  0,	0,$5B ;	11
		.BYTE  $A,$40,$41,$12,$40,  0,	0,$5C ;	12
		.BYTE  $A,$40,$41,$12,$40,  0,	0,$5D ;	13
		.BYTE  $A,$40,$41,$12,$40,  0,	0,$5E ;	14
		.BYTE  $A,$A9,$13,  0,	0,  0,	0, $F ;	15
		.BYTE  $A,$84,$41,$12,$40,  0,	0,$59 ;	16
		.BYTE	7,$40,$41,  8,$81,$42,$40,$59 ;	17
		.BYTE  $A,$4A,$81,  0,	0,  0,	0,$88 ;	18
		.BYTE $CA,$A0,$81,  0,	0,  0,	0,  0 ;	19
		.BYTE	9,$80,$21,  0,	0,  0,	0,$40 ;	1A
		.BYTE  $A,$70,$13,  0,	0,$FF,$FF,$10 ;	1B
		.BYTE  $A,$AE,	8,  8,$40,$22,$40,$5F ;	1C
		.BYTE	2,  0,	2,  0,	2,$21,	0,  5 ;	1D
		.BYTE	6,  0,	0, $F,$FF,  1,	0,  1 ;	1E
		.BYTE	0,  1,$20,  1,$20,  1,	0,  7 ;	1F

ch1_tracks:
		.BYTE	1,  0
		.BYTE $FF
ch2_tracks:
		.BYTE	1,  0
		.BYTE $FF
ch3_tracks:
		.BYTE	1,  0
		.BYTE $FF

		.BYTE $FF,$FF,$80,$60,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;	sequence data will be here
		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;	data below will	get moved forward
		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

byte_1797:
		.BYTE $17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17 ;	sequence array msb
		.BYTE $17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17
		.BYTE $17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17
		.BYTE $17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,  0
byte_17D5:
		.BYTE $1C,$1E,$21,$23,$25,$27,$29,$2B,$2D,$2F,$31,$33,$35,$37,$39,$3B ;	sequence array Lsb
		.BYTE $3D,$3F,$41,$43,$45,$47,$49,$4B,$4D,$4F,$51,$53,$55,$57,$59,$5B
		.BYTE $5D,$5F,$61,$63,$65,$67,$69,$6B,$6D,$6F,$71,$73,$75,$77,$79,$7B
		.BYTE $7D,$7F,$81,$83,$85,$87,$89,$8B,$8D,$8F,$91,$93,$95,  0

		.TEXT '**END OF MUSIC**'

		.END
