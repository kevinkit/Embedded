		AREA Test, CODE
		INCLUDE LPC2368_asm.inc
		ENTRY
		EXPORT start	

start
	
	LDR R2,=FIO2_DIR ;jetzt funktioniert R2 als ein pointer 
	LDR R3,=FIO2_PIN ;Pointer auf Input Pins
	
	
	MOV R4, #0x000000FF ;alles als Output bis Bit 10 auf Input
	MOV R1, #0x00000001 ;start licht 

	
	
	LDR R5,[R2]
	ORR R5,R5,R4 ; R5 = R5 | R4 -> R5 ist der Inhalt aus FIO2_DIR 
	STR R5,[R2]
	
	MOV R2, #0x100 ; START von links
	
	LDR R9,=187500 ;geschätzt
	MOV R8,R9
	
	
	
start_from_begin
	MOV R5,R1

loop_left
	MOV R8,R9 ;Timer angelegenheiten
	STR R5,[R3]
	LSL R5,#1
	

	
loop_one
	LDR R6,[R3]
	AND R6,R6,#0x00000400
	CMP R6,#1024

	BNE wait_me_to_right
	SUBS R8,R8,#1 ;Timer angelegenheit
	BNE loop_one
	
	CMP R5,#0x0000200
	
	BEQ start_from_begin
	
	B loop_left
	
	
	
start_from_end
	MOV R5,R2  ;LEDs zuruecksetzen

loop_right
	MOV R8,R9   ;Timer zuruecksetzen
	LSR R5,R5,#1
	
	

	
loop_two
	LDR R6,[R3]
	AND R6,R6,#0x00000400
	CMP R6,#1024
	
	BNE wait_me_to_left
	
	SUBS R8,R8,#1
	BNE loop_two
	
	CMP R5,#0x00000000
		
	
	BEQ start_from_end
	
	
	
	STR R5,[R3]
	
	B loop_right



wait_me_to_left
	LDR R6,[R3]
	AND R6,R6,#0x00000400
	CMP R6,#1024
	BEQ loop_left
	BL wait_me_to_left
	
wait_me_to_right
	LDR R6,[R3]
	AND R6,R6,#0x00000400
	CMP R6,#1024
	BEQ loop_right
	BL wait_me_to_right
	
	
	
	END


	
