cpu "8085.tbl"
hof "int8"

org 9000h



CPI 00h
JZ add
CPI 01h
JZ sub
CPI 02h
JZ mul
CPI 03h
JZ div
CPI 04h
JZ square

add:
	LHLD 8000h
	XCHG
	LHLD 8002h
	DAD D
	SHLD 8004h
	JC carry
	JNC ncarry
	JMP end

sub:
	LHLD 8000h
	XCHG
	LHLD 8002H
	MOV A,E
	SUB L
	STA 8004H
	MOV A,D
	SBB H
	STA 8005H
	JC carry
	JNC ncarry
	JMP end
carry:
	mvi A,1h
	STA 8006H
	JMP end
ncarry:
	mvi A,0h
	STA 8006H
	JMP end
mul:
	LHLD 8000H
	SPHL
	LHLD 8002H
	XCHG
	MOV A,E
	ORA D
	LXI B,0000H
	LXI H,0000H
	JZ mulbyzero
	JMP mulhelp
mulbyzero:
	SHLD 8004H
	MOV L,C
	MOV H,B
	SHLD 8006H
	JMP end
mulhelp:
	DAD SP
	JNC count
	INX B
	JMP count
count:
	DCX D
	MOV A,E
	ORA D
	JNZ mulhelp
	SHLD 8004H
	MOV L,C
	MOV H,B
	SHLD 8006H
	JMP end
div:
	LXI B, 0000H
	LHLD 8002H
	XCHG
	LHLD 8000H
	JMP divquo
divquo:
	MOV A,L
	SUB E
	MOV L,A
	MOV A,H
	SBB D
	MOV H,A
	JC divrem
	INX B
	JMP divquo
divrem:
	DAD D
	SHLD 8006H
	MOV L,C
	MOV H,B
	SHLD 8004H
	JMP end
square:
	LHLD 8000H
	SHLD 8002H
	JMP mul

end:



RST 5




