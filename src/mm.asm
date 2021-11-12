; Music Mixer replay routine disassembly
; Looks like VoiceTracker V5 routine
; https://github.com/gitendo/mad

*		= $1000

loc_1000:
		JMP	sub_1041	; player init

loc_1003:
		JMP	sub_107A	; player update

sub_1006:
		SEI
		JSR	loc_1000
		LDA	#$7F 
		STA	$DC0D
		LDA	#1
		STA	$D01A
		LDA	#$20		; <irq_handler
		LDX	#$10		; >irq_handler
		STA	$314
		STX	$315
		CLI
		RTS

irq_handler:
		JSR	loc_1003
		INC	$D019
		JMP	$EA31

unk_1029:
		.BYTE $F7		; track	order lsb
		.BYTE $FB
		.BYTE $FF
unk_102C:
		.BYTE $16		; track	order msb
		.BYTE $16
		.BYTE $16

		.TEXT '.................'
		.BYTE $2D

sub_1041:				; player init
		LDA	#$1F
		STA	$D418
		LDA	#$F0 
		STA	$D417
		AND	#$F
		STA	loc_12A5+1
		LDX	#$F

loc_1052:
		STA	unk_10A5,X
		DEX
		BPL	loc_1052
		LDX	#2

loc_105A:
		LDA	unk_1029,X	; track	order lsb
		STA	$FA
		LDA	unk_102C,X	; track	order msb
		STA	$FB
		LDY	#0
		LDA	($FA),Y
		STA	unk_10B1,X
		INY
		LDA	($FA),Y
		STA	unk_110A,X
		AND	#$F
		STA	unk_110D,X
		DEX
		BPL	loc_105A
		RTS

sub_107A:				; player update
		LDX	#0
		DEC	byte_10B4
		BMI	loc_1091
		JSR	loc_126A
		LDX	#1
		JSR	loc_126A
		LDX	#2
		JMP	loc_126A

unk_108E:
		.BYTE $FE
		.BYTE $FE
		.BYTE $FE

loc_1091:

		LDA	#2
		STA	byte_10B4
		JSR	loc_109D
		JSR	loc_109C

loc_109C:
		INX

loc_109D:
		DEC	unk_10AE,X
		BMI	loc_10B5
		JMP	loc_126A

unk_10A5:
		.BYTE	0
		.BYTE	0
		.BYTE	0
unk_10A8:
		.BYTE	0
		.BYTE	0
		.BYTE	0
unk_10AB:
		.BYTE	0
		.BYTE	0
		.BYTE	0
unk_10AE:
		.BYTE $1F
		.BYTE	0
		.BYTE	0
unk_10B1:
		.BYTE	0
		.BYTE	0
		.BYTE	0
byte_10B4:
		.BYTE	2

loc_10B5:
		LDY	unk_10B1,X
		CPY	#$FE 
		BNE	loc_10C5

loc_10BC:
		LDA	unk_10A8,X
		AND	#$FE 
		STA	unk_10A8,X
		RTS

loc_10C5:
		LDA	byte_1745,Y	; sequence address lsb
		STA	$FA
		LDA	byte_1705,Y	; sequence address msb
		STA	$FB
		LDY	unk_10A5,X
		LDA	($FA),Y
		BMI	loc_10F6
		CMP	#$60 
		BCC	loc_111D

loc_10DA:
		AND	#$1F
		STA	unk_10AE,X
		LDA	#$FE 
		STA	unk_108E,X
		JSR	loc_10BC

loc_10E7:
		JMP	loc_11AB

unk_10EA:
		.BYTE	0
		.BYTE	7
		.BYTE  $E
unk_10ED:
		.BYTE  $C
		.BYTE	0
		.BYTE	0
unk_10F0:
		.BYTE $5A
		.BYTE $16
		.BYTE $16
unk_10F3:
		.BYTE	4
		.BYTE	1
		.BYTE	1

loc_10F6:
		CMP	#$A0 
		BCC	loc_1110
		AND	#$1F
		STA	unk_10AE,X
		BCS	loc_10E7

loc_1101:
		BRK
		.BYTE	0
		.BYTE	0
unk_1104:
		.BYTE  $E
		.BYTE	0
		.BYTE $98
