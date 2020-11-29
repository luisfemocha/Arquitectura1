TITLE ChavarriaLopezMoreno-Arquitectura2020II         (practica.asm)

; Realizado por: Luis Felipe Moreno Chamorro - Diego Andrés Chavarría Riaño - Jose Fernando Lopez Ramírez
; Asignatura: Arquitectura del computador
; Semestre: 2020-2s

INCLUDE Irvine32.inc

.data
	MSN_DESPEDIDA byte "Fin compilacion, tenga un buen dia.", 0dh,0ah, 0dh,0ah,0
	MSN_SALUDO byte "Saludos.", 0dh,0ah,
	"Este proyecto ha sido realizado por: Luis Felipe Moreno Chamorro - Diego Andres Chavarria Riano - Jose Fernando Lopez Ramirez.", 0dh,0ah,
	"Asignatura: Arquitectura del computador.", 0dh,0ah,
	"Semestre: 2020-2s.",0dh,0ah,0
	MSN_OBJETIVO byte "El objetivo de este programa es clasificar las circunferencias a partir de unos datos (coordenadas) solicitadas al usuario, que en caso de corresponder a determinada clasificacion se daran valores extra para esta.",0dh,0ah,
	0dh,0ah,0

	MSN1 byte "Ingrese por favor:", 0dh, 0ah,
	"Coordenada X del centro del circulo 1: ", 0
	MSN2 byte "Coordenada Y del centro del circulo 1: ", 0
	MSN3 byte "Radio del circulo 1: ", 0
	MSN4 byte "Coordenada X del centro del circulo 2: ", 0
	MSN5 byte "Coordenada Y del centro del circulo 2: ", 0
	MSN6 byte "Radio del circulo 2: ", 0

	MSN_COORDENADAS_SEC1 byte "Coordenadas de puntos de interseccion 1", 0dh, 0ah, 0
	MSN_COORDENADAS_SEC2 byte "Coordenadas de puntos de interseccion 2", 0dh, 0ah, 0
	MSN_COORDENADAS_TAN byte "Coordenada de puntos tangentes", 0dh, 0ah, 0
	PRINT_X byte "X = ", 0
	PRINT_Y byte "Y = ", 0

	CASE1 byte "Las circunferencias son exteriores", 0dh, 0ah, 0
	CASE2 byte "Las circunferencias son secantes y se intersectan en:", 0dh, 0ah, 0
	CASE3 byte "Las circunferencias son interiores concentricas", 0dh, 0ah, 0
	CASE4 byte "Las circunferencias son coincidentes", 0dh, 0ah, 0
	CASE5 byte "Las circunferencias son tangentes exteriormente", 0dh, 0ah, 0
	CASE6 byte "Las circunferencias son tangentes interiormente", 0dh, 0ah, 0
	CASE7 byte "Las circunferencias son interiores excentricas", 0dh, 0ah, 0

	CASEERROR byte "Error. No puede ingresar radios negativos.", 0dh, 0ah, 0
	
	SPACE byte 0dh, 0ah, 0

	XI real4 0.0			; x circulo1 
	YI real4 0.0			; y circulo1 
	RI real4 0.0			; r circulo1 
	XF real4 0.0			; x circulo2 
	YF real4 0.0			; y circulo2 
	RF real4 0.0			; r circulo1 
	
	XP1 real4 ?				; X interseccion 1
	YP1 real4 ?				; Y interseccion 1
	XP2 real4 ?				; X interseccion 2
	YP2 real4 ?				; Y interseccion 2

	DISTANCIA real4 ?		
	
	RSUM real4 ?			; suma de radios
	RSUB real4 ?			; resta de radios

	A real4 ?
	H real4 ?

	AUX1 real4 ?
	AUX2 real4 ?
	AUX3 real4 ?
	XPaux real4 ?
	YPaux real4 ?
	
