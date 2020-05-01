; ----------------------------------------------------------------------------------------------------
; ESTRUCTURAS
; ----------------------------------------------------------------------------------------------------

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ESTRUCTURA SPRITE
; ----------------------------------------------------------------------------------------------------
	SPRITE STRUCT

		X			DWORD	0 ; POSICION EN X
		Y			DWORD	0 ; POSICION EN Y
		BITMAP		DWORD	0 ; ID DEL BITMAP
		hDC			HDC		? ; HDC
		W			DWORD	0 ; ANCHO
		H			DWORD	0 ; ALTO
		DrawIniX	DWORD	0
		DrawIniY	DWORD	0

	SPRITE ENDS
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ESTRUCTURAS PARA CONTROL DE XBOX
; ----------------------------------------------------------------------------------------------------
	XINPUT_GAMEPAD	STRUCT

		wButtons		WORD	?
		bLeftTrigger	BYTE	?
		bRightTrigger	BYTE	?
		sThumbLX		WORD	?
		sThumbLY		WORD	?
		sThumbRX		WORD	?
		sThumbRY		WORD	?

	XINPUT_GAMEPAD  ENDS

	XINPUT_STATE STRUCT

		dwPacketNumber	DWORD			?
		Gamepad			XINPUT_GAMEPAD	<>

	XINPUT_STATE	ENDS
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>