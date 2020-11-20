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
		"El objetivo de este programa es clasificar las circunferencias a partir de unos datos (coordenadas) solicitadas al usuario, que en caso de corresponder a determinada clasificacion se daran valores letra para esta",0dh,0ah,
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
	DISTANCIA real4 ?

	AUX1 real4 ?
	AUX2 real4 ?
	inicio DWORD 0
	

.code
main PROC

	mov edx, offset MSN
	call writestring

	; lectura de variables iniciales

	mov edx, offset MSN1	; mueve a edx la variable MSN1
	call writestring		; imprime MSN1

	call Readfloat			; leer desde el teclado y guardarlo en el reg EAX
	fstp XI					; mover eax a la variale XI

	mov edx, offset MSN2	; mueve a edx la variable MSN2
	call writestring		; imprime MSN2

	call Readfloat			; leer desde el teclado y guardarlo en el reg EAX
	fstp YI					; mover eax a la variale YI

	mov edx, offset MSN3	; mueve a edx la variable MSN3
	call writestring		; imprime MSN3

	call Readfloat			; leer desde el teclado y guardarlo en el reg EAX
	fstp RI					; mover eax a la variale RI

	; lectura de varibles finales
	
	mov edx, offset MSN4	; mueve a edx la variable MSN1
	call writestring		; imprime MSN4

	call Readfloat			; leer desde el teclado y guardarlo en el reg EAX
	fstp XF					; mover eax a la variale XF
	
	mov edx, offset MSN5	; mueve a edx la variable MSN5
	call writestring		; imprime MSN5

	call Readfloat			; leer desde el teclado y guardarlo en el reg EAX
	fstp YF					; mover eax a la variale YF

	mov edx, offset MSN6	; mueve a edx la variable MSN6
	call writestring		; imprime MSN6

	call Readfloat			; leer desde el teclado y guardarlo en el reg EAX
	fstp RF					; mover eax a la variale RF

		
; CREAR FUNCION DISTANCIA
	

	dist:
		finit
		fld XF				; se ingresa XF
		fld XI				; se ingresa XI
		fSub				; resta XF-XI

		fstp DISTANCIA		; DISTANCIA = XF-XI

		fld DISTANCIA
		fld DISTANCIA
		fmul
		fstp AUX1			; AUX1 = (XF-XI)^2

		fld YF				; se ingresa YF
		fld YI				; se ingresa YI
		fSub				; resta YF-YI
		fstp DISTANCIA		; DISTANCIA = YF-YI

		fld DISTANCIA
		fld DISTANCIA
		fmul
		fstp AUX2			; AUX2 = (YF-YI)^2

		fld AUX1
		fld AUX2
		fadd				; (XF-XI)^2 + (YF-YI)^2
		fsqrt
		fstp DISTANCIA		; DISTANCIA = sqrt( (XF-XI)^2 + (YF-YI)^2 )
		
		finit
		fld DISTANCIA
		call writefloat

	exit
main ENDP
END main