unk_1107:
		.BYTE	0
		.BYTE	0
		.BYTE	0
unk_110A:
		.BYTE	0
		.BYTE	0
		.BYTE	0
unk_110D:
		.BYTE	0
		.BYTE	0
		.BYTE	0

loc_1110:
		ASL	A
		ASL	A
		ASL	A
		STA	unk_141D,X
		INY
		LDA	($FA),Y
		CMP	#$60 
		BCS	loc_10DA

loc_111D:
		STA	$FC
		INY
		LDA	unk_110A,X
		LSR	A
		LSR	A
		LSR	A
		LSR	A
		CLC
		ADC	$FC
		STA	unk_10ED,X
		STY	$FC
		TAY
		LDA	byte_149E,Y	; sid frequency	array lsb
		STA	unk_10F0,X
		STA	unk_1426,X
		LDA	byte_1209,Y	; sid frequency	array msb
		STA	unk_10F3,X
		STA	unk_12FA,X
		LDY	$FC
		LDA	($FA),Y
		STA	$1165,X
		AND	#$1F
		STA	unk_10AE,X
		LDA	($FA),Y
		BMI	loc_1174
		AND	#$20 
		BEQ	loc_119B
		INY
		LDA	($FA),Y
		STA	unk_116B,X
		INY
		LDA	($FA),Y
		STA	unk_116E,X
		JMP	loc_119B

unk_1165:
		.BYTE $C7
		.BYTE $5F
		.BYTE $5F
unk_1168:
		.BYTE	6
		.BYTE	0
		.BYTE	0
unk_116B:
		.BYTE $90
		.BYTE $DF
		.BYTE $90
unk_116E:
		.BYTE $FF
		.BYTE $FF
		.BYTE $FF
unk_1171:
		.BYTE	4
		.BYTE	0
		.BYTE	0

loc_1174:
		STX	loc_12A5+1
		INY
		LDA	($FA),Y
		STA	loc_12A9+1
		AND	#$F
		ASL	A
		SEC
		SBC	#$10
		STA	loc_12E3+1
		INY
		LDA	($FA),Y
		BNE	loc_1192
		LDA	#$F0 
		STA	$D417
		BNE	loc_119B

loc_1192:
		STA	loc_12AE+1
		LDA	unk_12F7,X
		STA	$D417

loc_119B:
		LDA	#$FF
		STA	unk_108E,X
		STA	unk_12FD,X
		LDA	#0
		STA	loc_1101,X
		STA	unk_1301,X

loc_11AB:
		INY
		LDA	($FA),Y
		CMP	#$FF
		BNE	loc_1204
		DEC	unk_110D,X
		BPL	loc_1202
		LDA	unk_1029,X	; track	order lsb
		STA	$FA
		LDA	unk_102C,X	; track	order msb
		STA	$FB
		LDY	unk_10AB,X
		INY
		INY

loc_11C6:
		LDA	($FA),Y
		CMP	#$FC 
		BNE	loc_11D9
		INY
		LDA	($FA),Y
		STA	loc_1091+1
		STA	byte_10B4
		INY
		JMP	loc_11C6

loc_11D9:
		CMP	#$FD 
		BNE	loc_11E8
		INY
		LDA	($FA),Y
		ASL	A
		STA	unk_10AB,X
		TAY
		JMP	loc_11C6

loc_11E8:
		CMP	#$FF
		BNE	loc_11EE
		LDY	#0

loc_11EE:
		TYA
		STA	unk_10AB,X
		LDA	($FA),Y
		STA	unk_10B1,X
		INY
		LDA	($FA),Y
		STA	unk_110A,X
		AND	#$F
		STA	unk_110D,X

loc_1202:
		LDY	#0

loc_1204:
		TYA
		STA	unk_10A5,X
		RTS

byte_1209:	.BYTE	1,  1,	1,  1,	1,  1,	1,  1,	1,  1,	1,  2,	2,  2,	2,  2 ;	sid frequency array msb
		.BYTE	2,  2,	3,  3,	3,  3,	3,  4,	4,  4,	4,  5,	5,  5,	6,  6
		.BYTE	6,  7,	7,  8,	8,  9,	9, $A, $A, $B, $C, $D, $D, $E, $F,$10
		.BYTE $11,$12,$13,$14,$15,$17,$18,$1A,$1B,$1D,$1F,$20,$22,$24,$27,$29
		.BYTE $2B,$2E,$31,$34,$37,$3A,$3E,$41,$45,$49,$4E,$52,$57,$5C,$62,$68
		.BYTE $6E,$75,$7C,$83,$8B,$93,$9C,$A5,$AF,$B9,$C4,$D0,$DD,$EA,$F8,$FD
		.BYTE $E8

