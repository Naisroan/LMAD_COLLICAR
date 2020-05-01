; ----------------------------------------------------------------------------------------------------
; MACROS
; ----------------------------------------------------------------------------------------------------

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; MACRO [LIMPIA UN REGISTRO/VARIABLE]
; ----------------------------------------------------------------------------------------------------
	CLEANR MACRO registro
		XOR registro, registro
	ENDM
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; MACRO [COPIA EL CONTENIDO DEL ORIGEN AL DESTINO (VARIABLES Y/O REGISTROS)]
; ----------------------------------------------------------------------------------------------------
	COPY MACRO destino, origen
		PUSH	EAX
		XOR		EAX, EAX
		MOV		EAX, origen
		MOV		destino, EAX
		POP		EAX
	ENDM
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; MACRO [CARGA UN BITMAP INSTANCIA (hInstance), ID DEL BITMAP, VARIABLE DONDE SE GUARDARA SUS DATOS]
; ----------------------------------------------------------------------------------------------------
	CARGAR_BITMAP MACRO instance, id_bitmap, dword_destino
		PUSH	EAX
		INVOKE	LoadBitmapA, instance, id_bitmap
		MOV		dword_destino, EAX
		POP		EAX
	ENDM
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; MACRO [COPIA EL VALOR DEL RESULTADO DE UNA FUNCION A UNA VARIABLE/REGISTRO]
; ----------------------------------------------------------------------------------------------------
	CPY_FUNC MACRO destino, func_wparams:VARARG ; VARGARG RECIPE UNA SERIE DE PARAMETROS <VALUE>,<VALUE>,...<N...>
		PUSH	EAX
		INVOKE	func_wparams
		MOV		destino, EAX
		POP		EAX
	ENDM
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; MACRO [EFECTUA UNA MULTIPLICACIÓN DWORD QUE SUS RESULTADOS LOS GUARDA EN EL PARAMETRO resultado]
; ----------------------------------------------------------------------------------------------------
	MULTI2 MACRO numA, numB, resultado
		PUSH	EAX
		PUSH	EBX

		XOR		EAX, EAX
		XOR		EBX, EBX

		MOV		EAX, numA
		MOV		EBX, numB
		MUL		EBX
		MOV		resultado, EAX
		
		POP		EBX
		POP		EAX
	ENDM
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; MACRO [EFECTUA UNA MULTIPLICACIÓN DWORD QUE SUS RESULTADOS LOS GUARDA EN EL REGISTRO EAX]
; ----------------------------------------------------------------------------------------------------
	MULTI MACRO numA, numB
		PUSH	EBX

		XOR		EAX, EAX
		XOR		EBX, EBX

		MOV		EAX, numA
		MOV		EBX, numB
		MUL		EBX
		
		POP		EBX
	ENDM
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; MACRO [EFECTUA UNA DIVISIÓN DWORD QUE SUS RESULTADOS LOS GUARDA EN LOS PARAMETROS COCIENTE]
; ----------------------------------------------------------------------------------------------------
	DIVI MACRO numerador, denominador, cociente

		MOV		EAX, numerador
		MOV		EBX, denominador
		DIV		EBX

		MOV		cociente, EAX
		
	ENDM
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; MACRO [EFECTUA UNA DIVISIÓN DWORD QUE SUS RESULTADOS LOS GUARDA EN LOS PARAMETROS COCIENTE Y RESIDUO]
; ----------------------------------------------------------------------------------------------------
	DIVI2 MACRO numerador, denominador, cociente, residuo
		PUSH	EAX
		PUSH	EBX
		PUSH	EDX

		XOR		EAX, EAX
		XOR		EBX, EBX
		XOR		EDX, EDX

		MOV		EAX, numerador
		MOV		EBX, denominador
		DIV		EBX

		MOV		cociente, EAX
		MOV		residuo, EDX
		
		POP		EDX
		POP		EBX
		POP		EAX
	ENDM
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; MACRO [GENERA UN NUMERO RANDOM Y LO GUARDA EN EAX]
; ----------------------------------------------------------------------------------------------------
	RAND MACRO limiteIzq, limiteDer
		;INVOKE	GetTickCount
		;INVOKE	nseed, EAX
	ENDM
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>