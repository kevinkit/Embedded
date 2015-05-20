		AREA Test, CODE
		INCLUDE LPC2368_asm.inc
		ENTRY
		EXPORT start	

start

	MOV R4, #0x00000FF ;alles als Output bis Bit 10 auf Input
	MOV R8, #0x00000400 ; 

	LDR R2,=FIO2_DIR ;jetzt funktioniert R2 als ein pointer 
	LDR R3,=FIO2_PIN ;Pointer auf Input Pins
	
	;EInstellungen
	LDR R5,[R2]
	ORR R5,R5,R4 ; R5 = R5 | R4 -> R5 ist der Inhalt aus FIO2_DIR 
	STR R5,[R2]
	

	MOV R6, #0x00000005
	MOV R5, #0xFFFFFFFA ;R5 ist R4 invertiert


loop_start
		 
	LDR R1,[R3] ;Eingangsports holen
	AND R7,R1,R8 ;R7 = R1 & R4

	CMP R7,#1024                 
	
	
	BNE LED_AN
    BEQ LED_AUS
	BL loop_start



LED_AN
	ORR R1,R1,R6
	STR R1,[R3]
	BL loop_start
LED_AUS
	AND R1,R1,R5
	STR R1,[R3]
	BL loop_start
	
	END
