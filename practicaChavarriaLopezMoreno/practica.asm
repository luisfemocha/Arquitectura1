TITLE ChavarriaLopezMoreno-Arquitectura2020II         (practica.asm)

; Realizado por: Luis Felipe Moreno Chamorro - Diego Andrés Chavarría Riaño - Jose Fernando Lopez Ramírez
; Asignatura: Arquitectura del computador
; Semestre: 2020-2s

INCLUDE Irvine32.inc

.data

	MSN byte "Hola", 0dh,0ah,
	"Este proyecto ha sido realizado por: Luis Felipe Moreno Chamorro - Diego Andres Chavarria Riano - Jose Fernando Lopez Ramirez", 0dh,0ah,
		"Asignatura: Arquitectura del computador", 0dh,0ah,
		"Semestre: 2020-2s",0dh,0ah,
		"El objetivo de este programa es clasificar las circunferencias a partir de unos datos (coordenadas) solicitadas al usuario, que en caso de corresponder a determinada clasificacion se daran valores eetra para esta",0dh,0ah,
		0dh,0ah, 0dh,0ah,0

	MSN1 byte "ingrese Valor XI", 0dh, 0ah, 0
	MSN2 byte "ingrese Valor YI", 0dh, 0ah, 0
	MSN3 byte "ingrese Valor RI", 0dh, 0ah, 0
	MSN4 byte "ingrese Valor XF", 0dh, 0ah, 0
	MSN5 byte "ingrese Valor YF", 0dh, 0ah, 0
	MSN6 byte "ingrese Valor RF", 0dh, 0ah, 0

	XI real4 0.0 
	YI real4 0.0
	RI real4 0.0
	XF real4 0.0
	YF real4 0.0
	RF real4 0.0
	

.code
main PROC

	mov edx, offset MSN
	call writestring

	; lectura de variables iniciales

	mov edx, offset MSN1	; mueve a edx la variable MSN1
	call writestring		; imprime MSN1

	call ReadInt			; leer desde el teclado u entero y guardarlo en el reg EAX
	mov XI, eax				; mover eax a la variale XI
	
	mov edx, offset MSN2	; mueve a edx la variable MSN2
	call writestring		; imprime MSN2

	call ReadInt			; leer desde el teclado u entero y guardarlo en el reg EAX
	mov YI, eax				; mover eax a la variale YI

	mov edx, offset MSN3	; mueve a edx la variable MSN3
	call writestring		; imprime MSN3

	call ReadInt			; leer desde el teclado u entero y guardarlo en el reg EAX
	mov RI, eax				; mover eax a la variale RI

	; lectura de varibles finales
	
	mov edx, offset MSN4	; mueve a edx la variable MSN1
	call writestring		; imprime MSN4

	call ReadInt			; leer desde el teclado u entero y guardarlo en el reg EAX
	mov XF, eax				; mover eax a la variale XF
	
	mov edx, offset MSN5	; mueve a edx la variable MSN5
	call writestring		; imprime MSN5

	call ReadInt			; leer desde el teclado u entero y guardarlo en el reg EAX
	mov YF, eax				; mover eax a la variale YF

	mov edx, offset MSN6	; mueve a edx la variable MSN6
	call writestring		; imprime MSN6

	call ReadInt			; leer desde el teclado u entero y guardarlo en el reg EAX
	mov RF, eax				; mover eax a la variale RF


	exit
main ENDP
END main