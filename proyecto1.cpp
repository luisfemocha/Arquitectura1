#include <iostream>

int main(){
    float x1, xs,  y1, tol, it; // 4 bytes //
    std::cout << "X1: ";
    std::cin >> x1;
    std::cout << "Xs: ";
    std::cin >> xs;
    std::cout << "Tolerancia\n";
    std::cin >> tol;
    std::cout << "Iteraciones\n";
    std::cin >> it;

    float aux, aux2, aux3=2, xm, ym, ys, e;
    float resultado= NULL;
    int x;
    // 0.2699 es la unica raiz que tiene en los reales
    _asm { 
        mov eax, x1
        mov aux, eax                ; aux = x1
        mov ecx, 0                  ; ecx = 0
        
        funcion:                    ; aux = e ^ x + ln(x)
            finit                   ; se abre el punto flotante
            fld aux                 ; se ingresa el float aux
            fldl2e                  ; se ingresa el log2(e)
            fmulp st(1), st(0)      ; st0 = x * log2(e) = tmp1
            fld1                    ; se ingresa 1
            fscale                  ; //                                st0 = 2 ^ int(tmp1), st1 = tmp1
            fxch                    ; intercambia el tope por el segundo
            fld1                    ; se ingresa 1
            fxch                    ; intercambia el tope por el segundo //                                st0 = tmp1, st1 = 1, st2 = 2 ^ int(tmp1)
            fprem                   ; //                                st0 = fract(tmp1) = tmp2
            f2xm1                   ; //                                st0 = 2 ^ (tmp2)-1 = tmp3
            faddp st(1), st(0)      ; //                                st0 = tmp3 + 1, st1 = 2 ^ int(tmp1)
            fmulp st(1), st(0)      ; //                                st0 = 2 ^ int(tmp1) + 2 ^ fract(tmp1) = 2 ^ (x * log2(e))
            fstp aux2               ; aux2=e^x se guarda lo del punto flotante en el float aux2

            fldln2                  ; se ingresa ln(2)
            fld aux                 ; se ingresa aux
            fyl2x                   ; //                                se hace y*log2(x)
            fld aux2                ; se ingresa aux2
            fadd                    ; se suma lo de la pila
            fstp aux                ; aux= e^x + ln(x)

            cmp ecx, 1              
            jl retFunc1             ; para volver la primera vez que se hace la funcion
            jz retFunc2             ; para volver la segunda vez que se hace la funcion

            cmp ecx, 2
            jz retFunc3             ; para volver la enesima vez que se hace la funcion
            jg retFunc4             ; para volver a la ultima vez que se hace la funcion (switch case x==2 => se sale del while por tolerancia)

            ; ACA TERMINA LA FUNCION e^x + ln(x), lo demas es parte del main

        retFunc1:                   ; se pone un checkpoint para volver al calcular y1 o hacer la funcion por primera vez
            mov eax, aux
            mov y1, eax             ; y1 = aux

            finit
            fld y1
            fabs
            fstp aux2               ; aux2 = |y1|
            mov eax, tol
            cmp aux2, eax           ; if ( |y1| <= tolerancia) //la resta debe dar menor que 0, lo que se busca encontrar es si y1=0 o si esta aproximado a 0 respetando la tolerancia.
            jg finComp1
            mov eax, x1             
            mov resultado, eax      ; resultado = x1
            jmp terminarCodigo      ; return
            finComp1:               ; else continue
            mov eax, xs
            mov aux, eax            ; aux = xs
            inc ecx                 ; ecx++ // esto se hace para saber si se esta haciendo para y1, ys o ym
            jmp funcion
            
        retFunc2:                   ; se pone un checkpoint para volver al calcular ys o hacer la funcion por segunda vez
            mov eax, aux
            mov ys, eax             ; ys = aux

            finit
            fld ys
            fabs
            fstp aux2               ; aux2 = |ys|
            mov eax, tol
            cmp ys, eax             ; if (ys  <= tol) // la resta debe ser menor o igual a 0
            jg finComp2
            mov eax, xs
            mov resultado, eax      ; resultado = xs
            jmp terminarCodigo      ; return
            finComp2:               ; else continue
            
            finit
            fld y1
            fld ys
            fmul
            fstp aux
            cmp aux, 0              ; if (y1*ys < 0) siga con el codigo
            jl finComp3             ; else no tiene raiz entonces termine el codigo.
            
            jmp terminarCodigo
            finComp3:

            inc ecx                 ; ecx++ para calcular ym

        mientras1:                  ; X1 izquierda, XM punto medio, XS derecha / swift

            finit
            fld x1
            fld xs
            fadd
            fld aux3
            fdiv
            fstp xm                 ; xm = (x1 + xs) / 2 PUNTO MEDIO

            mov eax, xm
            mov aux, eax            ; aux = xm
            jmp funcion             ; se busca y en el punto medio.

            retFunc3 :              ; se pone un breakpoint para volver al realizar la funcion para calcular ym
            mov eax, aux
            mov ym, eax             ; ym = f(xm) <- y en el punto medio.

            cmp ym, 0               ; if ym==0
            jz finMientras1         ; break HAY QUE CAPTURAR XM

            finit
            fld y1
            fld ym
            fmul
            fstp aux2
            cmp aux2, 0             ; if (y1 * ym) < 0
            jg finComp4             ; else, vaya a finComp4 y1* ym > 0

            mov eax, xm
            mov xs, eax             ; xs = xm EXTREMO DERECHO SE MUEVE AL PUNTO MEDIO, EXTREMO IZQUIERDO SE DEJA FIJO

            mov eax, ym
            mov ys, eax             ; ys = ym Y EN EL EXTREMO DERECHO ES YM

            jmp finComp5            ; finally go
            finComp4:               ; else

            mov eax, xm
            mov x1, eax             ; x1 = xm EXTREMO IZQUIERDO SE MUEVE AL PUNTO MEDIO, EXTREMO DERECHO SE DEJA FIJO

            mov eax, ym
            mov y1, eax             ; y1 = ym Y EN EL EXTREMO IZQUIERDO ES YM

            finComp5:               ; FIN DE LOS IFS.

            finit
            fld xs
            fld x1
            fsub
            fabs
            fstp e                  ; e = |xs - x1| (distancia entre los dos extremos).
            mov eax, tol
            cmp e, eax              ; if (e - tol < 0)
            jge finComp6            ; else: siga el while

            jmp finMientras2        ; si la distancia entre los dos puntos es menor que la tolerancia, se sale del while.

            finComp6:               ; fin del if tolerancia

            dec it                  ; it--
            cmp it, 0               ; if (it - 0)
            jg mientras1            ; if (it > 0 ) : redo
            jz finMientras3         ; if (it == 0) se terminan las iteraciones, se sale del while y se captura en el fin3
            
            ; HASTA ACA VA EL MIENTRAS
        
    finMientras1:                   ; cuando ym==0
        mov eax, 1
        mov x, eax                  ; switch case x==1, tiene raiz.

        mov eax, ym
        mov resultado, eax          ; resultado = ym

        jmp terminarCodigo

    finMientras2:                   ; cuando e<tol
        mov eax, 2
        mov x, eax                  ; switch case x==2, tiene raiz con error.

        inc ecx                     ; ecx++ para que vuelva la funcion a este punto.
        
        finit
        fld x1
        fld xs
        fadd
        fld aux3
        fdiv
        fstp xm                     ; xm = (x1 + xs) / 2 PUNTO MEDIO

        mov eax, xm
        mov aux, eax                ; aux = xm
        jmp funcion                 ; se busca y en el punto medio.

        retFunc4:                   ; se pone un breakpoint para volver al realizar la funcion para calcular ym
        mov eax, aux
        mov resultado, eax          ; ym = f(xm) < -y en el punto medio.

        jmp terminarCodigo

    finMientras3:                   ; cuando se terminan las iteraciones
        mov eax, 3
        mov x, eax                  ; switch case x==3, no tiene raiz.

        terminarCodigo:
    }
    std::cout << "Y1: " << y1 << '\n';
    std::cout << "Ys: " << ys << '\n';
    if (resultado == NULL) std::cout << "No hay raices.";
    
    
    
    else {
        switch (x) {
            case 1: // x==1 tiene raiz
                std::cout << "tiene raiz en: " << resultado << '\n';
                break;

            case 2: // x==2 tiene raiz en tal pero por tolerancia
                std::cout << "tiene raiz en: " << xm << '\n';
                std::cout << "con un error de: " << e << '\n';
                std::cout << "ym: " << ym << '\n';
                break;

            case 3:// x==3 no tiene raiz y se salio por la cantidad de iteraciones.
                std::cout << "No se encontro raiz con la cantidad de iteraciones y tolerancia.";
                break;

            default:
                std::cout << "No hay una raiz entre el intervalo dado. [x1,xs]";
                break;
        }
    }
}


/*
ln(x1)
finit
        fldln2
        fld x1
        fyl2x
        fstp y1*/

/*
log2(x)
finit
        finit
        fld1
        fld x1
        fyl2x
        fstp y1
        */

/*
* 
* 2^x - 1 entre [-1, 1]
        finit
        fld x1
        f2xm1
        fstp y1*/

/*; mov ecx, x1
        jmp fin_exponente
        exponente :                 ; while (ecx > 0)
            cmp ecx, 0              ; if (ecx <= 0)
            jle fin_exponente       ; then break while

            dec ecx                 ; ecx--

            finit
            fld e
            fld aux
            fmul
            fstp aux                ; aux *= e

            jmp exponente           ; redo
        fin_exponente :             ; end while

        

        ;mov ebx, aux                ; ebx= e^x1
        ;mov y1, ebx                 ; y1 = e^x1 //+ ln(x)*/
