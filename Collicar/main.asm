; COLLICAR (LENGUAJE ENSAMBLADOR - PROYECTO FINAL) 

; ----------------------------------------------------------------------------------------------------
; ACERCA DE:
; ----------------------------------------------------------------------------------------------------

; EL JUEGO TRATA SOBRE ESQUIVAR OBSTACULOS CON TU VEHICULO EN UNA AUTOPISTA DE DOS CARRILES, 
; LOS OBSTACULOS SON ALEATORIOS, ADEMÁS, SI CHOCAS CON UNO TU VIDA BAJARÁ, SIN EMBARGO, PUEDES 
; ADQUIRIR VIDA CON ALGUNOS OBJETOS QUE TE ENCUENTRES POR EL CAMINO, GANAS SI SOBREVIVES 60 SEG DE 
; OLEADAS DE OBSTACULOS.

; ----------------------------------------------------------------------------------------------------
; INCLUDES
; ----------------------------------------------------------------------------------------------------

INCLUDE		Settings.inc

INCLUDE		Herramientas/Constantes.inc
INCLUDE		Herramientas/Macros.inc
INCLUDE		Herramientas/Estructuras.inc
INCLUDE		Herramientas/Prototipos.inc

; ----------------------------------------------------------------------------------------------------
; DATA
; ----------------------------------------------------------------------------------------------------

.DATA

	; VARIABLES PARA EL DIALOGO
	hInstance		DWORD	?
	hIcon			DWORD	?

	; VARIABLES PARA GAMEPAD
	gamePadState	XINPUT_STATE	<>
	gpIsConnected	DWORD			0

	; VARIABLES DE CONFIGURACION DE JUEGO
	startGame		BYTE	0
	instrucciones	BYTE	0
	menuSegFrame	BYTE	0
	keyPress		DWORD	0
	
	; VARIABLES PARA LOS SPRITES DEL JUEGOS
	spritesMenu		SPRITE	{ 0, 0, 0, ?, DLG_ANCHO, DLG_ALTO }, { 0, 0, 0, ?, DLG_ANCHO, DLG_ALTO }, { 0, 0, 0, ?, DLG_ANCHO, DLG_ALTO }
	spriteBG		SPRITE	{ POSINI_X_BG, POSINI_Y_BG, 0, ?, BACKGROUND_W, BACKGROUND_H }
	spriteCar		SPRITE	{ POSINI_X_CAR, POSINI_Y_CAR, 0, ?, CAR_W, CAR_H }
	spriteLifeBar	SPRITE	{ POSINI_X_LB, POSINI_Y_LB, 0, ?, LIFEBAR_W, LIFEBAR_H }, { POSINI_X_LB + 5, POSINI_Y_LB + 4, 0, ?, LIFE_W, LIFE_H }
	spriteStateWinner	SPRITE	{ 0, 0, 0, ?, DLG_ANCHO, DLG_ALTO }, { 0, 0, 0, ?, DLG_ANCHO, DLG_ALTO }
	; spriteInfo		SPRITE	{ POSINI_X_INFO, POSINI_Y_INFO, 0, ?, INFO_W, INFO_H }
	spritesItems	SPRITE	{ POSINI_X_ITEM, POSINI_Y_ITEM, 0, ?, 65, 95, 251, 0 },		; ITEM [ENEMIGO -> CARRO]
							{ POSINI_X_ITEM, POSINI_Y_ITEM, 0, ?, 54, 43, 439, 0 },		; ITEM [ENEMIGO -> LLANTA]
							{ POSINI_X_ITEM, POSINI_Y_ITEM, 0, ?, 61, 35, 316, 0 },		; ITEM [VIDA -> KIT]
							{ POSINI_X_ITEM, POSINI_Y_ITEM, 0, ?, 20, 51, 377, 0},		; ITEM [VIDA -> LLAVE]
							{ POSINI_X_ITEM, POSINI_Y_ITEM, 0, ?, 42, 53, 397, 0}		; ITEM [VIDA -> GASOLINA]


	; VARIABLES PARA OTRAS COSAS DEL JUEGO
	vidaCarro		DWORD 100
	drawItemPos		DWORD 0
	drawItem		BYTE  0
	stateWinner		DWORD  0 ; 0 =  DEFAULT, 1 = GANO, 2 = PERDIO
	drawItemPosIniX	DWORD 0

; ----------------------------------------------------------------------------------------------------
; CODE
; ----------------------------------------------------------------------------------------------------

.CODE	

	main PROC
	
		INVOKE	GetModuleHandle, NULL
		MOV		hInstance, EAX
		INVOKE	DialogBoxParam, hInstance, DLG_MAIN, NULL, ADDR DlgProcMain, NULL
		INVOKE	ExitProcess, 0

		RET

	main ENDP

