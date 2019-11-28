Steps to execute the code on 8085:-
1) We have to set register value to 00, 01, 02, 03 and 04 for addition, substraction, multiplication, division and sqaure respectively.
2) Then we have to set the values of operands in 8000, 8001, 8002, 8003 memory location such that MSB in 8001 and LSB in 8000, similarily for 2nd operand MSB in 8003 and LSB in 8002.(in case of division store divisor in 8002 and 8003, in case of substacrtion (a-b) store b in 8002 and 8003, in case of square only store in 8001 and 8000).



cpu "8085.tbl"
hof "int8"

org 9000h



CPI 00h
JZ add
CPI 01h
JZ sub
CPI 02h                 // checking value of A register to know about the operation to be done and the jump on that operation.
JZ mul
CPI 03h
JZ div
CPI 04h
JZ square

add:
	LHLD 8000h          //load value at location 8000 in L and 8001 at H
	XCHG                // value of H in D and value of L in E
	LHLD 8002h          //loading values in H and L
	DAD D              //H=H+D and L=L+E
	SHLD 8004h         // store value of H in 8005 and L in 8004
	JC carry           // if carry then jump
	JNC ncarry         
	JMP end

sub:
	LHLD 8000h
	XCHG
	LHLD 8002H
	MOV A,E           // A <- E
	SUB L             // A = A-L
	STA 8004H         // 8004 <- A
	MOV A,D           // A <- D
	SBB H             // A=A-H-borrow
	STA 8005H         // 8005 <- A
	JC carry         // if borrow then jump
	JNC ncarry
	JMP end
carry:
	mvi A,1h             // A=1
	STA 8006H			// 8006<-A
	JMP end
ncarry:
	mvi A,0h            // A=0
	STA 8006H           // 8006<-A
	JMP end
mul:
	LHLD 8000H          //load value at location 8000 in L and 8001 at H
	SPHL                // Push value of H and L to stack pointer
	LHLD 8002H         //load value at location 8002 in L and 8003 at H
	XCHG               // value of H in D and value of L in E
	MOV A,E            // A <- E
	ORA D              // A || D to find whether multiplicand is zero or not
	LXI B,0000H       // BC <- 0000
	LXI H,0000H        // HL <- 0000
	JZ mulbyzero       // if multiplicand 0 jump 
	JMP mulhelp
mulbyzero:
	SHLD 8004H         // store value of H in 8005 and L in 8004
	MOV L,C            // L <-C
	MOV H,B            // H <-B
	SHLD 8006H         
	JMP end
mulhelp:
	DAD SP            ////H=H+ higher bit SP and L= L + lowerbit SP
	JNC count         // if not carry jump 
	INX B            // if carry increase the count of BC
	JMP count         // jump count
count:
	DCX D          // decreament in DE
	MOV A,E       // A <- E 
	ORA D          // A || D to find whether multiplicand became zero or not
	JNZ mulhelp   // if not zero then repeat
	SHLD 8004H     // store value of H in 8005 and L in 8004
	MOV L,C       // L <-C
	MOV H,B          // H <-B
	SHLD 8006H     
	JMP end
div:
	LXI B, 0000H   // BC <- 0000
	LHLD 8002H     //load value at location 8002 in L and 8003 at H
	XCHG           // value of H in D and value of L in E
	LHLD 8000H     ////load value at location 8000 in L and 8001 at H
	JMP divquo
divquo:
	MOV A,L      // substraction
	SUB E        
	MOV L,A
	MOV A,H
	SBB D
	MOV H,A
	JC divrem     // if borrow means it has become -ve means division over
	INX B        // incrementing quotient
	JMP divquo    // repeated substraction
divrem:
	DAD D       // and divisor to find remainder
	SHLD 8006H    // store value of H in 8007 and L in 8006
	MOV L,C       // L<- C
	MOV H,B       // H<- B
	SHLD 8004H     // store value of H in 8005 and L in 8004
	JMP end
square:
	LHLD 8000H         // load value in H and L
	SHLD 8002H         // then store in 8002 and 8003 memory loation 
	JMP mul            // jump to mul
end:



RST 5            //Halt




