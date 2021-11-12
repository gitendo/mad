; VoiceTracker V2 replay routine disassembly
; https://github.com/gitendo/mad

*		= $1000

loc_1000:
		JMP	sub_1048	; player init

loc_1003:
		JMP	sub_1021	; player update

sub_1006:
		SEI			; raster player
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

unk_1031:	.BYTE $FE
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
		.BYTE $50
		.BYTE	0
unk_1087:
		.BYTE	0
		.BYTE	0
		.BYTE	0
unk_108A:
		.BYTE $1F
		.BYTE $13
		.BYTE $13
unk_108D:
		.BYTE	0
		.BYTE	0
		.BYTE	0
byte_1090:
		.BYTE	2	

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
		LDA	byte_16D2,Y	; sequence array lsb
		STA	$FA
		LDA	byte_16B3,Y	; sequence array msb
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
		.BYTE $67
		.BYTE $67
		.BYTE $CE
unk_10CF:
		.BYTE $E8
		.BYTE $E8
		.BYTE	5

loc_10D2:
		CMP	#$A0 
		BCC	loc_10EC
		AND	#$1F
		STA	unk_108A,X
		BCS	loc_10C3

loc_10DD:
		BRK
		.BYTE	0
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
		.BYTE $42
		.BYTE $45
		.BYTE $42
unk_1144:
		.BYTE  $C
		.BYTE	6
		.BYTE	0
unk_1147:
		.BYTE	0
		.BYTE	0
		.BYTE $4C
unk_114A:
		.BYTE	2
		.BYTE	2
		.BYTE $B3
unk_114D:
		.BYTE	0
		.BYTE	1
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
		LDA	unk_156E,Y	; presets
					; 00
		STA	$FA
		LDA	unk_156F,Y
		LDY	unk_10C6,X
		STA	$D406,Y
		LDA	$FA
		STA	$D405,Y
		LDA	unk_1084,X
		AND	#$FE 
		STA	$D404,Y
		LDY	$FC
		LDA	unk_1570,Y
		STA	unk_1084,X
		LDA	unk_1571,Y
		STA	unk_13DC,X
		STA	unk_13DF,X

loc_1261:
		CPX	#0
		BNE	loc_126F

loc_1265:
		LDA	#$1F
		STA	loc_129D+1

loc_126A:
		LDA	#$14
		STA	loc_1295+1

loc_126F:
		LDA	#0
		STA	unk_10E0,X
		STA	unk_10E3,X
		LDA	unk_1573,Y
		LSR	A
		LSR	A
		LSR	A
		STA	unk_114D,X
		LDA	unk_1141,X
		ORA	#$40 
		STA	unk_1141,X
		LDA	unk_1575,Y
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
		ADC	#$E
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
		.BYTE $15
		.BYTE $22
		.BYTE	5
unk_12B9:
		.BYTE $FF
		.BYTE $FF
		.BYTE $FF
		.BYTE	0
unk_12BD:
		.BYTE	0
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
		SBC	unk_1574,Y
		STA	unk_10CC,X
		BCS	loc_130D
		DEC	unk_10CF,X
		BNE	loc_130D

loc_12FA:
		LDY	$FC
		CLC
		LDA	unk_10CC,X
		ADC	unk_1574,Y
		STA	unk_10CC,X
		BCC	loc_130D
		INC	unk_10CF,X
		BCS	loc_130D

loc_130D:
		INC	loc_10DD,X
		LDA	unk_1573,Y
		AND	#$F
		CMP	loc_10DD,X
		BNE	loc_1322
		LDA	#0
		STA	loc_10DD,X
		INC	unk_12BD,X

loc_1322:
		LDY	$FC
		LDA	unk_1572,Y
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
		.BYTE	0
		.BYTE	0
unk_13DC:
		.BYTE	0
		.BYTE $C4
		.BYTE $45
unk_13DF:
		.BYTE	0
		.BYTE $CC
		.BYTE $4C
