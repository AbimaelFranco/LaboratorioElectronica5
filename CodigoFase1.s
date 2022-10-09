SYSCTL_RCGCGPIO_R 	EQU 0x400FE608 ;Reloj de tiva

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; CONFIGURACION PUERTO B ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GPIO_PORTB_AMSEL_R    EQU 	0x40005528 ;Modo analogico 
GPIO_PORTB_PCTL_R     EQU 	0x4000552C ;Desactivar funcion alternativa
GPIO_PORTB_DIR_R      EQU  	0x40005400 ;Especificacion de direccion
GPIO_PORTB_AFSEL_R    EQU	0x40005420 ;Funciones alternativas
GPIO_PORTB_DEN_R      EQU 	0x4000551C ;Modo digital
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; CONFIGURACION PUERTO D ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GPIO_PORTD_AMSEL_R    EQU 	0x40007528 ;Modo analogico 
GPIO_PORTD_PCTL_R     EQU 	0x4000752C ;Desactivar funcion alternativa
GPIO_PORTD_DIR_R      EQU  	0x40007400 ;Especificacion de direccion
GPIO_PORTD_AFSEL_R    EQU	0x40007420 ;Funciones alternativas
GPIO_PORTD_DEN_R      EQU 	0x4000751C ;Modo digital
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; CONFIGURACION PUERTO E ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GPIO_PORTE_AMSEL_R    EQU 	0x40024528 ;Modo analogico 
GPIO_PORTE_PCTL_R     EQU 	0x4002452C ;Desactivar funcion alternativa
GPIO_PORTE_DIR_R      EQU  	0x40024400 ;Especificacion de direccion
GPIO_PORTE_AFSEL_R    EQU	0x40024420 ;Funciones alternativas
GPIO_PORTE_DEN_R      EQU 	0x4002451C ;Modo digital


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; Direccionamiento de pines ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PB0 EQU 0x40005004	; Azul LED 1 de Cola
PB1 EQU 0x40005008	; Rojo LED 1 de Cola
PB2 EQU 0x40005010	; Azul LED 2 de Cola
PB3 EQU 0x40005020	; Rojo LED 2 de Cola
PB4 EQU 0x40005040	; Azul LED 3 de Cola
PB5 EQU 0x40005080	; Rojo LED 3 de Cola
PB6 EQU 0x40005100
PB7 EQU 0x40005200
	
PD0 EQU 0x40007004	; LED azul 1
PD1 EQU 0x40007008	; LED azul 2
PD2 EQU 0x40007010	; LED azul 3
PD3 EQU 0x40007020	; LED azul 4
PD4 EQU 0x40007040
PD5 EQU 0x40007080
PD6 EQU 0x40007100	; LED azul 5
PD7 EQU 0x40007200
	
PE0 EQU 0x40024004	; LED rojo 1
PE1 EQU 0x40024008	; LED rojo 2
PE2 EQU 0x40024010	; LED rojo 3
PE3 EQU 0x40024020	; LED rojo 4
PE4 EQU 0x40024040
PE5 EQU 0x40024080	; LED rojo 5
PE6 EQU 0x40024100	
PE7 EQU 0x40024200


;tressegundos EQU 6000000
tressegundos EQU 3000000	;;;;;;Tiempo adecuado
;tressegundos EQU 1000000
	
		
		AREA 	codigo, CODE, READONLY, ALIGN=2
		THUMB
		EXPORT Start
Start
	
	B Encendido

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Encendido
	LDR R4, =tressegundos
	LDR R2, =0						; resetea R2
	
;	CMP R6, #0
;	BEQ Ciclo0
;	
;	CMP R6, #1
;	BEQ Ciclo1
;	
;	CMP R6, #2
;	BEQ Ciclo2
;	
;	CMP R6, #3
;	BEQ Ciclo3
	
;	CMP R6, #4
;	BEQ Ciclo4
;	
;	CMP R6, #5
;	BEQ Ciclo5
	;BL Funcionlimpieza
	BL ConfiguracionPuertos
	BL Ciclo0
	BL Ciclo1
	BL Ciclo2
	BL Ciclo3
	BL Ciclo4
	BL Ciclo5
	BL Ciclo6
	BL Ciclo7
	BL Ciclo8
	BL Ciclo9
	BL Ciclo10
	
	BL Ciclo11
	LDR R1, =PE0					; Apagar LED 1 de Almacen ROJO
	LDR R0, =0x01					
	STR R0, [R1]
	LDR R1, =PE1					; Apagar LED 2 de Almacen ROJO
	LDR R0, =0x00		
	STR R0, [R1]
	
	LDR R2, =0						; resetea R2
	
	BNE Encendido


