	AREA	 arm1, CODE
	INCLUDE 	LPC2368_asm.inc
	ENTRY 
	EXPORT start	
	
	
start
	
	LDR R0, =FIO2_DIR	;pointer uebergeben an R0, also zeigt R0 auf FIO_DIR und dessen Inhalt
	LDR R2, [R0]		;Tut sich hier schon nichts?? Inhalt von FIO2_DIR in Rs speichern zum lesen
	MOV R3, #17			;P2.0 und P2.02 sollen ein Ausgang '1' und P2.10 ein Eingang '0' --> ...00000101 = 5
	
	ORR R3, R2, R3		;setzen der bits 0,2,10 zur einstellung und erhaltung der anderen Daten
	STR R3, [R0]		;Wird nicht verarbeitet?? zurückschreiben der Einstellung in das FIO2_DIR über Adresse 
	
	LDR R1, =FIO2_PIN
	
loop
	
	LDR R4, [R1]		;lädt einen falschen Wert rein

	AND R5, R4, #0x00000400
	CMP R5, #1024
	
;	ANDEQ R1, R4, #0xFFFFFEE
	
;	ORRNE R1, R4, #0x00000101
	
	;TST R4, #10			;Er überspringt diesen Teil NE --> not equal = '0' EQ--> equal
	
	BNE gedrueckt
	BEQ nicht_gedrueckt
	;AND R3, R4, #0xFFFFFFFA
	;STR R3, [R1]
	
	
	BL loop
	
gedrueckt	
	ORR R3, R4, #17
	STR R3, [R1]
	BL loop
nicht_gedrueckt
	AND R3,R4,#0xFFFFFFEE
	STR R3,[R1]
	BL loop
	END
