	AREA	 arm1, CODE
	INCLUDE 	LPC2368_asm.inc
	ENTRY 
	EXPORT start	
	
	
start
	
	LDR R0, =FIO2_DIR	;pointer uebergeben an R0, also zeigt R0 auf FIO_DIR und dessen Inhalt
	LDR R2, [R0]		;Inhalt von FIO2_DIR in Rs speichern zum lesen
	MOV R3, #0x000000F0		;P2.4 und P2.7 sollen ein Ausgang '1' und P2.10 ein Eingang '0' --> 00000090 = 144
	MOV R8, #0xFFFFFF0F
	
	ORR R3, R2, R3		;setzen der bits 4,7,10 zur einstellung und erhaltung der anderen Daten
	STR R3, [R0]		;zurückschreiben der Einstellung in das FIO2_DIR über Adresse 
	
	LDR R1, =FIO2_PIN
	STR R8, [R1]
	
loop
	
	LDR R4, [R1]		

	AND R5, R4, #0x00000400
	CMP R5, #1024
	
	BNE gedrueckt			; wenn '0'
	
	BL loop
	
gedrueckt
	LDR R4, [R1]		
	AND R5, R4, #0x00000400
	CMP R5, #1024

	BNE gedrueckt
	
	LDR R4, [R1]
	AND R7, R4, #0x000000F0
	CMP R7, #0x000000F0

	BNE toggle_eins
	BEQ toggle_null

	
toggle_null
	AND R3, R4, #0xFFFFFF0F
	STR R3, [R1]
	BL loop
	
toggle_eins
	ORR R3, R4, #0x000000F0
	STR R3, [R1]
	BL loop
	

	END