; ----------------------------------------------------------------------------------------------------
; IMPLEMENTACIÓN DE FUNCIÓN [DlgProcMain]
; ----------------------------------------------------------------------------------------------------

	DlgProcMain	PROC hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
			
		LOCAL hDC:DWORD
		LOCAL paintStruct:PAINTSTRUCT
			
		.IF uMsg == WM_INITDIALOG

			; COLOCO EL ICONO DEL DIALOGO
			CPY_FUNC hIcon, LoadIcon, hInstance, ID_ICON
			INVOKE	SendMessage, hWnd, WM_SETICON, 1, hIcon

			; ESTABLEZCO LA POSICION DEL DIALOGO
			INVOKE	SetWindowPos, hWnd, NULL, POS_X_WND, POS_Y_WND, DLG_ANCHO, DLG_ALTO, SWP_NOOWNERZORDER

			; ESTABLEZCO LOS TIMERS (ID Y MILISEGUNDOS)
			INVOKE	SetTimer, hWnd, ID_TIMER_RENDER, MS_TIMER_RENDER, NULL
			INVOKE	SetTimer, hWnd, ID_TIMER_BG, MS_TIMER_BG, NULL
			INVOKE	SetTimer, hWnd, ID_TIMER_MENU, MS_TIMER_MENU, NULL
			
			; CARGA DE BITMAPS
			;
			; SPRITES DE MENU
			CARGAR_BITMAP	hInstance, ID_BITMAP_MENU_01, spritesMenu[0].BITMAP
			CARGAR_BITMAP	hInstance, ID_BITMAP_MENU_02, spritesMenu[SIZEOF(SPRITE)].BITMAP
			CARGAR_BITMAP	hInstance, ID_BITMAP_INSTRUCCION, spritesMenu[SIZEOF(SPRITE) * 2].BITMAP
			CARGAR_BITMAP	hInstance, ID_BITMAP_WINNER_02, spriteStateWinner[0].BITMAP
			CARGAR_BITMAP	hInstance, ID_BITMAP_WINNER_01, spriteStateWinner[SIZEOF(SPRITE)].BITMAP
			; 
			; SPRITES DEL JUEGO
			CARGAR_BITMAP	hInstance, ID_BITMAP_BACKGROUND, spriteBG.BITMAP
			CARGAR_BITMAP	hInstance, ID_BITMAP_CAR, spriteCar.BITMAP
			; CARGAR_BITMAP	hInstance, ID_BITMAP_INFO, spriteInfo.BITMAP
			CARGAR_BITMAP	hInstance, ID_BITMAP_LIFEBAR, spriteLifeBar[0].BITMAP
			CARGAR_BITMAP	hInstance, ID_BITMAP_LIFE, spriteLifeBar[SIZEOF(SPRITE)].BITMAP
			CARGAR_BITMAP	hInstance, ID_BITMAP_CAR, spritesItems[0].BITMAP
			CARGAR_BITMAP	hInstance, ID_BITMAP_CAR, spritesItems[SIZEOF(SPRITE)].BITMAP
			CARGAR_BITMAP	hInstance, ID_BITMAP_CAR, spritesItems[SIZEOF(SPRITE) * 2].BITMAP
			CARGAR_BITMAP	hInstance, ID_BITMAP_CAR, spritesItems[SIZEOF(SPRITE) * 3].BITMAP
			CARGAR_BITMAP	hInstance, ID_BITMAP_CAR, spritesItems[SIZEOF(SPRITE) * 4].BITMAP

		.ELSEIF uMsg == WM_PAINT

			INVOKE	BeginPaint, hWnd, ADDR paintStruct
			MOV		hDC, EAX

			INVOKE	OnPaint, hDC ; AQUI SE DIBUJA TODO

			INVOKE	EndPaint, hWnd, ADDR paintStruct
			INVOKE	SwapBuffers, hDC

		.ELSEIF uMsg == WM_KEYDOWN

			INVOKE	OnKeyDown, hWnd, wParam

		.ELSEIF uMsg == WM_TIMER

			; --------------------------------------------------
			; LOGICA DEL JUEGO
			; --------------------------------------------------

			; OTROS TIMERS UTILES, NO LOS PUSE AQUI PARA NO REVOLVERME/CONFUNDIRME
			INVOKE	OnTimer, wParam 

			.IF wParam == ID_TIMER_RENDER
			
				.IF startGame == 1
			
					.IF vidaCarro == 0

						MOV	stateWinner, 2
						; INVOKE Reset, hWnd

					.ENDIF

					.IF  stateWinner == 0
					
						; MOVEMOS ITEM ALEATORIO ACTUAL
						.IF drawItem != 0
							XOR		EAX, EAX
							XOR		EBX, EBX	
							MOV		EAX, SIZEOF(SPRITE)
							MOV		EBX, drawItemPos
							MUL		EBX
							XOR		EBX, EBX	
							MOV		EBX, spritesItems[EAX].Y
							ADD		EBX, VELOCITY_ITEM
							MOV		spritesItems[EAX].Y, EBX
							XOR		EBX, EBX
							MOV		EBX, drawItemPosIniX
							MOV		spritesItems[EAX].X, EBX
						.ENDIF

						; MUEVE EL CARRO
						INVOKE	Move, hWnd 

						; DETECTAMOS COLISION
						XOR		EAX, EAX
						XOR		EBX, EBX	
						MOV		EAX, SIZEOF(SPRITE)
						MOV		EBX, drawItemPos
						MUL		EBX
						INVOKE  IsColision, spritesItems[EAX]

						.IF EAX == 1
							INVOKE	Colision, drawItemPos
						.ENDIF

					.ENDIF

				.ENDIF
			
				; --------------------------------------------------
				; CONTROL DE START Y BACK [GAMEPAD]
				; --------------------------------------------------
				MOV			gpIsConnected, 1
				CPY_FUNC	gpIsConnected, XInputGetState, 0, OFFSET gamePadState

				; SE VERIFICA SI EL GAMEPAD ESTA CONECTADO
				.IF	gpIsConnected == 0

					; SI EL JUEGO NO ESTA INICIADO, Y PRESIONAMOS START...
					.IF gamePadState.Gamepad.wButtons == XINPUT_GAMEPAD_START && startGame == 0

						.IF instrucciones == 0
							MOV	instrucciones, 1
							JMP SALTA
						.ENDIF

						.IF instrucciones == 1
				
							MOV		instrucciones, 0
							INVOKE	Start, hWnd

						.ENDIF

						SALTA:

					.ENDIF
					
					; SI EL JUEGO ESTA INICIADO, Y PRESIONAMOS BACK...
					.IF gamePadState.Gamepad.wButtons == XINPUT_GAMEPAD_BACK && startGame == 1

						.IF stateWinner == 1 || stateWinner == 2
							INVOKE	Reset, hWnd
							INVOKE	Start, hWnd
							RET
						.ENDIF

						INVOKE	Reset, hWnd

					.ENDIF

				.ENDIF

				INVOKE	InvalidateRect, hWnd, NULL, FALSE
				INVOKE	UpdateWindow, hWnd

			.ENDIF

		.ELSEIF uMsg == WM_CLOSE

			INVOKE	EndDialog, hWnd, 0

		.ELSEIF uMsg == WM_DESTROY
		
			; BORRAMOS LOS TIMERS QUE CREAMOS
			INVOKE	KillTimer, hWnd, ID_TIMER_RENDER
			INVOKE	KillTimer, hWnd, ID_TIMER_BG
			INVOKE	KillTimer, hWnd, ID_TIMER_MENU
			INVOKE	KillTimer, hWnd, ID_TIMER_WIN
			INVOKE	KillTimer, hWnd, ID_TIMER_ITEM
			INVOKE	KillTimer, hWnd, ID_TIMER_SEG

			INVOKE	PostQuitMessage, 0
				
		.ENDIF

		CLEANR		EAX
		RET

	DlgProcMain ENDP