ConfiguracionPuertos
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
	ORR R0, R0, #2_11111111	
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
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; CONFIGURACION PUERTO D ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	LDR R1, =SYSCTL_RCGCGPIO_R 		;activa el reloj para el puerto B
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	ORR R0, R0, #2_00001000			; escribir bit 0 para activar el reloj del puerto B
	STR R0, [R1]
	NOP								;Espera tiempo para que el reloj se estabilice
	NOP
	
	LDR R1, =GPIO_PORTD_AMSEL_R 	; deshabilita modo analogico
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	;BIC R0, #0x0F					; deshabilita analogico para PB0 - PB3
	BIC R0, #2_00000000				; deshabilita analogico para PB0 - PB3
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTD_PCTL_R		; configura puertos como GPIO
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	;BIC R0, R0, #0x000000FF		; realiza un AND entre el primer numero y el complemento del 2do
	;BIC R0, R0, #0x0000FF00
	BIC R0, #2_11111111				; desactiva funciones alternativas
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
;	LDR R1, =GPIO_PORTB_DIR_R		; configura registro de direccion
;	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
;	BIC R0, R0, #0x07				; realiza un AND entre el primer numero y el complemento del 2do
;	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTD_DIR_R		; configura registro de direccion
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	;ORR R0, R0, #0x08
	ORR R0, R0, #2_11111111	
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTD_AFSEL_R		; configura como funcion regular
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	BIC R0, R0, #0xFF
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTD_DEN_R		; habilita el puerto B como puerto digital
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	ORR R0, R0, #0xFF
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; CONFIGURACION PUERTO E ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	LDR R1, =SYSCTL_RCGCGPIO_R 		;activa el reloj para el puerto B
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	ORR R0, R0, #2_00010000			; escribir bit 0 para activar el reloj del puerto B
	STR R0, [R1]
	NOP								;Espera tiempo para que el reloj se estabilice
	NOP
	
	LDR R1, =GPIO_PORTE_AMSEL_R 	; deshabilita modo analogico
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	;BIC R0, #0x0F					; deshabilita analogico para PB0 - PB3
	BIC R0, #2_00000000				; deshabilita analogico para PB0 - PB3
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTE_PCTL_R		; configura puertos como GPIO
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	;BIC R0, R0, #0x000000FF		; realiza un AND entre el primer numero y el complemento del 2do
	;BIC R0, R0, #0x0000FF00
	BIC R0, #2_11111111				; desactiva funciones alternativas
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
;	LDR R1, =GPIO_PORTB_DIR_R		; configura registro de direccion
;	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
;	BIC R0, R0, #0x07				; realiza un AND entre el primer numero y el complemento del 2do
;	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTE_DIR_R		; configura registro de direccion
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	;ORR R0, R0, #0x08
	ORR R0, R0, #2_11111111	
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTE_AFSEL_R		; configura como funcion regular
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	BIC R0, R0, #0xFF
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTE_DEN_R		; habilita el puerto B como puerto digital
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	ORR R0, R0, #0xFF
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	LDR R4, =tressegundos
	LDR R5, =tressegundos
	
	LDR R1, =PB6					; activa el led en el puerto B3
	LDR R0, =0x40					; manda una señal a B3
	STR R0, [R1]
	
	LDR R1, =PB7					; activa el led en el puerto B3
	LDR R0, =0x80					; manda una señal a B3
	STR R0, [R1]
	
	LDR R6, =0						;Controla en que ciclo se encuentra el proceso


Funcionlimpieza
	LDR R1, =0x55555555
	MOV pc, lr
	LTORG

DelayEncendido
	ADD R2, #1						; suma #1 a R2
	NOP								;Espera tiempo para que el reloj se estabilice
	NOP
	NOP
	NOP
	
	CMP R2, R4						; compara R2 y R4
	BNE DelayEncendido
	BEQ Regresar
	
