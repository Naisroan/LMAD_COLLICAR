; ----------------------------------------------------------------------------------------------------
; CONSTANTES
; ----------------------------------------------------------------------------------------------------

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ID DEL DIALOGO
; ----------------------------------------------------------------------------------------------------
	DLG_MAIN	EQU 101
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; TAMAÑOS DEL DIALOGO
; ----------------------------------------------------------------------------------------------------
	DLG_ANCHO	EQU 1000
	DLG_ALTO	EQU 900
	WND_ANCHO	EQU 1920
	WND_ALTO	EQU 1080

	POS_X_WND	EQU (WND_ANCHO / 2) - (DLG_ANCHO / 2)
	POS_Y_WND	EQU (WND_ALTO / 2) - (DLG_ALTO / 2)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ID DEL TIMER
; ----------------------------------------------------------------------------------------------------
	ID_TIMER_RENDER	EQU 84637
	ID_TIMER_BG		EQU 84638
	ID_TIMER_MENU	EQU 84639
	ID_TIMER_WIN	EQU 84640
	ID_TIMER_ITEM	EQU 84641
	ID_TIMER_SEG	EQU 84642

	MS_TIMER_RENDER	EQU	50
	MS_TIMER_BG		EQU 1
	MS_TIMER_MENU	EQU 400
	MS_TIMER_WIN	EQU 30000
	MS_TIMER_ITEM	EQU 800
	MS_TIMER_SEG	EQU 200 ; PIERDE 1 DE VIDA CADA X SEGUNDOS
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ID DE LAS IMAGENES / TAMAÑOS / POSICIONES
; ----------------------------------------------------------------------------------------------------
	ID_BITMAP_BACKGROUND	EQU 104
	ID_BITMAP_CAR			EQU 106
	ID_BITMAP_MENU_01		EQU 110
	ID_BITMAP_MENU_02		EQU 111
	ID_ICON					EQU 112
	ID_BITMAP_LIFEBAR		EQU 114
	ID_BITMAP_LIFE			EQU 115
	ID_BITMAP_WINNER_01		EQU 116
	ID_BITMAP_WINNER_02		EQU 117
	ID_BITMAP_INFO			EQU 118
	ID_BITMAP_INSTRUCCION	EQU 119

	BACKGROUND_W			EQU 1200
	BACKGROUND_H			EQU 1800
	CAR_W					EQU 74
	CAR_H					EQU 102
	LIFEBAR_W				EQU 320
	LIFEBAR_H				EQU 70
	LIFE_W					EQU 310
	LIFE_H					EQU 30
	INFO_W					EQU 206
	INFO_H					EQU 212

	POS_LEFT_STREET			EQU 323
	POS_RIGHT_STREET		EQU 600
	POSINI_X_CAR			EQU (DLG_ANCHO / 2) - (CAR_W / 2)
	POSINI_Y_CAR			EQU DLG_ALTO - CAR_H - 40
	POSINI_X_BG				EQU -100 ; BACKGROUND
	POSINI_Y_BG				EQU -900 ; BACKGROUND
	POSINI_X_LB				EQU 15
	POSINI_Y_LB				EQU 15
	POSINI_X_INFO			EQU 60
	POSINI_Y_INFO			EQU 650
	POSINI_X_ITEM			EQU 500
	POSINI_Y_ITEM			EQU -100

	SIZE_STRUCT_SPRITE		EQU SIZEOF(SPRITE)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; CODIGOS DE TECLAS
; ----------------------------------------------------------------------------------------------------
	KEY_W		EQU 'W'
	KEY_A		EQU 'A'
	KEY_S		EQU 'S'
	KEY_D		EQU 'D'
	KEY_ENTER	EQU 13
	KEY_ESCAPE	EQU 27
	KEY_SPACE	EQU 32
	KEY_SUPR	EQU 46
	KEY_BACKSP	EQU 08
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; CONSTATES DE JUEGO
; ----------------------------------------------------------------------------------------------------
	VELOCITY_BACKGROUND				EQU 60
	PADDING_BACKGROUND_VELOCITY		EQU 2
	VELOCITY_CAR					EQU 20
	VELOCITY_ITEM					EQU 80

	VIDA_ITEM_KIT					EQU 100
	VIDA_ITEM_GAS					EQU 25
	VIDA_ITEM_LLAVE					EQU 5
	VIDA_ITEM_CARRO					EQU 100
	VIDA_ITEM_LLANTA				EQU 20
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; CONSTATES PARA CONTROL DE XBOX
; ----------------------------------------------------------------------------------------------------
	XINPUT_GAMEPAD_DPAD_UP			equ 0001h
	XINPUT_GAMEPAD_DPAD_DOWN		equ	0002h
	XINPUT_GAMEPAD_DPAD_LEFT		equ	0004h
	XINPUT_GAMEPAD_DPAD_RIGHT		equ	0008h
	XINPUT_GAMEPAD_START			equ	0010h
	XINPUT_GAMEPAD_BACK				equ	0020h
	XINPUT_GAMEPAD_LEFT_THUMB		equ	0040h
	XINPUT_GAMEPAD_RIGHT_THUMB		equ	0080h
	XINPUT_GAMEPAD_LEFT_SHOULDER	equ	0100h
	XINPUT_GAMEPAD_RIGHT_SHOULDER	equ	0200h
	XINPUT_GAMEPAD_A				equ 1000h
	XINPUT_GAMEPAD_B				equ	2000h
	XINPUT_GAMEPAD_X				equ	4000h
	XINPUT_GAMEPAD_Y				equ	8000h
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>