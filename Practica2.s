SYSCTL_RCGCGPIO_R 	EQU 0x400FE608 ;Reloj
	
GPIO_PORTB_AMSEL_R    EQU 	0x40005528 ;Modo analogico 
GPIO_PORTB_PCTL_R     EQU 	0x4000552C ;Desactivar funcion alternativa
GPIO_PORTB_DIR_R      EQU  	0x40005400 ;Especificacion de direccion
GPIO_PORTB_AFSEL_R    EQU	0x40005420 ;Funciones alternativas
GPIO_PORTB_DEN_R      EQU 	0x4000551C ;Modo digital
	
PB0 EQU 0x40005004
PB1 EQU 0x40005008
PB2 EQU 0x40005010
PB3 EQU 0x40005020
tressegundos EQU 6000000
	
		
		AREA 	codigo, CODE, READONLY, ALIGN=2
		THUMB
		EXPORT Start
Start
	
	LDR R1, =SYSCTL_RCGCGPIO_R 		;activa el reloj para el puerto B
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	ORR R0, R0, #2_00000010				; escribir bit 0 para activar el reloj del puerto B
	STR R0, [R1]
	NOP								;Espera tiempo para que el reloj se estabilice
	NOP
	
	LDR R1, =GPIO_PORTB_AMSEL_R 	; deshabilita modo analogico
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	BIC R0, #0x0F					; deshabilita analogico para PB0 - PB3
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTB_PCTL_R		; configura puertos como GPIO
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	BIC R0, R0, #0x000000FF			; realiza un AND entre el primer numero y el complemento del 2do
	BIC R0, R0, #0x0000FF00
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTB_DIR_R		; configura registro de direccion
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	BIC R0, R0, #0x07				; realiza un AND entre el primer numero y el complemento del 2do
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTB_DIR_R		; configura registro de direccion
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	ORR R0, R0, #0x08
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTB_AFSEL_R		; configura como funcion regular
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	BIC R0, R0, #0x0F
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTB_DEN_R		; habilita el puerto B como puerto digital
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	ORR R0, R0, #0x0F
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R4, =tressegundos
	
	B Lectura
	
Delay
	ADD R2, #1						; suma #1 a R2
	NOP								;Espera tiempo para que el reloj se estabilice
	NOP
	NOP
	NOP
	CMP R2, R4						; compara R2 y R4
	BNE Delay
	BEQ Apagado
	
	
Encendido 
	LDR R1, =PB3					; activa el led en el puerto B3
	LDR R0, =0x08					; manda una señal a B3
	STR R0, [R1]					
	LDR R2, =0						; resetea R2
	BL Delay
	
	
Apagado
	LDR R1, =PB3					; Apaga el led en el puerto B3
	LDR R0, =0x00					; carga un valor de 0 al pin B3
	STR R0, [R1]					
	BL Lectura
	
Suma								; Ubica el caso en el que estamos mayores a 1 segundo
	ADD R4, #1
	LDR R5, =8000000
	CMP R4, R5
	BEQ Lectura
	LDR R5, =10000000
	CMP R4, R5
	BMI Lectura
	LDR R5, =6000000
	CMP R4,R5
	BEQ Lectura
	LDR R5, =4000000
	CMP R4, R5
	BEQ Lectura
	BNE Suma


Resta								; Ubica el caso en el que estamos menores a 5 segundos
	SUB R4, #1
	LDR R5, =2000000
	CMP R4, R5
	BLS Lectura
	LDR R5, =4000000
	CMP R4, R5
	BEQ Lectura
	LDR R5, =6000000
	CMP R4, R5
	BEQ Lectura
	LDR R5, =8000000
	CMP R4, R5
	BEQ Lectura
	BNE Resta
	
	
Lectura
	LDR R1, =PB0					; lee el pin B0
	LDR R0, [R1]					
	CMP R0, #0x01					; compara R0
	BEQ Suma 						; Salto si es igual
	
	LDR R1, =PB1					; lee el pin B1
	LDR R0, [R1]					
	CMP R0, #0x02					; compara R0
	BEQ Resta						; salto si es igual
	
	LDR R1, =PB2					; lee el pin B2
	LDR R0, [R1]					; carga en R0
	CMP R0, #0x04					; compara R0
	BEQ Encendido
	
	
	BL Lectura
	
	ALIGN
	END	