; ----------------------------------------------------------------------------------------------------
; IMPLEMENTACIÓN DE FUNCIÓN [OnKeyDown]
; ----------------------------------------------------------------------------------------------------

	OnKeyDown	PROC hWnd:HWND, keyCode:WPARAM

		; SI SE PRESIONA LA TECLA SUPR SE CIERRA EL JUEGO (PORQUE LA ESC NO FUNCIONA JAJA)
		.IF	keyCode == KEY_SUPR

			INVOKE	EndDialog, hWnd, 0

		.ENDIF

		; SI SE PRESIONA LA TECLA BACKSPACE SE RESETEA EL JUEGO
		.IF	keyCode == KEY_BACKSP

			.IF stateWinner == 1 || stateWinner == 2
				INVOKE	Reset, hWnd
				INVOKE	Start, hWnd
				RET
			.ENDIF

			INVOKE	Reset, hWnd

		.ENDIF
		
		.IF startGame == 0

			.IF keyCode == KEY_SPACE
			
				.IF instrucciones == 0
					MOV	instrucciones, 1
					RET
				.ENDIF

				.IF instrucciones == 1
				
					MOV		instrucciones, 0
					INVOKE	Start, hWnd

				.ENDIF

			.ENDIF

		.ENDIF

		RET

	OnKeyDown	ENDP

; ----------------------------------------------------------------------------------------------------
; IMPLEMENTACIÓN DE FUNCIÓN [OnTimer]
; ----------------------------------------------------------------------------------------------------

	OnTimer	PROC timerCode:WPARAM

		.IF timerCode == ID_TIMER_SEG && startGame == 1 && stateWinner == 0
		
			.IF vidaCarro > 0
				SUB	vidaCarro, 1
			.ENDIF

		.ENDIF

		; ESTE TIMER ES EL QUE MUEVE EL FONDO (AQUI SE PONDRAN TODOS LOS OBJETOS QUE SE MUEVAN JUNTO CON EL FONDO)
		.IF timerCode == ID_TIMER_BG && startGame == 1 && stateWinner != 2

			.IF spriteBG.Y <= 0
					
				MOV	spriteBG.Y, -900

			.ENDIF

			ADD	spriteBG.Y, VELOCITY_BACKGROUND

		.ENDIF

		; ESTE TIMER ES EL QUE AL PASAR X SEGUNDOS GANAS
		.IF timerCode == ID_TIMER_WIN && startGame == 1

			MOV		stateWinner, 1
			; INVOKE	Reset, hWnd

		.ENDIF 

		; ESTE TIMER ES EL QUE AL PASAR X SEGUNDOS GENERA UNA POSICION DE ITEM
		.IF timerCode == ID_TIMER_ITEM && startGame == 1 && stateWinner == 0

			INVOKE	ResetItems
			INVOKE	RandItem

		.ENDIF 

		; ESTE ES EL TIMER DEL MENU, CADA CIERTO TIEMPO INTERCAMBIA FRAMES PARA DAR EFECTO DE ANIMACIÓN
		; DE LAS LETRAS Y EL CARRO
		.IF timerCode == ID_TIMER_MENU && startGame == 0

			.IF	menuSegFrame == 1

				MOV menuSegFrame, 0

			.ELSE

				MOV menuSegFrame, 1

			.ENDIF

		.ENDIF

		RET

	OnTimer	ENDP