unk_13E2:
		.BYTE $EB
		.BYTE $D0
		.BYTE $CE

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
		LDY	#$60 
		LDA	byte_1437,Y	; sid frequency	array lsb
		STA	unk_10CC,X
		LDA	byte_11C5,Y	; sid frequency	array msb
		STA	unk_10CF,X
		RTS

byte_1437:
		.BYTE $16,$27,$38,$4B,$5F,$73,$8A,$A1,$BA,$D4,$F0, $E,$2D,$4E,$71,$96	; sid frequency array lsb
		.BYTE $BD,$E7,$13,$42,$74,$A9,$E0,$1B,$5A,$9B,$E2,$2C,$7B,$CE,$27,$85
		.BYTE $E8,$51,$C1,$37,$B4,$37,$C4,$57,$F5,$9C,$4E,  9,$D0,$A3,$82,$6E
		.BYTE $68,$6E,$88,$AF,$EB,$39,$9C,$13,$A1,$46,	4,$DC,$D0,$DC,$10,$5E
		.BYTE $D6,$72,$38,$26,$42,$8C,	8,$B8,$A0,$B8,$20,$BC,$AC,$E4,$70,$4C
		.BYTE $84,$18,$10,$70,$40,$70,$40,$78,$58,$C8,$E0,$98,	8,$30,$20,$2E
		.BYTE $67

byte_1498:
		.BYTE $69,$DE,$EE,  1, $E,$1B,$25,$3E,$48,$52,$5C,$63,$64,$65,$66,$67	; arpeggio array lsb

byte_14A8:
		.BYTE $E0,$14,$14,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15	; arpeggio array msb
		.BYTE $F4

unk_14B9:
		.BYTE $6E		; track	order lsb
		.BYTE $71
		.BYTE $74

unk_14BC:
		.BYTE $16		; track	order msb
		.BYTE $16
		.BYTE $16

		.TEXT ' -VOICETRACKER V2+ SCIENCE 451 '

arpeggio_01:
		.BYTE $81,$DF,	0
		.BYTE $41,$9F,	0
		.BYTE $41,$98,	0
		.BYTE $11,$98,	0
		.BYTE $10,$98,	0
		.BYTE $FE
arpeggio_02:
		.BYTE $81,$DF,	0
		.BYTE $11,$A4,	0
		.BYTE $40,$A9,	0
		.BYTE $40,$A9,	0
		.BYTE $80,$DF,	0
		.BYTE $80,$FE,	0
		.BYTE $FE
arpeggio_03:
		.BYTE $81,$DA,	0
		.BYTE $11, $C,	0
		.BYTE $11,  2,	0
		.BYTE $11,  0,	0
		.BYTE $FE
arpeggio_04:
		.BYTE $81,$DF,	0
		.BYTE $21,  0,	0
		.BYTE $21,  0,	0
		.BYTE $41,  0,	0
		.BYTE $FE
arpeggio_05:
		.BYTE $81,$DA,	0
		.BYTE $41, $C,	0
		.BYTE $41,  0,	0
		.BYTE $FE
arpeggio_06:
		.BYTE $11, $C,	0
		.BYTE $51,  0,	0
		.BYTE $41,  0,	0
		.BYTE $21,  0,	0
		.BYTE $21,  0,	0
		.BYTE $21,  0,	0
		.BYTE $21,  0,	0
		.BYTE $21,  0,	0
		.BYTE $FE
arpeggio_07:
		.BYTE $41, $C,	0
		.BYTE $41,  0,	0
		.BYTE $11,  0,	0
		.BYTE $FE
arpeggio_08:
		.BYTE $41,  0,	0
		.BYTE $41,  5,	0
		.BYTE $41,  9,	0
		.BYTE $FF
arpeggio_09:
		.BYTE $21,  0,	0
		.BYTE $21,  4,	0
		.BYTE $21,  7,	0
		.BYTE $FF
arpeggio_0A:
		.BYTE $41, $C,	0
		.BYTE $41,  0,	0
		.BYTE $FE
arpeggio_0B:
		.BYTE $FF
arpeggio_0C:
		.BYTE $FF
arpeggio_0D:
		.BYTE $FF
arpeggio_0E:
		.BYTE $FF