.code
main PROC
	mov edx, offset MSN_SALUDO
	call writestring
	mov edx, offset MSN_OBJETIVO
	call writestring

	; LECTURA DE VARIABLES INICIALES

	mov edx, offset MSN1	; mueve a edx la variable MSN1
	call writestring		; imprime MSN1

	call Readfloat			; leer desde el teclado y guardarlo en el reg ST(0)
	fstp XI					; mover eax a la variale XI

	mov edx, offset MSN2	; mueve a edx la variable MSN2
	call writestring		; imprime MSN2

	call Readfloat			; leer desde el teclado y guardarlo en el reg ST(0)
	fstp YI					; mover eax a la variale YI

	mov edx, offset MSN3	; mueve a edx la variable MSN3
	call writestring		; imprime MSN3

	call Readfloat			; leer desde el teclado y guardarlo en el reg ST(0)
	fstp RI					; mover eax a la variale RI

	; LECTURA DE VARIABLES FINALES
	
	mov edx, offset MSN4	; mueve a edx la variable MSN1
	call writestring		; imprime MSN4

	call Readfloat			; leer desde el teclado y guardarlo en el reg ST(0)
	fstp XF					; mover eax a la variale XF
	
	mov edx, offset MSN5	; mueve a edx la variable MSN5
	call writestring		; imprime MSN5

	call Readfloat			; leer desde el teclado y guardarlo en el reg ST(0)
	fstp YF					; mover eax a la variale YF

	mov edx, offset MSN6	; mueve a edx la variable MSN6
	call writestring		; imprime MSN6

	call Readfloat			; leer desde el teclado y guardarlo en el reg ST(0)
	fstp RF					; mover eax a la variale RF
	
	; COMPROBACION RADIOS NO NEGATIVOS.
	cmp RI, 0
	jl fin8
	cmp RF, 0
	jl fin8

	; CALCULAR DISTANCIA
	
	finit
	fld XF					; se ingresa XF
	fld XI					; se ingresa XI
	fSub					; resta XF-XI
	fstp DISTANCIA			; DISTANCIA = XF-XI
		
	fld DISTANCIA
	fld DISTANCIA
	fmul
	fstp AUX1				; AUX1 = (XF-XI)^2
		
	fld YF					; se ingresa YF
	fld YI					; se ingresa YI
	fSub					; resta YF-YI
	fstp DISTANCIA			; DISTANCIA = YF-YI

	fld DISTANCIA
	fld DISTANCIA
	fmul
	fstp AUX2				; AUX2 = (YF-YI)^2
		
	fld AUX1
	fld AUX2
	fadd					; (XF-XI)^2 + (YF-YI)^2
	fsqrt
	fstp DISTANCIA			; DISTANCIA = sqrt( (XF-XI)^2 + (YF-YI)^2 )
	
	finit	
	fld DISTANCIA		
	;call writefloat			; Print DISTANCIA

	mov edx, offset SPACE
	;call writestring		; Print \n

	; CALCULO DE SUMA Y RESTA DE RADIOS
	; SUMA

	finit					; inicia operacion punto flotante
	fld RI					; ingresa RI que es radio de la primera circunferencia
	fld RF					; ingresa RF que es radio de la segunda circunferencia
	fadd					; RI + RF
	fstp RSUM				; RSUM = RI + RF

	finit
	fld RSUM
	;call writefloat			; Print RSUM

	mov edx, offset SPACE
	;call writestring		; Print \n

	; RESTA

	finit					; inicia operacion punto flotante
	fld RI					; ingresa RI que es radio de la primera circunferencia
	fld RF					; ingresa RF que es radio de la segunda circunferencia
	fsub					; RI - RF
	fabs					; abs(RI - RF)
	fstp RSUB				; RSUB = abs(RI - RF)

	finit
	fld RSUB
	;call writefloat			; Print RSUB

	mov edx, offset SPACE
	;call writestring		; Print \n

	; CALCULO DE A= ( RI^2 - RF^2 + D^2 ) / 2D
	
	finit
	fld RI
	fld RI
	fmul
	fstp AUX1				; AUX1 = RI^2

	finit
	fld RF
	fld RF
	fmul
	fstp AUX2				; AUX2 = RF^2

	finit
	fld DISTANCIA
	fld DISTANCIA
	fmul
	fstp AUX3				; AUX3 = DISTANCIA^2

	finit
	fld AUX1
	fld AUX2
	fsub					;st(0) = AUX1 - AUX2
	fld AUX3
	fadd
	fstp AUX1				; AUX1 = ( RI^2 - RF^2 + D^2)

	finit 
	fld1 
	fld1
	fadd
	fld DISTANCIA
	fmul
	fstp AUX2				; AUX2= 2 * DISTANCIA

	finit
	fld AUX1
	fld AUX2
	fdiv
	fstp A					; A= ( RI^2 - RF^2 + D^2 ) / 2D

	; CALCULO DE H= sqrt(r*r - a*a)
	finit
	fld RI
	fld RI
	fmul
	fstp AUX1				; AUX1 = RI^2

	finit
	fld A
	fld A
	fmul
	fstp AUX2				; AUX2 = A^2

	finit
	fld AUX1
	fld AUX2
	fsub
	fabs
	fsqrt
	fstp H					; H = sqrt( RI^2 - A^2 )

	; INICIO DE CONDICIONALES
	cmp DISTANCIA, 0		
	jz fin3					; if (DISTANCIA == 0) vaya a fin3 --> Tienen el mismo centro

	mov eax, RSUB
	cmp DISTANCIA, eax
	jl fin7					; if (DISTANCIA < RSUB) vaya a fin7 INTERIORES EXENTRICOS
	jz fin6					; if (DISTANCIA == RSUB) vaya a fin6 TANGENCIA INTERIOR

	mov eax, RSUM
	cmp DISTANCIA, eax		
	jg fin1					; if (DISTANCIA > RSUM) vaya a fin1 NO SE CORTAN
	jl fin2					; if (DISTANCIA < RSUM) vaya a fin2 SECANTE
	jz fin5					; if (DISTANCIA == RSUM) vaya a fin5 TANGENCIA EXTERIOR
	jmp fin_code

	fin1:   ; CASE1 = son exteriores // NO SE INTERSECTAN
		mov edx, offset CASE1
		call writestring		; Print CASE1
		
		mov edx, offset SPACE
		call writestring		; Print \n
		jmp fin_code

	fin2:   ; CASE2 = son secantes
		mov edx, offset CASE2
		call writestring		; Print CASE2

		mov edx, offset SPACE
		call writestring		; Print \n

		; Paux = (CIRCULO2 - CIRCULO1)
		finit
		fld XF
		fld XI
		fsub
		fstp XPaux				; XPaux = XF - XI

		finit
		fld YF
		fld YI
		fsub
		fstp YPaux				; YPaux = YF - YI

		; Paux *= a/d
		finit
		fld A
		fld DISTANCIA
		fdiv
		fstp AUX1				; AUX1 = A/D

		finit 
		fld XPaux
		fld AUX1
		fmul
		fstp XPaux				; XPaux *= A/D

		finit 
		fld YPaux
		fld AUX1
		fmul
		fstp YPaux				; YPaux *= A/D

		; Paux += CIRCULO1 
		finit
		fld XPaux
		fld XI
		fadd
		fstp XPaux				; XPaux += XI

		finit
		fld YPaux
		fld YI
		fadd
		fstp YPaux				; YPaux += YI
		
		; XP1 = XPaux + H * (YF - YI) / D;
		finit
		fld YF
		fld YI
		fsub
		fld H
		fmul
		fld DISTANCIA
		fdiv
		fld XPaux
		fadd
		fstp XP1
		
		mov edx, offset MSN_COORDENADAS_SEC1	; mueve a edx la variable MSN_COORDENADAS_SEC
		call writestring						; imprime MSN_COORDENADAS_SEC
		
		mov edx, offset PRINT_X					; mueve a edx la variable PRINT_X
		call writestring						; imprime PRINT_X
		
		finit
		fld XP1
		call writefloat

		mov edx, offset SPACE
		call writestring						; Print \n

		; YP1 = YPaux - H * (XF - XI) / D;
		finit
		fld XF
		fld XI
		fsub
		fld H
		fmul
		fld DISTANCIA
		fdiv
		fstp AUX1								; AUX1= H * (XF - XI) / D

		finit 
		fld YPaux
		fld AUX1
		fsub
		fstp YP1
		
		mov edx, offset PRINT_Y					; mueve a edx la variable PRINT_Y
		call writestring						; imprime PRINT_Y

		finit
		fld YP1
		call writefloat

		mov edx, offset SPACE
		call writestring		; Print \n

		mov edx, offset SPACE
		call writestring		; Print \n

		; XP2 = XPaux - H * (YF - YI) / D;
		finit
		fld YF
		fld YI
		fsub
		fld H
		fmul
		fld DISTANCIA
		fdiv
		fstp AUX1

		finit
		fld XPaux
		fld AUX1
		fsub
		fstp XP2
		
		mov edx, offset MSN_COORDENADAS_SEC2	; mueve a edx la variable MSN_COORDENADAS_SEC
		call writestring						; imprime MSN_COORDENADAS_SEC
				
		mov edx, offset PRINT_X					; mueve a edx la variable PRINT_X
		call writestring						; imprime PRINT_X
		
		finit
		fld XP2
		call writefloat

		mov edx, offset SPACE
		call writestring		; Print \n

		; YP2 = YPaux + H * (XF - XI) / D;
		finit
		fld XF
		fld XI
		fsub
		fld H
		fmul
		fld DISTANCIA
		fdiv
		fld YPaux
		fadd
		fstp YP2
		
		mov edx, offset PRINT_Y					; mueve a edx la variable PRINT_Y
		call writestring						; imprime PRINT_Y
		
		finit
		fld YP2
		call writefloat

		mov edx, offset SPACE
		call writestring		; Print \n

		mov edx, offset SPACE
		call writestring		; Print \n
	
		jmp fin_code

	jmp fin_code

	fin3 :  ; CASE3 = son interiores concentricas
		mov eax, RI
		cmp RF, eax
		jz fin4					; if (RI==RF) vaya a fin4 --> Radios iguales 

		mov edx, offset CASE3
		call writestring		; Print CASE3
		
		mov edx, offset SPACE
		call writestring		; Print \n
		jmp fin_code

	fin4:  ; CASE4 = son coincidentes
		mov edx, offset CASE4
		call writestring		; Print CASE4
		
		mov edx, offset SPACE
		call writestring		; Print \n
		jmp fin_code

	fin5:  ; CASE5 byte "Las circunferencias son tangentes exteriormente", 0dh, 0ah, 0
		;XP1 = XI+a*(XF-XI)/d
		finit
		fld XF
		fld XI
		fsub
		fld A
		fmul
		fld DISTANCIA
		fdiv
		fld XI
		fadd
		fstp XP1

		;YP1 = YI+a*(YF-YI)/d
		finit
		fld YF
		fld YI
		fsub
		fld A
		fmul
		fld DISTANCIA
		fdiv
		fld YI
		fadd
		fstp YP1

		mov edx, offset CASE5
		call writestring						; Print CASE5
		
		mov edx, offset MSN_COORDENADAS_TAN		; mueve a edx la variable tangencial
		call writestring						; imprime

		mov edx, offset PRINT_X					; mueve a edx la variable PRINT_X
		call writestring						; imprime PRINT_X
		
		finit
		fld XP1
		call writefloat

		mov edx, offset SPACE
		call writestring						; Print \n
		
		mov edx, offset PRINT_Y					; mueve a edx la variable PRINT_Y
		call writestring						; imprime PRINT_Y
		
		finit
		fld YP1
		call writefloat

		mov edx, offset SPACE
		call writestring						; Print \n

		jmp fin_code

	fin6:  ; CASE6 byte "Las circunferencias son tangentes interiormente", 0dh, 0ah, 0
		;XP1 = XI+a*(XF-XI)/d
		finit
		fld XF
		fld XI
		fsub
		fld A
		fmul
		fld DISTANCIA
		fdiv
		fld XI
		fadd
		fstp XP1

		;YP1 = YI+a*(YF-YI)/d
		finit
		fld YF
		fld YI
		fsub
		fld A
		fmul
		fld DISTANCIA
		fdiv
		fld YI
		fadd
		fstp YP1

		mov edx, offset CASE6
		call writestring						; Print CASE6
		
		mov edx, offset MSN_COORDENADAS_TAN		; mueve a edx la variable tangencial
		call writestring						; imprime 
		
		mov edx, offset PRINT_X					; mueve a edx la variable PRINT_X
		call writestring						; imprime PRINT_X
		
		finit
		fld XP1
		call writefloat

		mov edx, offset SPACE
		call writestring						; Print \n
		
		mov edx, offset PRINT_Y					; mueve a edx la variable PRINT_Y
		call writestring						; imprime PRINT_Y
		
		finit
		fld YP1
		call writefloat

		mov edx, offset SPACE
		call writestring						; Print \n

		jmp fin_code

	; CASE7 = INTERIORES EXCENTRICOS
	fin7: 
		mov edx, offset CASE7
		call writestring		; Print CASE7
		
		mov edx, offset SPACE
		call writestring		; Print \n

		jmp fin_code

	; CASEERROR byte "Error. No puede ingresar radios negativos.", 0dh, 0ah, 0
	fin8: 
		mov edx, offset CASEERROR
		call writestring		; Print ERROR
		
		mov edx, offset SPACE
		call writestring		; Print \n

	fin_code:
		mov edx, offset MSN_DESPEDIDA
		call writestring

	exit
main ENDP
END main