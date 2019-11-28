cpu "8085.tbl"
hof "int8"

org 9000h										; Program Location

LDA 8000h										; load the value of 8000h to A( The position at which the bit is 1 is the floor no. of Boss )
MOV H,A
MVI A,8BH										; setting 8255 to mode0 and port A o/p and port B,C i/p
OUT 43H

FLR0:
	MVI B,01H
	MVI A,00H
	STA 8002H
	OUT 40H										; output to Port A
	CALL DELAY								; calling DELAY function
	IN 41H										; [A] <- IN from 8255
	ANA H											; logical and of content of H register with content of A
	CMP H											; checking the floor is boss floor or not
	JZ BOSS_ROUTINE
	IN 41H
	CPI 00H
	JZ FLR0
	JZ FLR1

FLR1:
	MVI A,01H
	STA 8002H
	OUT 40H
	CALL DELAY
	IN 41H
	ANI 01H
	CPI 01H
	JZ FLR1
	IN 41H
	ANA H
	CMP H
	JZ BOSS_ROUTINE
	MOV A,B
	CPI 00H
	JZ FLR0
	IN 41H
	CPI 01H
	MVI B,00H
	JC FLR0
	JZ FLR1
	MVI B,01H
	JMP FLR2

FLR2:
	MVI A,02H
	STA 8002H
	OUT 40H
	CALL DELAY
	IN 41H
	ANI 02H
	CPI 02H
	JZ FLR2
	IN 41H
	ANA H
	CMP H
	JZ BOSS_ROUTINE
	MOV A,B
	CPI 00H
	JZ FLR1
	IN 41H
	CPI 02H
	MVI B,00H
	JC FLR1
	JZ FLR2
	MVI B,01H
	JMP FLR3

FLR3:
	MVI A,04H
	STA 8002H
	OUT 40H
	CALL DELAY
	IN 41H
	ANI 04H
	CPI 04H
	JZ FLR3
	IN 41H
	ANA H
	CMP H
	JZ BOSS_ROUTINE
	MOV A,B
	CPI 00H
	JZ FLR2
	IN 41H
	CPI 04H
	MVI B,00H
	JC FLR2
	JZ FLR3
	MVI B,01H
	JMP FLR4

FLR4:
	MVI A,08H
	STA 8002H
	OUT 40H
	CALL DELAY
	IN 41H
	ANI 08H
	CPI 08H
	JZ FLR4
	IN 41H
	ANA H
	CMP H
	JZ BOSS_ROUTINE
	MOV A,B
	CPI 00H
	JZ FLR3
	IN 41H
	CPI 08H
	MVI B,00H
	JC FLR3
	JZ FLR4
	MVI B,01H
	JMP FLR5

FLR5:
	MVI A,10H
	STA 8002H
	OUT 40H
	CALL DELAY
	IN 41H
	ANI 10H
	CPI 10H
	JZ FLR5
	IN 41H
	ANA H
	CMP H
	JZ BOSS_ROUTINE
	MOV A,B
	CPI 00H
	JZ FLR4
	IN 41H
	CPI 10H
	MVI B,00H
	JC FLR4
	JZ FLR5
	MVI B,01H
	JMP FLR6

FLR6:
	MVI A,20H
	STA 8002H
	OUT 40H
	CALL DELAY
	IN 41H
	ANI 20H
	CPI 20H
	JZ FLR6
	IN 41H
	ANA H
	CMP H
	JZ BOSS_ROUTINE
	MOV A,B
	CPI 00H
	JZ FLR5
	IN 41H
	CPI 20H
	MVI B,00H
	JC FLR5
	JZ FLR6
	MVI B,01H
	JMP FLR7

FLR7:
	MVI A,40H
	STA 8002H
	OUT 40H
	CALL DELAY
	IN 41H
	ANI 40H
	CPI 40H
	JZ FLR7
	IN 41H
	ANA H
	CMP H
	JZ BOSS_ROUTINE
	MOV A,B
	CPI 00H
	JZ FLR6
	IN 41H
	ANI 0C0H
	CPI 40H
	MVI B,00H
	JC FLR6
	JZ FLR7
	MVI B,01H
	JMP FLR8

FLR8:
	MVI B, 00H
	MVI A,80H
	STA 8002HJC FLR0
	OUT 40H
	CALL DELAY
	IN 41H
	ANI 80H
	CPI 80H
	JZ FLR8
	IN 41H
	ANA H
	CMP H
	JZ BOSS_ROUTINE
	IN 41H
	ANI 080H
	CPI 80H
	JC FLR7
	JZ FLR8

DELAY:                    	; Delay function
	MVI C,04H                 ; Move the value 04H to register C

OUTLOOP:                  	; OUTLOOP function
	LXI D,7D10H               ; Loads the value 7D10H into DE register

INLOOP:                   	; INLOOP function
	DCX D                     ; decrement the content of memory location DE by 1
	MOV A,D                   ; Move value in register D to Accumulator
	ORA E                     ; OR with value in Register E
	JNZ INLOOP                ; If the flag isn't 1 then go to INLOOP
	DCR C                     ; Contents of memory of C is decremented by 1
	JNZ OUTLOOP               ; As long as the memory of C is not 00H jump to OUTLOOP
	RET

BOSS_ROUTINE:								; BOSS_ROUTINE subroutine
	LDA 8002H
	CMP H											; Compares BOSS_ROUTINE FLR with current FLR(8002H memory location)
	JC GO_UP									; If BOSS_ROUTINE FLR is higher than present floor, goes to GO_UP subroutine
	JZ AT_BOSS_FLOOR					; If BOSS_ROUTINE FLR is at same FLR jumps to AT_BOSS_FLOOR subroutine
	JMP GO_DOWN								; If BOSS_ROUTINE FLR is lower than present floor, jumps to GO_DOWN subroutine

GO_UP:											; changes elevator position to BOSS_ROUTINE position(incrementing) A, then jumps to AT_BOSS_FLOOR
	LDA 8002H
	CPI 00H
	JZ CORNER_CASE						; ensures A has a 1 bit somewhere in its 8 bits (GO_UP can be called from FLR0 as well)
	RLC												; logical left circular shift of accumulator(A)
	STA 8002H

RETURN:
	OUT 40H
	CALL DELAY
	LDA 8002H
	CMP H
	JC GO_UP
	JZ AT_BOSS_FLOOR

GO_DOWN:										; changes elevator position to BOSS_ROUTINE position(decrementing) A, then jumps to AT_BOSS_FLOOR
	LDA 8002H
	RRC
	STA 8002H
	OUT 40H
	CALL DELAY
	LDA 8002H
	CMP H
	JZ AT_BOSS_FLOOR
	JMP GO_DOWN

AT_BOSS_FLOOR:							; Waits for BOSS_ROUTINE FLR request to go low, then goes to GO_GROUND subroutine
	IN 41H
	ANA H
	CMP H
	JZ AT_BOSS_FLOOR
	CALL DELAY

GO_GROUND:									; Takes elevator with BOSS_ROUTINE in it to ground FLR (FLR0)
	LDA 8002H
	RRC												; logical right shift of A (circular)
	STA 8002H
	OUT 40H
	CALL DELAY
	LDA 8002H
	CPI 01H
	JZ FLR0										; Jumps to FLR0 subroutine after BOSS_ROUTINE reaches FLR0
	JMP GO_GROUND

CORNER_CASE:								; INCREMENTS location 8002H (for GO_UP call from FLR0)
	ADI 01H
	STA 8002H
	JMP RETURN

	; Delay of 1 second is brought by function DELAY by calling the required number of times. the frequency is 3.072MHz.
