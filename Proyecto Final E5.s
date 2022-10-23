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
;PD4 EQU 0x40007040
;PD5 EQU 0x40007080	
PD6 EQU 0x40007100	; LED azul 5
;PD7 EQU 0x40007200	
	
PE0 EQU 0x40024004	; LED rojo 1
PE1 EQU 0x40024008	; LED rojo 2
PE2 EQU 0x40024010	; LED rojo 3
PE3 EQU 0x40024020	; SERVOMOTOR
PE4 EQU 0x40024040	; LED rojo 4
PE5 EQU 0x40024080	; LED rojo 5
;PE6 EQU 0x40024100	
;PE7 EQU 0x40024200
	
PE		EQU 0x400243FC;Servomotor (PIN E3)
PCTL	EQU 2_11111111;Valor de los pines utilizados en B
cont	EQU 3000	;constante 1ms
contb	EQU 77000	;constante 19 ms
contc	EQU 7500	;constante 4 ms 
contd	EQU 72500	;constante 16 ms
conte	EQU 50		;20 ms *50 = 1S
;contf	EQU 6000	;constante 3 ms
;contg	EQU 74000   ; 17 ms
;conth	EQU 200


;tressegundos EQU 6000000
;tressegundos EQU 3000000	;;;;;;Tiempo adecuado
tressegundos EQU 1000000
	
		
		;AREA 	codigo, CODE, READONLY, ALIGN=2
		AREA    |.text|, CODE, READONLY, ALIGN=2
		THUMB
		EXPORT Start
Start
	LDR R4, =tressegundos
	LDR R2, =0						; resetea R2
	
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
	
	LDR R1, =GPIO_PORTB_DIR_R		; configura registro de direccion
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	;ORR R0, R0, #0x08
	ORR R0, R0, #2_11111111	
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTB_AFSEL_R		; configura como funcion regular
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	;BIC R0, R0, #0x0F
	BIC R0, R0, #2_01111111				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	STR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	
	LDR R1, =GPIO_PORTB_DEN_R		; habilita el puerto B como puerto digital
	LDR R0, [R1]					; carga en R0 el valor almacenado al que apunta R1
	;ORR R0, R0, #0x0F
	ORR R0, R0, #2_01111111				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
	
	B Ciclo0

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
;;;;;;;;;;;;;;;;;;;; Colas ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Cola1_Azul_Apagado
	LDR R1, =PB0					; Apagar azul LED 1 cadena
	LDR R0, =0x01					
	STR R0, [R1]
	BX LR

Cola2_Azul_Apagado
	LDR R1, =PB2					; Apagar azul LED 2 cadena
	LDR R0, =0x04					
	STR R0, [R1]
	BX LR
	
Cola3_Azul_Apagado
	LDR R1, =PB4					; Apagar azul LED 3 cadena
	LDR R0, =0x10					
	STR R0, [R1]
	BX LR
	
Cola1_Rojo_Azul
	LDR R1, =PB0					; Encender azul LED 1 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB1					; Apagar rojo LED 1 cadena
	LDR R0, =0x02					
	STR R0, [R1]
	
	BX LR
	
Cola1_Azul_Rojo
	LDR R1, =PB0					; Apagar azul LED 1 cadena
	LDR R0, =0x01					
	STR R0, [R1]
	
	LDR R1, =PB1					; Encender rojo LED 1 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	BX LR
	
Cola2_Rojo_Azul
	LDR R1, =PB2					; Encender azul LED 2 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB3					; Apagar rojo LED 2 cadena
	LDR R0, =0x08					
	STR R0, [R1]
	
	BX LR
	
Cola2_Azul_Rojo
	LDR R1, =PB2					; Apagar azul LED 2 cadena
	LDR R0, =0x04					
	STR R0, [R1]
	
	LDR R1, =PB3					; Encender rojo LED 2 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	BX LR
	
Cola3_Rojo_Azul
	LDR R1, =PB4					; Encender azul LED 3 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PB5					; Apagar rojo LED 3 cadena
	LDR R0, =0x20					
	STR R0, [R1]
	
	BX LR
	
Cola3_Azul_Rojo
	LDR R1, =PB4					; Apagar azul LED 3 cadena
	LDR R0, =0x10					
	STR R0, [R1]
	
	LDR R1, =PB5					; Encender rojo LED 3 cadena
	LDR R0, =0x00					
	STR R0, [R1]
	
	BX LR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; Almacenes rojos ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Almacen1_Rojo_Encendido
	LDR R1, =PE0					; Encender LED 1 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	
	BX LR