arpeggio_0F:
		.BYTE $11, $C,	0
		.BYTE $51,  0,	0
		.BYTE $FE

unk_156E:
		.BYTE  $A		; presets
					; 00
unk_156F:	.BYTE	8
unk_1570:	.BYTE	9
unk_1571:	.BYTE	8
unk_1572:	.BYTE	0
unk_1573:	.BYTE	0
unk_1574:	.BYTE	0
unk_1575:	.BYTE	1
		.BYTE	9,$A8,	9,  8,	0,  0,	0,  2 ;	01
		.BYTE $14,$13,	1,  0,	0,  0,	0,  3 ;	02
		.BYTE $E8, $D,$41,  4,$10,$63,	7,$50 ;	03
		.BYTE  $A,$71,	1,  3,	0,  0,	0, $F ;	04
		.BYTE	8,$80,$41,  0,	0,  0,	0,  5 ;	05
		.BYTE	8, $C,	9,$14,$40,  0,	0,$44 ;	06
		.BYTE	8,$95,$41,$10,$40,$23,$25,$3A ;	07
		.BYTE	9,  6,	9,$44,$40,$22,$40,$56 ;	08
		.BYTE	6,$77,$41,  9,$30,  0,	0,$44 ;	09
		.BYTE	9,$87,	9,$40,$40,  0,	0,$48 ;	0A
		.BYTE	8,$86,$41,$40,$40,  0,	0,$45 ;	0B
		.BYTE	2,$30,$41,$15,$43,  2,$CA,$57 ;	0C
		.BYTE $51,$3D,$41,$44,$40,$42,$46,$50 ;	0D
		.BYTE	8,$9E,$41,$45,$40,  0,	0,$40 ;	0E
		.BYTE  $A,  6,$81,  0,	0,  0,	0,  0 ;	0F
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	10
		.BYTE $4F,$6F,$FF,$8D,$18,$3F,$30,  0 ;	11
		.BYTE $BF,$BF,$BF,$FF,$86,$30,$3F,$F0 ;	12
		.BYTE $1F,$BF,$BF,$BF,$FF,$8D,$3C,$3F ;	13
		.BYTE $F0,$FF,$BF,$BF,$7F,$FF,$87,$24 ;	14
		.BYTE $3F,$20,	0,$BF,$BF,$7F,$FF,$8D ;	15
		.BYTE $30,$3F,$D1,$FF,$7F,$7F,$7F,$FF ;	16
		.BYTE $8F,$18,$9F,$87,$FF,$7F,$7F,$7F ;	17
		.BYTE $FF,$8F,$18,$1F,$7F,$7F,$7F,$FF ;	18
		.BYTE $16,$16,$16,$17,$17,$17,$17,$17 ;	19
		.BYTE $17,$18,$18,$18,$18,$18,$19,$19 ;	1A
		.BYTE $19,$19,$1A,$1A,$1A,$1A,$1A,$1B ;	1B
		.BYTE $1B,$1B,$1B,$1B,$1B,$1B,	0,$B8 ;	1C
		.BYTE $BA,$FF,$4D,$56,$6C,$8F,$B5,$E1 ;	1D
		.BYTE	7,$26,$48,$96,$DB, $E,$42,$84 ;	1E
		.BYTE $C3,$11,$51,$88,$CD,$F6,$23,$2C ;	1F

ch1_tracks:
		.BYTE	0,  0
		.BYTE $FF
ch2_tracks:
		.BYTE	0,  0
		.BYTE $FF
ch3_tracks:
		.BYTE	0,  0
		.BYTE $FF

		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;	sequence data will be here
		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;	data below will	get moved forward
		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
byte_16B3:
		.BYTE $16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16 ; sequence array msb
		.BYTE $16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,	0
byte_16D2:
		.BYTE $77,$79,$7B,$7D,$7F,$81,$83,$85,$87,$89,$8B,$8D,$8F,$91,$93,$95 ; sequence array lsb
		.BYTE $97,$99,$9B,$9D,$9F,$A1,$A3,$A5,$A7,$A9,$AB,$AD,$AF,$B1,	0

		.TEXT '**END OF MUSIC**'

		.END