; ----------------------------------------------------------------------------------------------------
; IMPLEMENTACIÓN DE FUNCIÓN [OnTimer]
; ----------------------------------------------------------------------------------------------------

	OnPaint	PROC hDC:HDC
	
		.IF startGame == 0

			; MOSTRAMOS EL MENU MIENTRAS QUE LA VARIABLE startGame SEA 0
			INVOKE	MostrarMenu, hDC

		.ELSE

			; DIBUJA FONDO
			INVOKE	Draw, spriteBG, hDC
			
			.IF stateWinner == 0

				; DIBUJA FONDO DE VIDA Y BARRA VERDE
				INVOKE	DrawTsparent, spriteLifeBar[0], hDC
				INVOKE	DrawLife, spriteLifeBar[SIZEOF(SPRITE)], hDC, vidaCarro
				; INVOKE	DrawTsparent, spriteInfo, hDC

			.ENDIF

			; DIBJUAMOS ITEM ALEATORIO
			.IF drawItem != 0 && stateWinner != 1

				XOR		EAX, EAX
				XOR		EBX, EBX	

				MOV		EAX, SIZEOF(SPRITE)
				MOV		EBX, drawItemPos
				MUL		EBX

				INVOKE	DrawTsparent, spritesItems[EAX], hDC

			.ENDIF
			
			; DIBUJA CARRO
			INVOKE	DrawTsparent, spriteCar, hDC

			.IF stateWinner == 1

				; DIBUJA PANTALLA GANADORA
				INVOKE	DrawTsparent, spriteStateWinner, hDC

			.ELSEIF stateWinner == 2

				; DIBUJA PANTALLA DE FRACASO XD
				INVOKE	DrawTsparent, spriteStateWinner[SIZEOF(SPRITE)], hDC

			.ENDIF

		.ENDIF

		RET

	OnPaint	ENDP

; ----------------------------------------------------------------------------------------------------
; IMPLEMENTACIÓN DE FUNCIÓN [MostrarMenu]
; ----------------------------------------------------------------------------------------------------

	MostrarMenu	PROC hDC:HDC

		.IF instrucciones != 1

			.IF menuSegFrame == 1

				INVOKE	Draw, spritesMenu[0], hDC

			.ELSE

				INVOKE	Draw, spritesMenu[SIZEOF(SPRITE)], hDC

			.ENDIF

		.ELSEIF
		
			INVOKE	Draw, spritesMenu[SIZEOF(SPRITE) * 2], hDC

		.ENDIF

		RET

	MostrarMenu	ENDP

; ----------------------------------------------------------------------------------------------------
; IMPLEMENTACIÓN DE FUNCIÓN [Move]
; ----------------------------------------------------------------------------------------------------

	Move	PROC hWnd:HWND

		INVOKE	GamepadMove

		; ESTABLECE EL VALOR DE keyPress A 32.. SI ES QUE LA TECLA W SE OPRIME
		CPY_FUNC	keyPress, GetAsyncKeyState, KEY_W

		.IF keyPress != 0

			.IF spriteCar.Y > 18
				SUB spriteCar.Y, VELOCITY_CAR
			.ENDIF

		.ENDIF
		
		; ESTABLECE EL VALOR DE keyPress A 32.. SI ES QUE LA TECLA D SE OPRIME
		CPY_FUNC	keyPress, GetAsyncKeyState, KEY_D

		.IF keyPress != 0

			.IF  spriteCar.X < 603

				ADD		spriteCar.X, VELOCITY_CAR
				SUB		spriteBG.X,	PADDING_BACKGROUND_VELOCITY

				SUB		spritesItems[0].X, PADDING_BACKGROUND_VELOCITY
				SUB		spritesItems[SIZEOF(SPRITE)].X, PADDING_BACKGROUND_VELOCITY
				SUB		spritesItems[SIZEOF(SPRITE) * 2].X, PADDING_BACKGROUND_VELOCITY
				SUB		spritesItems[SIZEOF(SPRITE) * 3].X, PADDING_BACKGROUND_VELOCITY
				SUB		spritesItems[SIZEOF(SPRITE) * 4].X, PADDING_BACKGROUND_VELOCITY

			.ENDIF

		.ENDIF
		
		; ESTABLECE EL VALOR DE keyPress A 32.. SI ES QUE LA TECLA S SE OPRIME
		CPY_FUNC	keyPress, GetAsyncKeyState, KEY_S

		.IF keyPress != 0

			.IF spriteCar.Y < 798
				ADD		spriteCar.Y, VELOCITY_CAR
			.ENDIF			
			
		.ENDIF
		
		; ESTABLECE EL VALOR DE keyPress A 32.. SI ES QUE LA TECLA A SE OPRIME
		CPY_FUNC	keyPress, GetAsyncKeyState, KEY_A

		.IF keyPress != 0

			.IF  spriteCar.X > 323

				SUB		spriteCar.X, VELOCITY_CAR
				ADD		spriteBG.X,	PADDING_BACKGROUND_VELOCITY

				ADD		spritesItems[0].X, PADDING_BACKGROUND_VELOCITY
				ADD		spritesItems[SIZEOF(SPRITE)].X, PADDING_BACKGROUND_VELOCITY
				ADD		spritesItems[SIZEOF(SPRITE) * 2].X, PADDING_BACKGROUND_VELOCITY
				ADD		spritesItems[SIZEOF(SPRITE) * 3].X, PADDING_BACKGROUND_VELOCITY
				ADD		spritesItems[SIZEOF(SPRITE) * 4].X, PADDING_BACKGROUND_VELOCITY

			.ENDIF

		.ENDIF

		RET

	Move	ENDP