Almacen1_Rojo_Apagado
	LDR R1, =PE0					; Apagar LED 1 de Almacen ROJO
	LDR R0, =0x01					
	STR R0, [R1]
	
	BX LR

Almacen2_Rojo_Encendido
	LDR R1, =PE1					; Encender LED 2 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	
	BX LR

Almacen2_Rojo_Apagado
	LDR R1, =PE1					; Apagar LED 1 de Almacen ROJO
	LDR R0, =0x02					
	STR R0, [R1]
	
	BX LR
	
Almacen3_Rojo_Encendido
	LDR R1, =PE2					; Encender LED 3 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	
	BX LR
	
Almacen3_Rojo_Apagado
	LDR R1, =PE2					; Apagar LED 3 de Almacen ROJO
	LDR R0, =0x04					
	STR R0, [R1]
	
	BX LR
	
Almacen4_Rojo_Encendido
	LDR R1, =PE4					; Encender LED 4 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	
	BX LR
	
Almacen4_Rojo_Apagado
	LDR R1, =PE4					; Apagar LED 4 de Almacen ROJO
	LDR R0, =0x10					
	STR R0, [R1]
	
	BX LR
	
Almacen5_Rojo_Encendido
	LDR R1, =PE5					; Encender LED 5 de Almacen ROJO
	LDR R0, =0x00					
	STR R0, [R1]
	
	BX LR
	
Almacen5_Rojo_Apagado
	LDR R1, =PE5					; Encender LED 5 de Almacen ROJO
	LDR R0, =0x20					
	STR R0, [R1]
	
	BX LR
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; Almacenes azules ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
Almacen1_Azul_Encendido
	LDR R1, =PD0					; Encender LED 1 de Almacen AZUL
	LDR R0, =0x00				
	STR R0, [R1]
	
	BX LR

Almacen1_Azul_Apagado
	LDR R1, =PD0					; Apagar LED 1 de Almacen AZUL
	LDR R0, =0x01				
	STR R0, [R1]
	
	BX LR
	
Almacen2_Azul_Encendido
	LDR R1, =PD1					; Encender LED 2 de Almacen AZUL
	LDR R0, =0x00					
	STR R0, [R1]
	
	BX LR
	
Almacen2_Azul_Apagado
	LDR R1, =PD1					; Apagar LED 2 de Almacen AZUL
	LDR R0, =0x02					
	STR R0, [R1]
	
	BX LR
	
Almacen3_Azul_Encendido
	LDR R1, =PD2					; Encender LED 3 de Almacen AZUL
	LDR R0, =0x00					
	STR R0, [R1]
	
	BX LR	
	
Almacen3_Azul_Apagado
	LDR R1, =PD2					; Apagar LED 3 de Almacen AZUL
	LDR R0, =0x04					
	STR R0, [R1]
	
	BX LR	
	
Almacen4_Azul_Encendido
	LDR R1, =PD3					; Encender LED 4 de Almacen AZUL
	LDR R0, =0x00					
	STR R0, [R1]
	
	BX LR	
	
Almacen4_Azul_Apagado
	LDR R1, =PD3					; Apagar LED 4 de Almacen AZUL
	LDR R0, =0x08					
	STR R0, [R1]
	
	BX LR
	
Almacen5_Azul_Encendido
	LDR R1, =PD6					; Encender LED 5 de Almacen AZUL
	LDR R0, =0x00					
	STR R0, [R1]
	
	BX LR

Almacen5_Azul_Apagado
	LDR R1, =PD6					; Encender LED 5 de Almacen AZUL
	LDR R0, =0x40					
	STR R0, [R1]
	
	BX LR
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Contador 
	SUB R10, #1
	CMP R10, #0
	BNE Contador 
	BX LR
	
dos1
	SUB R11, #1
	LDR R7, =PE3
	MOV R6, #2_00001000
	STR R6, [R7]
	LDR R10,= contc ; asigmna 1 ms 
	;BL Contador
	B Contador

dos2
	LDR R7, =PE3
	MOV R6, #2_00000000
	STR R6, [R7]
	LDR R10,= contd ; asigna 19 ms
	;BL Contador
	B Contador
	
tres1
	SUB R11, #1
	LDR R7, =PE3
	MOV R6, #2_00001000
	STR R6, [R7]
	LDR R10,= cont ; 4 ms
	B Contador