loc_126A:
		LDY	unk_141D,X
		STY	$FC
		LDA	unk_1165,X
		AND	#$40 
		BNE	loc_12D4
		STA	unk_1168,X
		LDA	unk_160F,Y	; presets
					; 00
		STA	$FA
		LDA	unk_1610,Y
		LDY	unk_10EA,X
		STA	$D406,Y
		LDA	$FA
		STA	$D405,Y
		LDA	unk_10A8,X
		AND	#$FE 
		STA	$D404,Y
		LDY	$FC
		LDA	unk_1611,Y
		STA	unk_10A8,X
		LDA	unk_1612,Y
		STA	unk_1420,X
		STA	unk_1423,X

loc_12A5:
		CPX	#0
		BNE	loc_12B3

loc_12A9:
		LDA	#$A5 
		STA	loc_12E1+1

loc_12AE:
		LDA	#8
		STA	loc_12D9+1

loc_12B3:
		LDA	#0
		STA	unk_1104,X
		STA	unk_1107,X
		LDA	unk_1614,Y
		LSR	A
		LSR	A
		LSR	A
		STA	unk_1171,X
		LDA	unk_1165,X
		ORA	#$40 
		STA	unk_1165,X
		LDA	unk_1616,Y
		STA	$FD,X
		JMP	loc_13C9

loc_12D4:
		CPX	loc_12A5+1
		BNE	loc_12EB

loc_12D9:
		LDA	#0
		BEQ	loc_12EB
		DEC	loc_12D9+1
		CLC

loc_12E1:
		LDA	#$28 

loc_12E3:
		ADC	#$FA 
		STA	loc_12E1+1
		STA	$D416

loc_12EB:
		LDA	$FD,X
		AND	#$F
		BEQ	loc_130B
		JSR	sub_1429
		JMP	loc_1366

unk_12F7:
		.BYTE $F1
		.BYTE $F3
		.BYTE $F7
unk_12FA:
		.BYTE	2
		.BYTE	1
		.BYTE	1
unk_12FD:
		.BYTE $FF
		.BYTE $FF
		.BYTE $FF
		.BYTE	0
unk_1301:
		.BYTE	0
		.BYTE	0
		.BYTE	0
		.BYTE	0
		.BYTE	0
		.BYTE	0
unk_1307:
		.BYTE	0
		.BYTE	1
		.BYTE	1
		.BYTE	0

loc_130B:
		LDA	unk_1165,X
		AND	#$20 
		BNE	loc_1366
		LDA	$FD,X
		AND	#$10
		BEQ	loc_1366
		DEC	unk_1171,X
		BPL	loc_1366
		INC	unk_1171,X
		LDA	unk_1301,X
		AND	#3
		TAY
		LDA	unk_1307,Y
		BNE	loc_133E
		LDY	$FC
		SEC
		LDA	unk_10F0,X
		SBC	unk_1615,Y
		STA	unk_10F0,X
		BCS	loc_1351
		DEC	unk_10F3,X
		BNE	loc_1351

loc_133E:
		LDY	$FC
		CLC
		LDA	unk_10F0,X
		ADC	unk_1615,Y
		STA	unk_10F0,X
		BCC	loc_1351
		INC	unk_10F3,X
		BCS	loc_1351

loc_1351:
		INC	loc_1101,X
		LDA	unk_1614,Y
		AND	#$F
		CMP	loc_1101,X
		BNE	loc_1366
		LDA	#0
		STA	loc_1101,X
		INC	unk_1301,X

loc_1366:
		LDY	$FC
		LDA	unk_1613,Y
		STA	$FC
		LDA	$FD,X
		AND	#$40 
		BEQ	loc_1387
		CLC
		LDA	$FC
		ADC	unk_1420,X
		STA	unk_1420,X
		LDA	$FC
		ADC	unk_1423,X
		STA	unk_1423,X
		JMP	loc_13C9