; ----------------------------------------------------------------------------------------------------
; IMPLEMENTACIÓN DE FUNCIÓN [GamepadMove]
; ----------------------------------------------------------------------------------------------------

	GamepadMove	PROC
	
		MOV			gpIsConnected, 1
		CPY_FUNC	gpIsConnected, XInputGetState, 0, OFFSET gamePadState

		.IF	gpIsConnected != 0
			RET
		.ENDIF

		; ANALOGOS
			
		; EN X
		.IF gamePadState.Gamepad.sThumbLX == 32767 && spriteCar.X < 603 ; DER

			ADD		spriteCar.X, VELOCITY_CAR
			SUB		spriteBG.X,	PADDING_BACKGROUND_VELOCITY

			SUB		spritesItems[0].X, PADDING_BACKGROUND_VELOCITY
			SUB		spritesItems[SIZEOF(SPRITE)].X, PADDING_BACKGROUND_VELOCITY
			SUB		spritesItems[SIZEOF(SPRITE) * 2].X, PADDING_BACKGROUND_VELOCITY
			SUB		spritesItems[SIZEOF(SPRITE) * 3].X, PADDING_BACKGROUND_VELOCITY
			SUB		spritesItems[SIZEOF(SPRITE) * 4].X, PADDING_BACKGROUND_VELOCITY

		.ENDIF

		.IF gamePadState.Gamepad.sThumbLX == 32768 && spriteCar.X > 323 ; IZQ

			SUB		spriteCar.X, VELOCITY_CAR
			ADD		spriteBG.X,	PADDING_BACKGROUND_VELOCITY

			ADD		spritesItems[0].X, PADDING_BACKGROUND_VELOCITY
			ADD		spritesItems[SIZEOF(SPRITE)].X, PADDING_BACKGROUND_VELOCITY
			ADD		spritesItems[SIZEOF(SPRITE) * 2].X, PADDING_BACKGROUND_VELOCITY
			ADD		spritesItems[SIZEOF(SPRITE) * 3].X, PADDING_BACKGROUND_VELOCITY
			ADD		spritesItems[SIZEOF(SPRITE) * 4].X, PADDING_BACKGROUND_VELOCITY

		.ENDIF
			
		; EN Y
		.IF gamePadState.Gamepad.sThumbLY == 32767 && spriteCar.Y > 18 ; ARRIBA

			SUB spriteCar.Y, VELOCITY_CAR

		.ENDIF

		.IF gamePadState.Gamepad.sThumbLY == 32768 && spriteCar.Y < 798 ; ABAJO

			ADD		spriteCar.Y, VELOCITY_CAR

		.ENDIF

		; BOTONES
		.IF gamePadState.Gamepad.wButtons == XINPUT_GAMEPAD_DPAD_UP && spriteCar.Y > 18

			SUB spriteCar.Y, VELOCITY_CAR

		.ENDIF

		.IF gamePadState.Gamepad.wButtons == XINPUT_GAMEPAD_DPAD_RIGHT && spriteCar.X < 603

			ADD		spriteCar.X, VELOCITY_CAR
			SUB		spriteBG.X,	PADDING_BACKGROUND_VELOCITY

			SUB		spritesItems[0].X, PADDING_BACKGROUND_VELOCITY
			SUB		spritesItems[SIZEOF(SPRITE)].X, PADDING_BACKGROUND_VELOCITY
			SUB		spritesItems[SIZEOF(SPRITE) * 2].X, PADDING_BACKGROUND_VELOCITY
			SUB		spritesItems[SIZEOF(SPRITE) * 3].X, PADDING_BACKGROUND_VELOCITY
			SUB		spritesItems[SIZEOF(SPRITE) * 4].X, PADDING_BACKGROUND_VELOCITY

		.ENDIF

		.IF gamePadState.Gamepad.wButtons == XINPUT_GAMEPAD_DPAD_DOWN && spriteCar.Y < 798
			
			ADD		spriteCar.Y, VELOCITY_CAR

		.ENDIF

		.IF gamePadState.Gamepad.wButtons == XINPUT_GAMEPAD_DPAD_LEFT && spriteCar.X > 323

			SUB		spriteCar.X, VELOCITY_CAR
			ADD		spriteBG.X,	PADDING_BACKGROUND_VELOCITY

			ADD		spritesItems[0].X, PADDING_BACKGROUND_VELOCITY
			ADD		spritesItems[SIZEOF(SPRITE)].X, PADDING_BACKGROUND_VELOCITY
			ADD		spritesItems[SIZEOF(SPRITE) * 2].X, PADDING_BACKGROUND_VELOCITY
			ADD		spritesItems[SIZEOF(SPRITE) * 3].X, PADDING_BACKGROUND_VELOCITY
			ADD		spritesItems[SIZEOF(SPRITE) * 4].X, PADDING_BACKGROUND_VELOCITY

		.ENDIF

		RET

	GamepadMove	ENDP

