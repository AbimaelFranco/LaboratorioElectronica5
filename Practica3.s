SYSCTL_RCGCGPIO_R 	EQU 0x400FE608 ;Reloj de tiva
	
GPIO_PORTB_AMSEL_R    EQU 	0x40005528 ;Modo analogico 
GPIO_PORTB_PCTL_R     EQU 	0x4000552C ;Desactivar funcion alternativa
GPIO_PORTB_DIR_R      EQU  	0x40005400 ;Especificacion de direccion
GPIO_PORTB_AFSEL_R    EQU	0x40005420 ;Funciones alternativas
GPIO_PORTB_DEN_R      EQU 	0x4000551C ;Modo digital
	
PB0 EQU 0x40005004	; PUSH 1
PB1 EQU 0x40005008	; PUSH 2
PB2 EQU 0x40005010	; PUSH 3
PB3 EQU 0x40005020	; LED 1
PB4 EQU 0x40005040	; LED 2
PB5 EQU 0x40005080	; LED 3
;tressegundos EQU 6000000
tressegundos EQU 1000000
	
		
		AREA 	codigo, CODE, READONLY, ALIGN=2
		THUMB
		EXPORT Start
Start
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; CONFIGURACION PUERTO B ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	LDR R1, =SYSCTL_RCGCGPIO_R 		;activa el reloj para el puerto B
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	ORR R0, R0, #2_00000010			; escribir bit 0 para activar el reloj del puerto B
	STR R0, [R1]
	NOP								;Espera tiempo para que el reloj se estabilice
	NOP
	
	LDR R1, =GPIO_PORTB_AMSEL_R 	; deshabilita modo analogico
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	;BIC R0, #0x0F					; deshabilita analogico para PB0 - PB3
	BIC R0, #2_00000000				; deshabilita analogico para PB0 - PB3
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTB_PCTL_R		; configura puertos como GPIO
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	;BIC R0, R0, #0x000000FF		; realiza un AND entre el primer numero y el complemento del 2do
	;BIC R0, R0, #0x0000FF00
	BIC R0, #2_11111111				; desactiva funciones alternativas
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
;	LDR R1, =GPIO_PORTB_DIR_R		; configura registro de direccion
;	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
;	BIC R0, R0, #0x07				; realiza un AND entre el primer numero y el complemento del 2do
;	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTB_DIR_R		; configura registro de direccion
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	;ORR R0, R0, #0x08
	ORR R0, R0, #2_11111000	
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTB_AFSEL_R		; configura como funcion regular
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	;BIC R0, R0, #0x0F
	BIC R0, R0, #2_00111111				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTB_DEN_R		; habilita el puerto B como puerto digital
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	;ORR R0, R0, #0x0F
	ORR R0, R0, #2_00111111				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R4, =tressegundos
	LDR R5, =0

	B Principal
	
Principal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;Secuencia 1
	BL Led1
	BL Led2
	BL Led3
	BL Ledapagados
	
	BL Lecturaa
	BL ledencendidos
	BL Ledapagados
	BL Lecturab
	BL ledencendidos
	BL Ledapagados
	BL Lecturac
	BL ledencendidos
	BL Ledapagados
;;;;;;;;;;;;;;;;;;;;;;;;;;;;Secuencia 2	
	BL Led3
	BL Led2
	BL Led1
	BL Ledapagados
	
	BL Lecturac
	BL ledencendidos
	BL Ledapagados
	BL Lecturab
	BL ledencendidos
	BL Ledapagados
	BL Lecturaa
	BL ledencendidos
	BL Ledapagados
;;;;;;;;;;;;;;;;;;;;;;;;;;;;Secuencia 3
	BL Led2
	BL Led1
	BL Led3
	BL Ledapagados
	
	BL Lecturab
	BL ledencendidos
	BL Ledapagados
	BL Lecturaa
	BL ledencendidos
	BL Ledapagados
	BL Lecturac
	BL ledencendidos
	BL Ledapagados
;;;;;;;;;;;;;;;;;;;;;;;;;;;;Secuencia 4
	BL Led3
	BL Led1
	BL Led2
	BL Ledapagados
	
	BL Lecturac
	BL ledencendidos
	BL Ledapagados
	BL Lecturaa
	BL ledencendidos
	BL Ledapagados
	BL Lecturab
	BL ledencendidos
	BL Ledapagados