loc_1387:
		LDA	$FD,X
		AND	#$20 
		BEQ	loc_13C9
		LDA	unk_1107,X
		BEQ	loc_13A2
		CLC
		LDA	unk_1420,X
		ADC	$FC
		STA	unk_1420,X
		BCC	loc_13B0
		INC	unk_1423,X
		BCS	loc_13B0

loc_13A2:
		SEC
		LDA	unk_1420,X
		SBC	$FC
		STA	unk_1420,X
		BCS	loc_13B0
		DEC	unk_1423,X

loc_13B0:
		INC	unk_1104,X
		LDA	$FC
		AND	#$F
		CMP	unk_1104,X
		BNE	loc_13C9
		LDA	#0
		STA	unk_1104,X
		LDA	unk_1107,X
		EOR	#1
		STA	unk_1107,X

loc_13C9:
		LDY	unk_10EA,X
		LDA	unk_10A8,X
		STA	$D404,Y
		LDA	unk_1423,X
		STA	$D403,Y
		LDA	unk_1420,X
		STA	$D402,Y
		LDA	unk_1165,X
		AND	#$20 
		BEQ	loc_1410
		LDA	unk_116B,X
		AND	#1
		BEQ	loc_13F6
		LDA	unk_12FD,X
		EOR	#$FF
		STA	unk_12FD,X
		BNE	loc_1410

loc_13F6:
		CLC
		LDA	unk_1426,X
		ADC	unk_116B,X
		STA	unk_1426,X
		STA	$D400,Y
		LDA	unk_12FA,X
		ADC	unk_116E,X
		STA	unk_12FA,X
		STA	$D401,Y
		RTS


loc_1410:
		LDA	unk_10F0,X
		STA	$D400,Y
		LDA	unk_10F3,X
		STA	$D401,Y
		RTS

unk_141D:
		.BYTE $30
		.BYTE	0
		.BYTE	0
unk_1420:
		.BYTE $2A
		.BYTE	0
		.BYTE	0
unk_1423:
		.BYTE $A7
		.BYTE	0
		.BYTE	0
unk_1426:
		.BYTE $2D
		.BYTE $16
		.BYTE $16

sub_1429:
		TAY
		LDA	byte_14FF,Y	; arpeggio array lsb
		STA	$FA
		LDA	byte_150F,Y	; arpeggio array msb
		STA	$FB
		LDY	unk_1168,X
		LDA	($FA),Y
		AND	unk_108E,X
		STA	unk_10A8,X
		INY
		LDA	($FA),Y
		BMI	loc_1448
		CLC
		ADC	unk_10ED,X

loc_1448:
		AND	#$7F 
		STA	loc_148F+1
		INY
		LDA	($FA),Y
		BEQ	loc_1455
		STA	loc_12E1+1

loc_1455:
		INY
		LDA	($FA),Y
		CMP	#$FD 
		BNE	loc_147B
		INY
		LDA	unk_1168,X
		CLC
		ADC	#3
		STA	loc_1468+1
		LDA	($FA),Y

loc_1468:
		CMP	#$23 
		BCS	loc_1481
		CMP	#0
		BEQ	loc_1481
		TAY
		LDA	#0

loc_1473:
		CLC
		ADC	#3
		DEY
		BNE	loc_1473
		BEQ	loc_148C

loc_147B:
		CMP	#$FE 
		BCC	loc_148B
		BEQ	loc_1485

loc_1481:
		LDY	#0
		BEQ	loc_148B

loc_1485:
		LDA	$FD,X
		AND	#$F0 
		STA	$FD,X

loc_148B:
		TYA

loc_148C:
		STA	unk_1168,X

loc_148F:
		LDY	#$18
		LDA	byte_149E,Y	; sid frequency	array lsb
		STA	unk_10F0,X
		LDA	byte_1209,Y	; sid frequency	array msb
		STA	unk_10F3,X
		RTS

