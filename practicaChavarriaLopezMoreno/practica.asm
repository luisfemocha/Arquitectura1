TITLE ChavarriaLopezMoreno-Arquitectura2020II         (practica.asm)

; Realizado por: Luis Felipe Moreno Chamorro - Diego Andrés Chavarría Riaño - Jose Fernando Lopez Ramírez
; Asignatura: Arquitectura del computador
; Semestre: 2020-2s

INCLUDE Irvine32.inc

.data

	MSN_SALUDO byte "Hola", 0dh,0ah,
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

	CASE1 byte "Las circunferencias son exteriores", 0dh, 0ah, 0
	CASE2 byte "Las circunferencias son secantes", 0dh, 0ah, 0
	CASE3 byte "Las circunferencias son interiores concentricas", 0dh, 0ah, 0
	CASE4 byte "Las circunferencias son coincidentes", 0dh, 0ah, 0
	CASE5 byte "Las circunferencias son interiores excentricas", 0dh, 0ah, 0
	CASE6 byte "Las circunferencias son tangentes interiormente", 0dh, 0ah, 0
	CASE7 byte "Las circunferencias son tangentes exteriormente", 0dh, 0ah, 0
	

	SPACE byte 0dh, 0ah, 0

	XI real4 0.0 
	YI real4 0.0
	RI real4 0.0
	XF real4 0.0
	YF real4 0.0
	RF real4 0.0
	DISTANCIA real4 ?
	RSUM real4 ?
	RSUB real4 ?

	AUX1 real4 ?
	AUX2 real4 ?
	

.code
main PROC

	mov edx, offset MSN_SALUDO
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
	call writefloat			; Print DISTANCIA

	mov edx, offset SPACE
	call writestring		; Print \n

	; CALCULO DE SUMA Y RESTA DE RADIOS
	; SUMA

	finit					; inicia operacion punto flotante
	fld RI					; ingresa RI que es radio de la primera circunferencia
	fld RF					; ingresa RF que es radio de la segunda circunferencia
	fadd					; RI + RF
	fstp RSUM				; RSUM = RI + RF

	finit
	fld RSUM
	call writefloat			; Print RSUM

	mov edx, offset SPACE
	call writestring		; Print \n

	; RESTA

	finit					; inicia operacion punto flotante
	fld RI					; ingresa RI que es radio de la primera circunferencia
	fld RF					; ingresa RF que es radio de la segunda circunferencia
	fsub					; RI - RF
	fabs					; abs(RI - RF)
	fstp RSUB				; RSUB = abs(RI - RF)

	finit
	fld RSUB
	call writefloat			; Print RSUB

	mov edx, offset SPACE
	call writestring		; Print \n

	; INICIO DE CONDICIONALES

	cmp DISTANCIA, 0		
	jz fin3					; if (DISTANCIA == 0) vaya a fin3 --> Tienen el mismo centro

	mov eax, RSUM
	cmp DISTANCIA, eax		
	jg fin1					; if (DISTANCIA > RSUM) vaya a fin1
	jl fin2					; if (DISTANCIA < RSUM) vaya a fin2
	jz fin5					; if (DISTANCIA == RSUM) vaya a fin5
	jmp fin_code



	; CASE1 = son exteriores
	
	fin1:
		mov edx, offset CASE1
		call writestring		; Print CASE1
		
		mov edx, offset SPACE
		call writestring		; Print \n
		jmp fin_code

	; CASE2 = son secantes

	fin2:

	; Falta escribir codigo de secante
	
	jmp fin_code

	; CASE3 = son interiores concentricas

	fin3 :
		
		mov eax, RI
		cmp RF, eax
		jz fin4					; if (RI==RF) vaya a fin4 --> Radios iguales 

		mov edx, offset CASE3
		call writestring		; Print CASE3
		
		mov edx, offset SPACE
		call writestring		; Print \n
		jmp fin_code

	; CASE4 = son coincidentes

	fin4:

		mov edx, offset CASE4
		call writestring		; Print CASE4
		
		mov edx, offset SPACE
		call writestring		; Print \n
		jmp fin_code

	; CASE5 = por definir

	fin5:
		; falta codigo fin5
		jmp fin_code

	fin_code:

	exit
main ENDP
END main