tres2
	LDR R7, =PE3
	MOV R6, #2_00000000
	STR R6, [R7]
	LDR R10,= contb ; 4 ms
	B Contador

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; INICIO CICLO 0 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo0	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	BL Cola1_Azul_Apagado
	
	LDR R1, =PB1					; Apagar rojo LED 1 cadena
	LDR R0, =0x02					
	STR R0, [R1]
	
	BL Cola2_Azul_Apagado
	
	LDR R1, =PB3					; Apagar rojo LED 2 cadena
	LDR R0, =0x08					
	STR R0, [R1]
	
	BL Cola3_Azul_Apagado
	
	LDR R1, =PB5					; Apagar rojo LED 3 cadena
	LDR R0, =0x20					
	STR R0, [R1]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN AZUL
	BL Almacen1_Azul_Apagado
	BL Almacen2_Azul_Apagado
	BL Almacen3_Azul_Apagado
	BL Almacen4_Azul_Apagado
	BL Almacen5_Azul_Apagado
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO
	BL Almacen1_Rojo_Apagado
	BL Almacen2_Rojo_Apagado
	BL Almacen3_Rojo_Apagado
	BL Almacen4_Rojo_Apagado
	BL Almacen5_Rojo_Apagado
	
	LDR R2, =0						; resetea R2
	BL DelayEncendido
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; INICIO CICLO 1 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo1	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	BL Cola1_Azul_Rojo
	
	LDR R2, =0						; resetea R2
	BL DelayEncendido
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; INICIO CICLO 2 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo2	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	BL Cola1_Rojo_Azul
	BL Cola2_Azul_Rojo
	
	LDR R2, =0						; resetea R2
	BL DelayEncendido


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; INICIO CICLO 3 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo3	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	BL Cola1_Azul_Rojo
	BL Cola2_Rojo_Azul
	BL Cola3_Azul_Rojo
	
	LDR R2, =0						; resetea R2
	LDR R11,= conte
	BL DelayEncendido
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; INICIO CICLO 4 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo4	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL SERVO ROJO
	BL dos1
	BL dos2
	CMP R11, #0	
	BNE Ciclo4
	LDR R11,= conte
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	BL Cola1_Rojo_Azul
	BL Cola2_Azul_Rojo
	BL Cola3_Rojo_Azul
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO	
	BL Almacen1_Rojo_Encendido

	
	LDR R2, =0						; resetea R2
	BL DelayEncendido
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; INICIO CICLO 5 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo5	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	 CONTROL SERVO AZUL
	BL tres1
	BL tres2
	CMP R11, #0	
	BNE Ciclo5
	LDR R11,= conte
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	BL Cola1_Azul_Rojo
	BL Cola2_Rojo_Azul
	BL Cola3_Azul_Rojo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN AZUL
	BL Almacen1_Azul_Encendido
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO
	BL Almacen1_Rojo_Apagado
	BL Almacen2_Rojo_Encendido

	
	LDR R2, =0						; resetea R2
	BL DelayEncendido
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; INICIO CICLO 6 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo6	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL SERVO ROJO
	BL dos1
	BL dos2
	CMP R11, #0	
	BNE Ciclo6
	LDR R11,= conte
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	BL Cola1_Rojo_Azul
	BL Cola2_Azul_Rojo
	BL Cola3_Rojo_Azul
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN AZUL
	BL Almacen1_Azul_Apagado
	BL Almacen2_Azul_Encendido
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO
	BL Almacen1_Rojo_Encendido
	BL Almacen2_Rojo_Apagado
	BL Almacen3_Rojo_Encendido
	
	LDR R2, =0						; resetea R2
	BL Funcionlimpieza
	BL DelayEncendido
	BL Ciclo7