byte_149E:
		.BYTE $16,$27,$38,$4B,$5F,$73,$8A,$A1,$BA,$D4,$F0, $E,$2D,$4E,$71,$96 ;	sid frequency array lsb
		.BYTE $BD,$E7,$13,$42,$74,$A9,$E0,$1B,$5A,$9B,$E2,$2C,$7B,$CE,$27,$85
		.BYTE $E8,$51,$C1,$37,$B4,$37,$C4,$57,$F5,$9C,$4E,  9,$D0,$A3,$82,$6E
		.BYTE $68,$6E,$88,$AF,$EB,$39,$E0,$13,$A1,$46,	4,$DC,$D0,$DC,$10,$5E
		.BYTE $D6,$72,$38,$26,$42,$8C,	8,$B8,$A0,$B8,$20,$BC,$AC,$E4,$70,$4C
		.BYTE $84,$18,$10,$70,$40,$70,$40,$78,$58,$C8,$E0,$98,	8,$30,$20,$2E
		.BYTE $67

byte_14FF:
		.BYTE $69,$28,$37,$4F,$5E,$67,$70,$82,$8E,$A9,$AF,$C4,$D9,$DF,$F4, $C ; arpeggio array lsb
byte_150F:
		.BYTE $99,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$16 ; arpeggio array msb
		.BYTE $17

		.TEXT 'PLAYER.6'

arpeggio_01:
		.BYTE $81,$FF,	0
		.BYTE $41,$A8,	0
		.BYTE $40,$A1,	0
		.BYTE $10,$A3,	0
		.BYTE $FE,$FF,$FF
arpeggio_02:
		.BYTE $81,$DF,$40
		.BYTE $40,$AB,$60
		.BYTE $40,$A4,$80
		.BYTE $80,$F1,$80
		.BYTE $80,$FC,$80
		.BYTE $80,$DF,$80
		.BYTE $FD,  3,	0
		.BYTE $FF,$FF,$FF
arpeggio_03:
		.BYTE $81,$FF,$41
		.BYTE $40,  0,$31
		.BYTE $41,  0,$21
		.BYTE $41,  0,$21
		.BYTE $FE,$FF,$FF
arpeggio_04:
		.BYTE $81,$DF,	0
		.BYTE $40,  0,	0
		.BYTE $FE,$FF,$FF
arpeggio_05:
		.BYTE $41, $C,	0
		.BYTE $40,  0,	0
		.BYTE $FE,$FF,$FF
arpeggio_06:
		.BYTE $81,$DF,$50
		.BYTE $41,$18,$40
		.BYTE $40, $C,$38
		.BYTE $40, $C,$28
		.BYTE $FD,  2,	0
		.BYTE $FF,$FF,$FF
arpeggio_07:
		.BYTE $51,  0,	0
		.BYTE $51,  3,	0
		.BYTE $51,  8,	0
		.BYTE $FF,$FF,$FF
arpeggio_08:
		.BYTE $81,$DF,	0
		.BYTE $41,$18,	0
		.BYTE $41,$18,	0
		.BYTE $41, $C,	0
		.BYTE $41, $C,	0
		.BYTE $41, $C,	0
		.BYTE $41, $C,	0
		.BYTE $41, $C,	0
		.BYTE $FF,$FF,$FF
arpeggio_09:
		.BYTE $41, $C,	0
		.BYTE $FE,$FF,$FF
arpeggio_0A:
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $41,  3,	0
		.BYTE $41,  3,	0
		.BYTE $41,  7,	0
		.BYTE $41,  7,	0
		.BYTE $FF,$FF,$FF
arpeggio_0B:
		.BYTE $41,  0,	0
		.BYTE $41,  0,	0
		.BYTE $41,  3,	0
		.BYTE $41,  3,	0
		.BYTE $41,  8,	0
		.BYTE $41,  8,	0
		.BYTE $FF,$FF,$FF
arpeggio_0C:
		.BYTE $41, $C,	0
		.BYTE $FE,$FF,$FF
arpeggio_0D:
		.BYTE $41, $A,	0
		.BYTE $41, $A,	0
		.BYTE $41, $B,	0
		.BYTE $41, $B,	0
		.BYTE $41, $B,	0
		.BYTE $41, $C,	0
		.BYTE $FE,$FF,$FF
arpeggio_0E:
		.BYTE $81,$DF,$10
		.BYTE $40,$AC,$50
		.BYTE $40,$A8,$50
		.BYTE $40,$9C,$60
		.BYTE $40,$AC,	0
		.BYTE $40,$9C,	0
		.BYTE $FD,  1,	0
		.BYTE $FF,$FF,$FF
