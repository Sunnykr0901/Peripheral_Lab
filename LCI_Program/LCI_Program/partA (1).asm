cpu "8085.tbl"
hof "int8"


org 9000h						; Program Location

MVI A,8BH						; setting 8255 to mode0 and port A o/p and port B,C i/p
MVI B,01H
OUT 43H
START:
	IN 41H						; [A] <- IN from 8255
	CMA								; complement the read value
	ANI 04H						; logical and of 04H with content of A
	CPI 04H						; 04H is ending condition of the program
	JZ END
	IN 41H
	CMA
	ANI 40H						; logical and of 40H with content of A
	CPI 40H						; compare immediate with 40H (continuing condition/initialization condition)
	JZ CONT
	JMP START
CONT:
	MOV A,B
	OUT 40H						; output to Port A
	CALL DELAY				; calling DELAY function
	MOV A,B
	RLC								; rotate(in cyclic fashion) content of A to left by one
	MOV B,A
	IN 41H
	CMA
	ANI 20H						; logical and of 20H with content of A
	CPI 20H						; 20H is pause condition
	JZ START
	IN 41H
	CMA
	ANI 04H
	CPI 04H
	JZ END
	JMP CONT

END:
	RST 5							;end of program


DELAY:              ;Delay function
	MVI C,04H         ;Move the value 04H to register C

OUTLOOP:            ;OUTLOOP function
	LXI D,7D10H       ;Loads the value 7D10H into DE register

	INLOOP:           ;INLOOP function
	DCX D             ;decrement the content of memory location DE by 1
	MOV A,D           ;Move value in register D to Accumulator
	ORA E             ;OR with value in Register E
	JNZ INLOOP        ;If the flag isn't 1 then go to INLOOP
	DCR C             ;Contents of memory of C is decremented by 1
	JNZ OUTLOOP       ;As long as the memory of C is not 00H jump to OUTLOOP
	RET								;RETURN

; Delay of 1 second is brought by function DELAY by calling the required number of times. the frequency is 3.072MHz.