; ----------------------------------------------------------------------------------------------------
; IMPLEMENTACIÓN DE FUNCIÓN [Draw]
; ----------------------------------------------------------------------------------------------------

	Draw	PROC sprite:SPRITE, hDC:HDC

		PUSH	EAX

		INVOKE	CreateCompatibleDC, hDC
		MOV		sprite.hDC, EAX

		INVOKE	SelectObject, sprite.hDC, sprite.BITMAP
		INVOKE	BitBlt, hDC, sprite.X, sprite.Y, sprite.W, sprite.H, sprite.hDC, sprite.DrawIniX, sprite.DrawIniY, SRCCOPY
			
		INVOKE	DeleteDC, sprite.hDC

		POP		EAX

		RET
	
	Draw	ENDP

; ----------------------------------------------------------------------------------------------------
; IMPLEMENTACIÓN DE FUNCIÓN [DrawTsparent] CON TRANSPARENCIA (POR DEFAULT, EL COLOR AZUL LO ELIMINA)
; ----------------------------------------------------------------------------------------------------

	DrawTsparent	PROC sprite:SPRITE, hDC:HDC

		PUSH	EAX

		INVOKE	CreateCompatibleDC, hDC
		MOV		sprite.hDC, EAX

		INVOKE	SelectObject, sprite.hDC, sprite.BITMAP
		INVOKE	TransparentBlt, hDC, sprite.X, sprite.Y, sprite.W, sprite.H, sprite.hDC, sprite.DrawIniX, sprite.DrawIniY, sprite.W, sprite.H, 255 SHL 16 + 0 SHL 8 + 0 ; BGR
			
		INVOKE	DeleteDC, sprite.hDC

		POP		EAX

		RET
	
	DrawTsparent	ENDP

; ----------------------------------------------------------------------------------------------------
; IMPLEMENTACIÓN DE FUNCIÓN [DrawLife] CON TRANSPARENCIA (POR DEFAULT, EL COLOR AZUL LO ELIMINA)
; ----------------------------------------------------------------------------------------------------

	DrawLife	PROC sprite:SPRITE, hDC:HDC, vida:DWORD

		LOCAL	total:DWORD

		; VALIDAMOS QUE NO PASE DE 100 Y NO SEA MENOS DE 0
		.IF vida > 100
			MOV	vida, 100
		.ENDIF

		.IF vida < 0
			MOV	vida, 0
		.ENDIF

		; LO QUE HACEMOS AQUI ES vida * ancho del sprite (osea sprite.W) / 100
		MOV		EAX, sprite.W
		MOV		EBX, vida
		MUL		EBX
		MOV		EBX, 100
		DIV		EBX
		MOV		total, EAX
		
		; DIBUJAMOS
		INVOKE	CreateCompatibleDC, hDC
		MOV		sprite.hDC, EAX
		INVOKE	SelectObject, sprite.hDC, sprite.BITMAP
		INVOKE	TransparentBlt, hDC, sprite.X, sprite.Y, total, sprite.H, sprite.hDC, sprite.DrawIniX, sprite.DrawIniY, sprite.W, sprite.H, 255 SHL 16 + 0 SHL 8 + 0 ; BGR
		INVOKE	DeleteDC, sprite.hDC

		RET
	
	DrawLife	ENDP