Regresar
	BX LR


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; INICIO CICLO 0 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo0	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	LDR R1, =PB0					; Apagar azul LED 1 cadena
	LDR R0, =0x01					
	STR R0, [R1]
	
	LDR R1, =PB1					; Apagar rojo LED 1 cadena
	LDR R0, =0x02					
	STR R0, [R1]
	
	LDR R1, =PB2					; Apagar azul LED 2 cadena
	LDR R0, =0x04					
	STR R0, [R1]
	
	LDR R1, =PB3					; Apagar rojo LED 2 cadena
	LDR R0, =0x08					
	STR R0, [R1]
	
	LDR R1, =PB4					; Apagar azul LED 3 cadena
	LDR R0, =0x10					
	STR R0, [R1]
	
	LDR R1, =PB5					; Apagar rojo LED 3 cadena
	LDR R0, =0x20					
	STR R0, [R1]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN AZUL
	LDR R1, =PD0					; Apagar LED 1 de Almacen AZUL
	LDR R0, =0x01					
	STR R0, [R1]
	
	LDR R1, =PD1					; Apagar LED 2 de Almacen AZUL
	LDR R0, =0x02					
	STR R0, [R1]
	
	LDR R1, =PD2					; Apagar LED 3 de Almacen AZUL
	LDR R0, =0x04					
	STR R0, [R1]
	
	LDR R1, =PD3					; Apagar LED 4 de Almacen AZUL
	LDR R0, =0x08					
	STR R0, [R1]
	
	LDR R1, =PD6					; Apagar LED 5 de Almacen AZUL
	LDR R0, =0x40					
	STR R0, [R1]
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO
	LDR R1, =PE0					; Apagar LED 1 de Almacen ROJO
	LDR R0, =0x01					
	STR R0, [R1]
	
	LDR R1, =PE1					; Apagar LED 2 de Almacen ROJO
	LDR R0, =0x02					
	STR R0, [R1]
	
	LDR R1, =PE2					; Apagar LED 3 de Almacen ROJO
	LDR R0, =0x04					
	STR R0, [R1]
	
	LDR R1, =PE3					; Apagar LED 4 de Almacen ROJO
	LDR R0, =0x08					
	STR R0, [R1]
	
	LDR R1, =PE5					; Apagar LED 5 de Almacen ROJO
	LDR R0, =0x20					
	STR R0, [R1]
	
	LDR R2, =0						; resetea R2
	BL DelayEncendido
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; INICIO CICLO 1 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo1	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	LDR R1, =PB1					; Apagar rojo LED 1 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R2, =0						; resetea R2
	BL DelayEncendido
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; INICIO CICLO 2 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo2	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	LDR R1, =PB0					; Apagar azul LED 1 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB1					; Apagar rojo LED 1 cadena
	LDR R0, =0x02					
	STR R0, [R1]
	
	LDR R1, =PB3					; Apagar rojo LED 2 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R2, =0						; resetea R2
	BL DelayEncendido


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; INICIO CICLO 3 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo3	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	LDR R1, =PB0					; Apagar azul LED 1 cadena
	LDR R0, =0x01					
	STR R0, [R1]
	
	LDR R1, =PB1					; Apagar rojo LED 1 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB2					; Apagar azul LED 2 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB3					; Apagar rojo LED 2 cadena
	LDR R0, =0x08					
	STR R0, [R1]
	
	LDR R1, =PB5					; Apagar rojo LED 3 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R2, =0						; resetea R2
	BL DelayEncendido
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; INICIO CICLO 4 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo4	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	LDR R1, =PB0					; Apagar azul LED 1 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB1					; Apagar rojo LED 1 cadena
	LDR R0, =0x02					
	STR R0, [R1]
	
	LDR R1, =PB2					; Apagar azul LED 2 cadena
	LDR R0, =0x04					
	STR R0, [R1]
	
	LDR R1, =PB3					; Apagar rojo LED 2 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB4					; Apagar azul LED 3 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB5					; Apagar rojo LED 3 cadena
	LDR R0, =0x20					
	STR R0, [R1]
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO	
	LDR R1, =PE0					; Apagar LED 1 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	
	
	LDR R2, =0						; resetea R2
	BL DelayEncendido
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; INICIO CICLO 5 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo5	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	LDR R1, =PB0					; Apagar azul LED 1 cadena
	LDR R0, =0x01					
	STR R0, [R1]
	
	LDR R1, =PB1					; Apagar rojo LED 1 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB2					; Apagar azul LED 2 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB3					; Apagar rojo LED 2 cadena
	LDR R0, =0x08					
	STR R0, [R1]
	
	LDR R1, =PB4					; Apagar azul LED 3 cadena
	LDR R0, =0x10					
	STR R0, [R1]
	
	LDR R1, =PB5					; Apagar rojo LED 3 cadena
	LDR R0, =0x00					
	STR R0, [R1]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN AZUL
	LDR R1, =PD0					; Apagar LED 1 de Almacen AZUL
	LDR R0, =0x00				
	STR R0, [R1]
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO
	LDR R1, =PE0					; Apagar LED 1 de Almacen ROJO
	LDR R0, =0x01					
	STR R0, [R1]
	
	LDR R1, =PE1					; Apagar LED 2 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	

	
	LDR R2, =0						; resetea R2
	BL DelayEncendido
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; INICIO CICLO 6 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo6	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	LDR R1, =PB0					; Apagar azul LED 1 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB1					; Apagar rojo LED 1 cadena
	LDR R0, =0x02					
	STR R0, [R1]
	
	LDR R1, =PB2					; Apagar azul LED 2 cadena
	LDR R0, =0x04					
	STR R0, [R1]
	
	LDR R1, =PB3					; Apagar rojo LED 2 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB4					; Apagar azul LED 3 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB5					; Apagar rojo LED 3 cadena
	LDR R0, =0x20					
	STR R0, [R1]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN AZUL
	LDR R1, =PD0					; Apagar LED 1 de Almacen AZUL
	LDR R0, =0x01					
	STR R0, [R1]
	
	LDR R1, =PD1					; Apagar LED 2 de Almacen AZUL
	LDR R0, =0x00					
	STR R0, [R1]
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO
	LDR R1, =PE0					; Apagar LED 1 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PE1					; Apagar LED 2 de Almacen ROJO
	LDR R0, =0x02					
	STR R0, [R1]
	
	LDR R1, =PE2					; Apagar LED 3 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R2, =0						; resetea R2
	BL DelayEncendido


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; INICIO CICLO 7 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo7	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	LDR R1, =PB0					; Apagar azul LED 1 cadena
	LDR R0, =0x01					
	STR R0, [R1]
	
	LDR R1, =PB1					; Apagar rojo LED 1 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB2					; Apagar azul LED 2 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB3					; Apagar rojo LED 2 cadena
	LDR R0, =0x08					
	STR R0, [R1]
	
	LDR R1, =PB4					; Apagar azul LED 3 cadena
	LDR R0, =0x10					
	STR R0, [R1]
	
	LDR R1, =PB5					; Apagar rojo LED 3 cadena
	LDR R0, =0x00					
	STR R0, [R1]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN AZUL
	LDR R1, =PD0					; Apagar LED 1 de Almacen AZUL
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PD1					; Apagar LED 2 de Almacen AZUL
	LDR R0, =0x02					
	STR R0, [R1]
	
	LDR R1, =PD2					; Apagar LED 3 de Almacen AZUL
	LDR R0, =0x00					
	STR R0, [R1]
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO
	LDR R1, =PE0					; Apagar LED 1 de Almacen ROJO
	LDR R0, =0x01					
	STR R0, [R1]
	
	LDR R1, =PE1					; Apagar LED 2 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PE2					; Apagar LED 3 de Almacen ROJO
	LDR R0, =0x04					
	STR R0, [R1]
	
	LDR R1, =PE3					; Apagar LED 4 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R2, =0						; resetea R2
	BL DelayEncendido


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; INICIO CICLO 8 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo8	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	LDR R1, =PB0					; Apagar azul LED 1 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB1					; Apagar rojo LED 1 cadena
	LDR R0, =0x02					
	STR R0, [R1]
	
	LDR R1, =PB2					; Apagar azul LED 2 cadena
	LDR R0, =0x04					
	STR R0, [R1]
	
	LDR R1, =PB3					; Apagar rojo LED 2 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB4					; Apagar azul LED 3 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB5					; Apagar rojo LED 3 cadena
	LDR R0, =0x20					
	STR R0, [R1]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN AZUL
	LDR R1, =PD0					; Apagar LED 1 de Almacen AZUL
	LDR R0, =0x01					
	STR R0, [R1]
	
	LDR R1, =PD1					; Apagar LED 2 de Almacen AZUL
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PD2					; Apagar LED 3 de Almacen AZUL
	LDR R0, =0x04					
	STR R0, [R1]
	
	LDR R1, =PD3					; Apagar LED 4 de Almacen AZUL
	LDR R0, =0x00					
	STR R0, [R1]
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO
	LDR R1, =PE0					; Apagar LED 1 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PE1					; Apagar LED 2 de Almacen ROJO
	LDR R0, =0x02					
	STR R0, [R1]
	
	LDR R1, =PE2					; Apagar LED 3 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PE3					; Apagar LED 4 de Almacen ROJO
	LDR R0, =0x08					
	STR R0, [R1]
	
	LDR R1, =PE5					; Apagar LED 5 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R2, =0						; resetea R2
	BL DelayEncendido


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; INICIO CICLO 9 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo9	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	LDR R1, =PB0					; Apagar azul LED 1 cadena
	LDR R0, =0x01					
	STR R0, [R1]
	
	LDR R1, =PB1					; Apagar rojo LED 1 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB2					; Apagar azul LED 2 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB3					; Apagar rojo LED 2 cadena
	LDR R0, =0x08					
	STR R0, [R1]
	
	LDR R1, =PB4					; Apagar azul LED 3 cadena
	LDR R0, =0x10					
	STR R0, [R1]
	
	LDR R1, =PB5					; Apagar rojo LED 3 cadena
	LDR R0, =0x00					
	STR R0, [R1]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN AZUL
	LDR R1, =PD0					; Apagar LED 1 de Almacen AZUL
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PD1					; Apagar LED 2 de Almacen AZUL
	LDR R0, =0x02					
	STR R0, [R1]
	
	LDR R1, =PD2					; Apagar LED 3 de Almacen AZUL
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PD3					; Apagar LED 4 de Almacen AZUL
	LDR R0, =0x08					
	STR R0, [R1]
	
	LDR R1, =PD6					; Apagar LED 5 de Almacen AZUL
	LDR R0, =0x00					
	STR R0, [R1]
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO
	LDR R1, =PE0					; Apagar LED 1 de Almacen ROJO
	LDR R0, =0x01					
	STR R0, [R1]
	
	LDR R1, =PE1					; Apagar LED 2 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PE2					; Apagar LED 3 de Almacen ROJO
	LDR R0, =0x04					
	STR R0, [R1]
	
	LDR R1, =PE3					; Apagar LED 4 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R2, =0						; resetea R2
	BL DelayEncendido

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; INICIO CICLO 10 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo10	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	LDR R1, =PB0					; Apagar azul LED 1 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB1					; Apagar rojo LED 1 cadena
	LDR R0, =0x02					
	STR R0, [R1]
	
	LDR R1, =PB2					; Apagar azul LED 2 cadena
	LDR R0, =0x04					
	STR R0, [R1]
	
	LDR R1, =PB3					; Apagar rojo LED 2 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB4					; Apagar azul LED 3 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB5					; Apagar rojo LED 3 cadena
	LDR R0, =0x20					
	STR R0, [R1]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN AZUL
	LDR R1, =PD0					; Apagar LED 1 de Almacen AZUL
	LDR R0, =0x01					
	STR R0, [R1]
	
	LDR R1, =PD1					; Apagar LED 2 de Almacen AZUL
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PD2					; Apagar LED 3 de Almacen AZUL
	LDR R0, =0x04					
	STR R0, [R1]
	
	LDR R1, =PD3					; Apagar LED 4 de Almacen AZUL
	LDR R0, =0x00					
	STR R0, [R1]
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO
	LDR R1, =PE0					; Apagar LED 1 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PE1					; Apagar LED 2 de Almacen ROJO
	LDR R0, =0x02					
	STR R0, [R1]
	
	LDR R1, =PE2					; Apagar LED 3 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R2, =0						; resetea R2
	BL DelayEncendido
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; INICIO CICLO 11 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo11	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	LDR R1, =PB0					; Apagar azul LED 1 cadena
	LDR R0, =0x01
	STR R0, [R1]
	
	LDR R1, =PB2					; Apagar azul LED 2 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB3					; Apagar rojo LED 2 cadena
	LDR R0, =0x08					
	STR R0, [R1]
	
	LDR R1, =PB4					; Apagar azul LED 3 cadena
	LDR R0, =0x10					
	STR R0, [R1]
	
	LDR R1, =PB5					; Apagar rojo LED 3 cadena
	LDR R0, =0x00					
	STR R0, [R1]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN AZUL
;	LDR R1, =PD0					; Apagar LED 1 de Almacen AZUL
;	LDR R0, =0x00					
;	STR R0, [R1]
;	
;	LDR R1, =PD1					; Apagar LED 2 de Almacen AZUL
;	LDR R0, =0x02					
;	STR R0, [R1]
;	
;	LDR R1, =PD2					; Apagar LED 3 de Almacen AZUL
;	LDR R0, =0x00					
;	STR R0, [R1]
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO
	LDR R1, =PE0					; Apagar LED 1 de Almacen ROJO
	LDR R0, =0x01					
	STR R0, [R1]
	
	LDR R1, =PE1					; Apagar LED 2 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	
	
	LDR R2, =0						; resetea R2
	BL Regresar
	
	ALIGN
	END	