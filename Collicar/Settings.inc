.386
.model flat, stdcall
.stack 10448576
option casemap:none

INCLUDE Herramientas\masm32\include\windows.inc
INCLUDE Herramientas\masm32\include\kernel32.inc
INCLUDE Herramientas\masm32\include\user32.inc
INCLUDE Herramientas\masm32\include\gdi32.inc
INCLUDE Herramientas\masm32\include\masm32rt.inc ; ESTE CONTIENE UNA MACRO PARA UN MESSAGEBOX MAS HD
INCLUDE Herramientas\masm32\include\msimg32.inc

INCLUDELIB Herramientas\masm32\lib\kernel32.lib
INCLUDELIB Herramientas\masm32\lib\user32.lib
INCLUDELIB Herramientas\masm32\lib\Gdi32.lib
INCLUDELIB Herramientas\masm32\lib\msimg32.lib
INCLUDELIB Herramientas\masm32\lib\XInput.lib