; ----------------------------------------------------------------------------------------------------
; IMPLEMENTACIÓN DE FUNCIÓN [IsColision]
; ----------------------------------------------------------------------------------------------------

	IsColision	PROC spriteItem:SPRITE

		LOCAL spriteCarPosX:DWORD
		LOCAL spriteCarPosY:DWORD

		LOCAL spriteItemPosX:DWORD
		LOCAL spriteItemPosY:DWORD
		
		COPY	spriteCarPosX, spriteCar.X
		COPY	spriteCarPosY, spriteCar.Y
		
		COPY	spriteItemPosX, spriteItem.X
		COPY	spriteItemPosY, spriteItem.Y

		; COLISION ESQUINA SUPERIOR IZQUIERDA
		; --------------------------------------------------------
		XOR EAX, EAX
		XOR EBX, EBX
		MOV	EAX, spriteCarPosX
		MOV	EBX, spriteItemPosX

		; COMPARAMOS EN X
		.IF EBX >= EAX
			ADD EAX, spriteCar.W
			.IF EBX <= EAX ; HASTA AQUI HAY COLISION EN X
				; AHORA COMPARAMOS EN Y
				XOR EAX, EAX
				XOR EBX, EBX
				MOV	EAX, spriteCarPosY
				MOV	EBX, spriteItemPosY
				.IF EBX >= EAX
					ADD EAX, spriteCar.H
					.IF EBX <= EAX
						; COLISION
						XOR EAX, EAX
						MOV	EAX, 1
						RET
					.ENDIF
				.ENDIF
			.ENDIF
		.ENDIF
		
		; COLISION ESQUINA SUPERIOR DERECHA
		; --------------------------------------------------------
		XOR EAX, EAX
		XOR EBX, EBX
		MOV	EAX, spriteCarPosX
		MOV	EBX, spriteItemPosX
		ADD EBX, spriteItem.W

		; COMPARAMOS EN X
		.IF EBX >= EAX
			ADD EAX, spriteCar.W
			.IF EBX <= EAX ; HASTA AQUI HAY COLISION EN X
				; AHORA COMPARAMOS EN Y
				XOR EAX, EAX
				XOR EBX, EBX
				MOV	EAX, spriteCarPosY
				MOV	EBX, spriteItemPosY
				.IF EBX >= EAX
					ADD EAX, spriteCar.H
					.IF EBX <= EAX
						; COLISION
						XOR EAX, EAX
						MOV	EAX, 1
						RET
					.ENDIF
				.ENDIF
			.ENDIF
		.ENDIF

		; COLISION ESQUINA INFERIOR IZQUIERDA
		; --------------------------------------------------------
		XOR EAX, EAX
		XOR EBX, EBX
		MOV	EAX, spriteCarPosX
		MOV	EBX, spriteItemPosX

		; COMPARAMOS EN X
		.IF EBX >= EAX
			ADD EAX, spriteCar.W
			.IF EBX <= EAX ; HASTA AQUI HAY COLISION EN X
				; AHORA COMPARAMOS EN Y
				XOR EAX, EAX
				XOR EBX, EBX
				MOV	EAX, spriteCarPosY
				MOV	EBX, spriteItemPosY
				ADD	EBX, spriteItem.H
				.IF EBX >= EAX
					ADD EAX, spriteCar.H
					.IF EBX <= EAX
						; COLISION
						XOR EAX, EAX
						MOV	EAX, 1
						RET
					.ENDIF
				.ENDIF
			.ENDIF
		.ENDIF

		; COLISION ESQUINA INFERIOR DERECHA
		; --------------------------------------------------------
		XOR EAX, EAX
		XOR EBX, EBX
		MOV	EAX, spriteCarPosX
		MOV	EBX, spriteItemPosX
		ADD EBX, spriteItem.W

		; COMPARAMOS EN X
		.IF EBX >= EAX
			ADD EAX, spriteCar.W
			.IF EBX <= EAX ; HASTA AQUI HAY COLISION EN X
				; AHORA COMPARAMOS EN Y
				XOR EAX, EAX
				XOR EBX, EBX
				MOV	EAX, spriteCarPosY
				MOV	EBX, spriteItemPosY
				ADD	EBX, spriteItem.H
				.IF EBX >= EAX
					ADD EAX, spriteCar.H
					.IF EBX <= EAX
						; COLISION
						XOR EAX, EAX
						MOV	EAX, 1
						RET
					.ENDIF
				.ENDIF
			.ENDIF
		.ENDIF
		
		MOV	EAX, 0
		RET
	
	IsColision	ENDP

; ----------------------------------------------------------------------------------------------------
; IMPLEMENTACIÓN DE FUNCIÓN [Colision]
; ----------------------------------------------------------------------------------------------------

	Colision	PROC itemPos:DWORD

		.IF itemPos == 0 ; ITEM [ENEMIGO -> CARRO]

			MOV vidaCarro, 0

		.ELSEIF itemPos == 1 ; ITEM [ENEMIGO -> LLANTA]

			.IF vidaCarro >= 20
				SUB vidaCarro, 20
			.ELSE
				MOV vidaCarro, 0
			.ENDIF

		.ELSEIF itemPos == 2 ; ITEM [VIDA -> KIT]

			MOV vidaCarro, 100

		.ELSEIF itemPos == 3 ; ITEM [VIDA -> LLAVE]

			.IF vidaCarro <= 90
				ADD vidaCarro, 5
			.ELSE
				MOV vidaCarro, 100
			.ENDIF

		.ELSEIF itemPos == 4 ; ITEM [VIDA -> GASOLINA]

			.IF vidaCarro <= 70
				ADD vidaCarro, 25
			.ELSE
				MOV vidaCarro, 100
			.ENDIF

		.ENDIF

		RET
	
	Colision	ENDP

