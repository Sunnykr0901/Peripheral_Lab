cpu "8085.tbl"
hof "int8"


org 9000h

MVI A,8BH					;setting 8255 to mode0 and port A o/p and port B,C i/p
OUT 03H
START:
	IN 01H					; [A] <- IN from 8255
	CMA
	ANI 80H					; logical and 80H with content of A
	CPI 80H					; 80H is ending condition
	JZ TRI					; jump to TRI
	IN 01H					; [A] <- IN from 8255
	CMA
	ANI 40H					; logical and 40H with content of A
	CPI 40H					; 40H is ending conditioN
	JZ ST						; jump to SAWTOOTH
	IN 01H					; [A] <- IN from 8255
	CMA
	ANI 20H					; logical and 20H with content of A
	CPI 20H					; 20H is ending conditioN
	JZ SQ						; jump to SQUARE
	IN 01H					; [A] <- IN from 8255
	CMA
	ANI 10H					; logical and 10H with content of A
	CPI 10H					; 10H is ending conditioN
	JZ SC						; jump to STAIRCASE
	IN 01H					; [A] <- IN from 8255
	CMA
	ANI 08H					; logical and 08H with content of A
	CPI 08H					; 08H is ending conditioN
	JZ SSC					; jump to SYMMETRICAL STAIRCASE
	JMP START

TRI:							; TRIANGULAR WAVE
	LDA 8000H				; input frequency stored in DE pair register
	MOV D,A
	LDA 8001H
	MOV E,A

	MVI B,8EH
	MVI C,71H

	CALL L4

	MVI A,80H
	OUT 43H
LOOP3:
	MVI A,00H
 	OUT 40H
 	OUT 41H
LOOP1:						; for positive slop triangular wave
	INR A
 	OUT 40H
	OUT 41H
	CMP L
	JNZ LOOP1
LOOP2:						; for negative slop triangular wave
   DCR A
   OUT 40H
   OUT 41H
   CPI 00H
   JNZ LOOP2
   JMP LOOP3


ST:								; SAWTOOTH WAVE
	LDA 8000H
	MOV D,A
	LDA 8001H
	MOV E,A

	MVI B,8EH
	MVI C,71H

	CALL L4
	MVI A,80H
	OUT 43H
LOOP4:
	MVI A,00H
 	OUT 40H
 	OUT 41H
LOOP5:
		MVI B,00H
		MVI B,00H
    MVI B,00H
  	MVI B,00H
   	MVI B,00H
	  MVI B,00H
	  INR A
  	OUT 40H
	  OUT 41H
	  CMP L
	  JNZ LOOP5
	 	JMP LOOP4


SQ:								; SQUARE WAVE
		LDA 8000H
		MOV D,A
		LDA 8001H
		MOV E,A

		MVI B,75H
		MVI C,30H

		CALL L4



		MVI A,80H
		OUT 43H
		LOOP6:
		MVI B,00H
		CALL DELAY
		MVI B,0FFH
		CALL DELAY
		JMP LOOP6


SC:								; STAIRCASE WAVE
		LDA 8000H
		MOV D,A
		LDA 8001H
		MOV E,A

		MVI B,3EH
		MVI C,80H

		CALL L4

		MVI A,80H
		OUT 43H
LOOP7:
    MVI A,00H
    MOV B,A
LOOP8:
    CALL DELAY
    MOV A,B
    ADI 40H
    MOV B,A
    CPI 00H
    JNZ LOOP8
    JMP LOOP7

SSC:							; SYMMETRICAL STAIRCASE WAVE
		LDA 8000H
		MOV D,A
		LDA 8001H
		MOV E,A

		MVI B,1DH
		MVI C,C4H

		CALL L4


		MVI A,80H
		OUT 43H
LOOP9:
    MVI A,00H
    MOV B,A
LOOP10:
    CALL DELAY
    MOV A,B
    ADI 40H
    MOV B,A
    CPI 00H
    JNZ LOOP10
    MVI B,0FFH
LOOP11:
    CALL DELAY
    MOV A,B
    SBI 40H
    MOV B,A
    CPI 0FFH
    JNZ LOOP11
    JMP LOOP9


DELAY:							; delay function
    MVI C,01H
OUTLOOP:
    MOV D,H
    MOV E,L
INLOOP:
    MOV A,B
    OUT 40H
    OUT 41H
    DCX D
    MOV A,D
    ORA E
    JNZ INLOOP
    DCR C
    JNZ OUTLOOP
    RET

L4:									; for calculating divisions
  	MOV H, 00H
  	MVI L, 00H
  	MOV A, D
  	ORA E
  	JZ L11
L8:
  	MOV A,C
  	SUB E
  	MOV C, A
  	MOV A,B
  	SBB D
  	MOV B, A
  	JC L11
  	INX H
  	JMP L8
L11:
  	RET