arpeggio_0F:
		.BYTE $FF,$FF,$FF

unk_160F:	.BYTE	0		; presets
					; 00
unk_1610:	.BYTE	0
unk_1611:	.BYTE	0
unk_1612:	.BYTE	0
unk_1613:	.BYTE	0
unk_1614:	.BYTE	0
unk_1615:	.BYTE	0
unk_1616:	.BYTE	0
		.BYTE	8,  8,$11,  8,	0,  0,	0,$51 ;	01
		.BYTE  $F,$C8,$11,  8,	0,  0,	0,  2 ;	02
		.BYTE  $A,$9C,$41,$41,$20,$92,$11,$50 ;	03
		.BYTE  $A,$AF,	9,$4A,$30,$42, $A,$B4 ;	04
		.BYTE	2,$2C,	9,$FF,$50,$52,$40,$B5 ;	05
		.BYTE	9,$79,$19,$AA,$40,$22,	8,$B6 ;	06
		.BYTE $DB,  0,	9,$50,$10,$52,$66,$57 ;	07
		.BYTE  $C,  0,$19,$AA,$40,$22,	8,$B8 ;	08
		.BYTE $DD,$5A,	9, $F,$40,$22, $A,$B9 ;	09
		.BYTE	2,$30,	9, $F,$A0,  0,	0,$BA ;	0A
		.BYTE	3,$40,	9, $F,$A0,  0,	0,$BB ;	0B
		.BYTE $CC,$20,	9,$AF,$FF,$32,$3A,$BC ;	0C
		.BYTE $13,$40,	9,$AA,$4F,$92, $A,$BD ;	0D
		.BYTE  $F,$C9,	9,  8,	0,  2,$AA,$BE ;	0E
		.BYTE	6,$20,$41,$48,$F0,  0,	0,$50 ;	0F
		.BYTE	0,  0,	0,  0,	0,  0,	0,  0 ;	10
		.BYTE	9,$90,$81,  0,	0,  0,	0,  5 ;	11
		.BYTE $CC,$20,$81,  0,	0,  0,	0,  0 ;	12
		.BYTE	5,$50,$17,  0,	0,  0,	0,  0 ;	13
		.BYTE	9,$49,$11,$44,$90,  0,	0,$5E ;	14
		.BYTE	9,$49,$11,$44,$90,  0,	0,$5F ;	15
		.BYTE	9,$60,$41,$12,$40,  0,	0,$59 ;	16
		.BYTE	9,$60,$41,  8,$81,$42,$40,$59 ;	17
		.BYTE  $A,$4A,$81,  0,	0,  0,	0,$88 ;	18
		.BYTE	9,$6B,$11,  1,	0,$99,$99,  4 ;	19
		.BYTE  $A,$8B,$13,  0,	0,  0,	0,$40 ;	1A
		.BYTE  $A,$70,$13,  0,	0,$FF,$FF,$10 ;	1B
		.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;	1C
					; lack of presets 1D-1F causes a bug
					; resulting track info being displayed
					; in above records
ch1_tracks:
		.BYTE	0,  0
		.BYTE $FF,$FF
ch2_tracks:
		.BYTE	0,  0
		.BYTE $FF,$FF
ch3_tracks:
		.BYTE	0,  0
		.BYTE $FF,$FF

		.BYTE $FF,$FF

byte_1705:
		.BYTE $17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17 ;	sequence address msb
		.BYTE $17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17
		.BYTE $17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17
		.BYTE $17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17
byte_1745:
		.BYTE	3,  3,	3,  3,	3,  3,	3,  3,	3,  3,	3,  3,	3,  3,	3,  3 ;	sequence address lsb
		.BYTE	3,  3,	3,  3,	3,  3,	3,  3,	3,  3,	3,  3,	3,  3,	3,  3
		.BYTE	3,  3,	3,  3,	3,  3,	3,  3,	3,  3,	3,  3,	3,  3,	3,  3
		.BYTE	3,  3,	3,  3,	3,  3,	3,  3,	3,  3,	3,  3,	3,  3,	3,  3

		.TEXT 'MUSIC MIXER 5 MODULE'

		.END