; ----------------------------------------------------------------------------------------------------
; IMPLEMENTACIÓN DE FUNCIÓN [Rand]
; ----------------------------------------------------------------------------------------------------

	Rand	PROC numIzq:DWORD, numDer:DWORD

		INVOKE		nrandom, numDer

		.IF EAX < numIzq

			ADD	EAX, numIzq

			.IF EAX > numDer

				XOR EBX, EBX
				MOV	EBX, numDer
				SUB	EAX, EBX
				SUB	EBX, EAX
				MOV	EAX, EBX

			.ENDIF

		.ENDIF

		 ;ADD EAX, numIzq
;
		;.IF	EAX >= numDer
			;MOV	EAX, numDer
		;.ENDIF

		RET
	
	Rand	ENDP

; ----------------------------------------------------------------------------------------------------
; IMPLEMENTACIÓN DE FUNCIÓN [Rand]
; ----------------------------------------------------------------------------------------------------

	RandItem	PROC
			
		LOCAL	rndItem:DWORD

		.IF vidaCarro <= 45 ; SI LA VIDA ES MENOS O IGUAL QUE X GENERA ITEMS QUE DAN VIDA
						
			; RANDOM DEL 2 AL 4
			INVOKE	Rand, 2, 5
			MOV		rndItem, EAX
			COPY	drawItemPos, rndItem

		.ELSE ; SI NO, GENERA ITEMS QUE NO DAN VIDA
						
			; RANDOM DEL 0 AL 1
			INVOKE	Rand, 0, 2
			MOV		rndItem, EAX
			COPY	drawItemPos, rndItem

		.ENDIF
				
		INVOKE	Rand, POS_LEFT_STREET, POS_RIGHT_STREET
		MOV		drawItemPosIniX, EAX

		MOV		drawItem, 1

		RET
	
	RandItem	ENDP

; ----------------------------------------------------------------------------------------------------
; IMPLEMENTACIÓN DE FUNCIÓN [Reset]
; ----------------------------------------------------------------------------------------------------

	Start	PROC hWnd:HWND

		XOR EAX, EAX
		INVOKE	GetTickCount
		INVOKE	nseed, EAX
					
		INVOKE	SetTimer, hWnd, ID_TIMER_WIN, MS_TIMER_WIN, NULL
		INVOKE	SetTimer, hWnd, ID_TIMER_ITEM, MS_TIMER_ITEM, NULL
		INVOKE	SetTimer, hWnd, ID_TIMER_SEG, MS_TIMER_SEG, NULL

		INVOKE	RandItem

		MOV		startGame, 1

		RET
	
	Start	ENDP

; ----------------------------------------------------------------------------------------------------
; IMPLEMENTACIÓN DE FUNCIÓN [Reset]
; ----------------------------------------------------------------------------------------------------

	Reset	PROC hWnd:HWND

		MOV		AL, 0
		MOV		startGame, AL
		MOV		instrucciones, AL
		MOV		stateWinner, 0

		COPY	spriteBG.X, POSINI_X_BG
		COPY	spriteBG.Y, POSINI_Y_BG
		COPY	spriteCar.X, POSINI_X_CAR
		COPY	spriteCar.Y, POSINI_Y_CAR
		COPY	vidaCarro, 100

		INVOKE	KillTimer, hWnd, ID_TIMER_WIN
		INVOKE	KillTimer, hWnd, ID_TIMER_ITEM
		INVOKE	KillTimer, hWnd, ID_TIMER_SEG
		INVOKE	ResetItems

		RET
	
	Reset	ENDP

; ----------------------------------------------------------------------------------------------------
; IMPLEMENTACIÓN DE FUNCIÓN [ResetItems]
; ----------------------------------------------------------------------------------------------------

	ResetItems PROC

		MOV	drawItemPos, 0
	
		MOV	spritesItems[0].X, POSINI_X_ITEM
		MOV	spritesItems[0].Y, POSINI_Y_ITEM

		MOV	spritesItems[SIZEOF(SPRITE)].X, POSINI_X_ITEM
		MOV	spritesItems[SIZEOF(SPRITE)].Y, POSINI_Y_ITEM

		MOV	spritesItems[SIZEOF(SPRITE) * 2].X, POSINI_X_ITEM
		MOV	spritesItems[SIZEOF(SPRITE) * 2].Y, POSINI_Y_ITEM

		MOV	spritesItems[SIZEOF(SPRITE) * 3].X, POSINI_X_ITEM
		MOV	spritesItems[SIZEOF(SPRITE) * 3].Y, POSINI_Y_ITEM

		MOV	spritesItems[SIZEOF(SPRITE) * 4].X, POSINI_X_ITEM
		MOV	spritesItems[SIZEOF(SPRITE) * 4].Y, POSINI_Y_ITEM

		RET
	
	ResetItems	ENDP
	
; ----------------------------------------------------------------------------------------------------
END
; ----------------------------------------------------------------------------------------------------