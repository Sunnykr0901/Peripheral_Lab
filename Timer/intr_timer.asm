cpu "8085.tbl"            
hof "int8"                

ORG 8FBFH                 ;      RST 7.5 Intrupt Location
JMP ISR 


org 9000h                 ;      Program Location

;Pneumonics
UPDDT: EQU 044CH          ;      Update display of data feild
UPDAD: EQU 0440H          ;      Update  display of address deild
CURAD: EQU 8FEFH          ;      Stores 16 bit data for Address display.
CURDT: EQU 8FF1H          ;      Stores 8 bit data for Data display.

SHLD CURAD                ;      Store the input from H-L pair register   
STA CURDT                 ;      Store the input from A  register
MVI A,0BH                 ;      Unmask the RST 7.5 Interupt
SIM                       ;      Set Interrupt Mask
EI                        ;      Enalble Intrrupt

RESUME:                   ;      Infinite Loop to wait for next interrupt
	MVI B,01H             ;      Toogle the value of B program goes to clock in next interrupt
	CALL UPDAD               
	CALL UPDDT           
INF:                      ;      Infinite Loop with random instruction
	INR C
	DCR C
	INR C
	DCR C
	INR C
	DCR C
	INR C
	DCR C
	JMP INF                     

SECS:					  ;      Preproccessing for next intrupt								
	LDA CURDT
	MVI B,00H             ;      Toogle the value of B program halts in next interrupt
	JMP SEC

MIN:                      ;      Minute Function
SHLD CURAD                
MVI A,59H                 ;      move 59H to register A to restart minutes

 
SEC:                 	  ;      Seconds Funtion
STA CURDT                 
CALL UPDAD                ;      Keep updating Address field all these time
CALL UPDDT               	  
CALL DELAY                ;      Call Delay for 1 Sec

LDA CURDT                  
ADI 99H                   ;      Decrement the value of data display by 1
DAA                       
CPI 99H                   ;      Check if seconds are complete i.e seconds is at -1
JNZ SEC                   ;      Seconds not completed so keep on running seconds 

;If the seconds hand has reached 00 it must be put to 59 and we shoud switch to minutes hand

LHLD CURAD                

MOV A,L                   
ADI 99H                   ;      Decrement minutes by 1 
DAA                       
MOV L,A                   

CPI 99H                   ;      Check if minutes are complete 
JNZ MIN                   ;      Minutes are not competed so keep on running minutes

;If the minutes hand has reached 00 it must be put to 59 and we shoud switch to hours hand

MVI L,59H                
MOV A,H                   
ADI 99H                   ;      Decremrnt Hour by 1
DAA                       
MOV H,A                   

CPI 99H                   	;      Compare whether the timer is completed
JNZ MIN                   
JMP ENDTIME                 ;      If completed stop the timer 



DELAY:                    ;      Delay function
MVI C,04H                 
OUTLOOP:                  ;      OUTLOOP function
LXI D,7D10H               

INLOOP:                   ;      INLOOP function
DCX D                    
MOV A,D                   
ORA E                    
JNZ INLOOP                
DCR C                    
JNZ OUTLOOP               ;      As long as the memory of C is not 00H jump to OUTLOOP
RET                       ;      Return 



ISR:
	MVI A,1BH                 ;      1BH is used for RST 7.5
	SIM                       ;      Set Interrupt
	EI
	MVI A,01H            ;  If B is 1 jump to clock i.e SECS else halt the clock i.e jump to RESUME
	CMP B
	JNZ RESUME
	JMP SECS

ENDTIME:                    ; Clock has reached 0 so halt the clock at 00:00:00
	MVI H,00H
	MVI L,00H
	MVI A,00H
	SHLD CURAD				  
	STA CURDT				  
	CALL UPDAD
	CALL UPDDT
	JMP ENDTIME



; Delay of 1 second is brought by function DELAY by calling the required number of times. the frequency is 3.072MHz.