Funcionlimpieza
	LDR R1, =0x55555555
	MOV pc, lr
	LTORG

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; INICIO CICLO 7 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo7	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	 CONTROL SERVO AZUL
	BL tres1
	BL tres2
	CMP R11, #0	
	BNE Ciclo7
	LDR R11,= conte
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	BL Cola1_Azul_Rojo
	BL Cola2_Rojo_Azul
	BL Cola3_Azul_Rojo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN AZUL
	BL Almacen1_Azul_Encendido
	BL Almacen2_Azul_Apagado
	BL Almacen3_Azul_Encendido
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO
	BL Almacen1_Rojo_Apagado
	BL Almacen2_Rojo_Encendido
	BL Almacen3_Rojo_Apagado
	BL Almacen4_Rojo_Encendido
	
	LDR R2, =0						; resetea R2
	BL DelayEncendido


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; INICIO CICLO 8 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo8	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL SERVO ROJO
	BL dos1
	BL dos2
	CMP R11, #0	
	BNE Ciclo8
	LDR R11,= conte
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	BL Cola1_Rojo_Azul
	BL Cola2_Azul_Rojo
	BL Cola3_Rojo_Azul
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN AZUL
	BL Almacen1_Azul_Apagado
	BL Almacen2_Azul_Encendido
	BL Almacen3_Azul_Apagado
	BL Almacen4_Azul_Encendido
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO
	BL Almacen1_Rojo_Encendido
	BL Almacen2_Rojo_Apagado
	BL Almacen3_Rojo_Encendido
	BL Almacen4_Rojo_Apagado
	BL Almacen5_Rojo_Encendido
	
	LDR R2, =0						; resetea R2
	BL DelayEncendido


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; INICIO CICLO 9 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo9	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	 CONTROL SERVO AZUL
	BL tres1
	BL tres2
	CMP R11, #0	
	BNE Ciclo9
	LDR R11,= conte
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	BL Cola1_Azul_Rojo
	BL Cola2_Rojo_Azul
	BL Cola3_Azul_Rojo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN AZUL
	BL Almacen1_Azul_Encendido
	BL Almacen2_Azul_Apagado
	BL Almacen3_Azul_Encendido
	BL Almacen4_Azul_Apagado
	BL Almacen5_Azul_Encendido
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO
	BL Almacen1_Rojo_Apagado
	BL Almacen2_Rojo_Encendido
	BL Almacen3_Rojo_Apagado
	BL Almacen4_Rojo_Encendido
	
	LDR R2, =0						; resetea R2
	BL DelayEncendido

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; INICIO CICLO 10 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo10	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL SERVO ROJO
	BL dos1
	BL dos2
	CMP R11, #0	
	BNE Ciclo10
	LDR R11,= conte
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	BL Cola1_Rojo_Azul
	BL Cola2_Azul_Rojo
	BL Cola3_Rojo_Azul
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN AZUL
	BL Almacen1_Azul_Apagado
	BL Almacen2_Azul_Encendido
	BL Almacen3_Azul_Apagado
	BL Almacen4_Azul_Encendido
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO
	BL Almacen1_Rojo_Encendido
	BL Almacen2_Rojo_Apagado
	BL Almacen3_Rojo_Encendido
	
	LDR R2, =0						; resetea R2
	BL DelayEncendido
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; INICIO CICLO 11 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ciclo11	;TODO APAGADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	 CONTROL SERVO AZUL
	BL tres1
	BL tres2
	CMP R11, #0	
	BNE Ciclo11
	LDR R11,= conte
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	BL Cola1_Azul_Apagado
	BL Cola2_Rojo_Azul
	BL Cola3_Azul_Rojo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN AZUL
	BL Almacen1_Azul_Encendido
	BL Almacen2_Azul_Apagado
	BL Almacen3_Azul_Encendido
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO
	BL Almacen1_Rojo_Apagado
	BL Almacen2_Rojo_Encendido
	
	
	LDR R2, =0						; resetea R2
	BL DelayEncendido

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; INICIO CICLO 12 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Ciclo12
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL SERVO ROJO
	BL dos1
	BL dos2
	CMP R11, #0	
	BNE Ciclo12
	LDR R11,= conte
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	BL Cola2_Azul_Apagado
	BL Cola3_Rojo_Azul
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN AZUL
	BL Almacen1_Azul_Apagado
	BL Almacen2_Azul_Encendido
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL ALMACEN ROJO
	BL Almacen1_Rojo_Encendido


	LDR R2, =0						; resetea R2
	BL DelayEncendido
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; INICIO CICLO 13 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Ciclo13
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	 CONTROL SERVO AZUL
	BL tres1
	BL tres2
	CMP R11, #0	
	BNE Ciclo13
	LDR R11,= conte
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	CONTROL CADENA
	BL Cola3_Azul_Apagado
	BL Almacen1_Azul_Encendido

	LDR R2, =0						; resetea R2
	BL DelayEncendido
	LDR R2, =0
	BL DelayEncendido
	LDR R2, =0
	BL DelayEncendido
	LDR R2, =0
	BL DelayEncendido

CicloFinal
	BL Ciclo0
	
	ALIGN
	END	