;;;;;;;;;;;;;;;;;;;;;;;;;;;;Secuencia 5
	BL Led2
	BL Led3
	BL Led1
	BL Ledapagados
	
	BL Lecturab
	BL ledencendidos
	BL Ledapagados
	BL Lecturac
	BL ledencendidos
	BL Ledapagados
	BL Lecturaa
	BL ledencendidos
	BL Ledapagados
	
	BL ledencendidos
	BL Ledapagados
	
	BL ledencendidos
	BL Ledapagados
	
	BL ledencendidos
	BL Ledapagados
	
	B Principal
	
Delay
	ADD R2, #1						; suma #1 a R2
	NOP								;Espera tiempo para que el reloj se estabilice
	NOP
	NOP
	NOP
	CMP R2, R4						; compara R2 y R4
	BNE Delay
	BXEQ LR
	
Led1
	LDR R1, =PB3					; Enciende LED 1
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB4					; Apagar LED 2
	LDR R0, =0x10					
	STR R0, [R1]
	
	LDR R1, =PB5					; Apagar LED 3
	LDR R0, =0x20					
	STR R0, [R1]
	
	LDR R2, =0						; resetea R2
	B Delay
	
Led2
	LDR R1, =PB3					; Apagar LED 1
	LDR R0, =0x08					
	STR R0, [R1]
	
	LDR R1, =PB4					; Enciende LED 2
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB5					; Apagar LED 3
	LDR R0, =0x20					
	STR R0, [R1]
	
	LDR R2, =0						; resetea R2
	B Delay
	
Led3
	LDR R1, =PB3					; Apagar LED 1
	LDR R0, =0x08					
	STR R0, [R1]
	
	LDR R1, =PB4					; Apagar LED 2
	LDR R0, =0x10					
	STR R0, [R1]
	
	LDR R1, =PB5					; Enciende LED 3
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R2, =0						; resetea R2
	B Delay
	
Ledapagados
	LDR R1, =PB3					; Apagar LED 1
	LDR R0, =0x08					
	STR R0, [R1]
	
	LDR R1, =PB4					; Apagar LED 2
	LDR R0, =0x10					
	STR R0, [R1]
	
	LDR R1, =PB5					; Enciende LED 3
	LDR R0, =0x20					
	STR R0, [R1]
	
	LDR R2, =0						; resetea R2
	B Delay
	
ledencendidos
	LDR R1, =PB3					; Apagar LED 1
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB4					; Apagar LED 2
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB5					; Enciende LED 3
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R2, =0						; resetea R2
	B Delay

Lecturaa
	LDR R1, =PB0					; lee el pin B0
	LDR R0, [R1]					
	CMP R0, #0x01					; compara R0
	;BEQ Led3 						; Salto si es igual
	;BXEQ LR
	BEQ Regresar
	
	LDR R1, =PB1					; lee el pin B1
	LDR R0, [R1]					
	CMP R0, #0x02					; compara R0
	BEQ Principal					; salto si es igual
	
	LDR R1, =PB2					; lee el pin B2
	LDR R0, [R1]					; carga en R0
	CMP R0, #0x04					; compara R0
	BEQ Principal					; salto si es igual
	
	B Lecturaa
	
Lecturab
	LDR R1, =PB0					; lee el pin B0
	LDR R0, [R1]					
	CMP R0, #0x01					; compara R0
	;BEQ Led3 						; Salto si es igual
	BEQ Principal
	
	LDR R1, =PB1					; lee el pin B1
	LDR R0, [R1]					
	CMP R0, #0x02					; compara R0
	BEQ Regresar
	;BEQ Led3
	;BXEQ LR
	
	LDR R1, =PB2					; lee el pin B2
	LDR R0, [R1]					; carga en R0
	CMP R0, #0x04					; compara R0
	BEQ Principal					; salto si es igual
	
	B Lecturab

Lecturac
	LDR R1, =PB0					; lee el pin B0
	LDR R0, [R1]					
	CMP R0, #0x01					; compara R0
	;BEQ Led3 						; Salto si es igual
	;BXEQ LR
	BEQ Principal					; salto si es igual
	
	LDR R1, =PB1					; lee el pin B1
	LDR R0, [R1]					
	CMP R0, #0x02					; compara R0
	BEQ Principal					; salto si es igual
	
	LDR R1, =PB2					; lee el pin B2
	LDR R0, [R1]					; carga en R0
	CMP R0, #0x04					; compara R0
	;BEQ Principal					; salto si es igual
	;BXEQ LR							; Salto si es igual
	BEQ Regresar
	
	B Lecturac
	
Regresar
	BX LR

	ALIGN
	END