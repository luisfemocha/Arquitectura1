#include <iostream>

int main(){
    float x1, xs,  y1, tol, it; // 4 bytes //
    std::cout << "NO SE PUEDEN INGRESAR NUMEROS NEGATIVOS. \n";
    std::cout << "X1: ";
    std::cin >> x1;
    std::cout << "Xs: ";
    std::cin >> xs;
    std::cout << "Tolerancia: ";
    std::cin >> tol;
    std::cout << "Iteraciones (entero): ";
    std::cin >> it;

    float aux, aux2, aux3=2, xm, ym, ys, e;
    int x; // SWITCH CASE.
    // 0.2699 es la unica raiz que tiene en los reales
    _asm {
        mov eax, 0
        cmp x1, eax                 ; if (x1 < 0) then...
        jl finMientras4             ; TERMINA EL CODIGO Y HACE UN CATCH DEL ERROR 'INGRESO NUMEROS NEGATIVOS'.

        mov eax, 0
        cmp xs, eax                 ; if (xs < 0) then...
        jl finMientras4             ; TERMINA EL CODIGO Y HACE UN CATCH DEL ERROR 'INGRESO NUMEROS NEGATIVOS'.

                                    ; else: DESPUES DE HACER EL CATCH DE NUMEROS NEGATIVOS, SIGUE CON EL CODIGO...
        mov eax, x1
        mov aux, eax                ; aux = x1
        mov ecx, 0                  ; ecx = 0
        
        funcion:                    ; aux = e^x + ln(x) (POR DEFECTO ENTRA ACÁ LA PRIMERA VEZ PARA CALCULAR f(x1)
            finit                   ; se inicializa el punto flotante
            fld aux                 ; se ingresa el float aux
            fldl2e                  ; se ingresa el log2(e)
            fmulp st(1), st(0)      ; st(0) = aux * log2(e) = tmp1
            fld1                    ; se ingresa 1
            fscale                  ; st(0) = 2 ^ int(tmp1), st(1) = tmp1
            fxch                    ; intercambia el tope por el ultimo | st(0)= tmp1 <=> st(1)= 2 ^ int(tmp1)
            fld1                    ; se ingresa 1
            fxch                    ; intercambia el tope por el ultimo | st(0)= 1 <=> st(1)= tmp1                               st0 = tmp1, st1 = 1, st2 = 2 ^ int(tmp1)
            fprem                   ; st(0) = st(0) modulo st(1) || modulo(tmp1) = tmp2
            f2xm1                   ; 2^st(n) - 1 || st(0) = 2 ^ (tmp2)-1 = tmp3
            faddp st(1), st(0)      ; st(0)+=st(1) || st(0) = tmp3 + 1, st(1) = 2 ^ int(tmp1)
            fmulp st(1), st(0)      ; st(0)*=st(1) || st(0) = 2 ^ int(tmp1) + 2 ^ fract(tmp1) = 2 ^ (x * log2(e))
            fstp aux2               ; aux2=e^x || se guarda lo del punto flotante en el float aux2

            fldln2                  ; se ingresa ln(2)
            fld aux                 ; se ingresa aux
            fyl2x                   ; temp1= ln(2) * log2(aux) || ST(1)* log_2(ST(0)                                se hace y*log2(x)
            fld aux2                ; se ingresa aux2
            fadd                    ; temp2= temp1 + aux2 se suma lo de la pila
            fstp aux                ; aux= e^x + ln(x)

            cmp ecx, 1              
            jl retFunc1             ; para volver la primera vez que se hace la funcion
            jz retFunc2             ; para volver la segunda vez que se hace la funcion
            jg retFunc3             ; para volver la enesima vez que se hace la funcion          

            ; ACA TERMINA LA FUNCION e^x + ln(x), lo demas es parte del main

        retFunc1:                   ; se pone un checkpoint para volver al calcular y1 o f(x1) | hacer la funcion por primera vez
            mov eax, aux
            mov y1, eax             ; y1 = aux = e^x1 + ln(x1)

            finit
            fld y1
            fabs
            fstp aux2               ; aux2 = |y1|
            mov eax, tol
            cmp aux2, eax           ; if ( |y1| <= tolerancia) // si el valor absoluto de y1 es menor que la tolerancia, se puede decir que tiene una raiz en x1.
            jg finComp1
            
                mov eax, 1
                mov x, eax          ; switch case x==1 => TIENE RAIZ EN XM
                mov eax, x1             
                mov xm, eax         ; xm = x1
                jmp terminarCodigo  ; TERMINA EL CODIGO, PROCEDE A IMPRIMIR LA RAIZ, X1 ES LA RAIZ

            finComp1:               ; else: continue
            mov eax, xs
            mov aux, eax            ; aux = xs
            inc ecx                 ; ecx++ // esto se hace para saber si se esta haciendo para y1, ys o ym
            jmp funcion             ; se va a calcular f(xs)
            
        retFunc2:                   ; se pone un checkpoint para volver al calcular ys o f(xs) | hacer la funcion por segunda vez
            mov eax, aux
            mov ys, eax             ; ys = aux = e^xs + ln(xs)

            finit
            fld ys
            fabs
            fstp aux2               ; aux2 = |ys|
            mov eax, tol
            cmp ys, eax             ; if (|ys|  <= tol) // si el valor absoluto de ys es menor que la tolerancia, se puede decir que tiene una raiz en xs.
            jg finComp2

                mov eax, 1
                mov x, eax          ; switch case x == 1 = > TIENE RAIZ EN XM
                mov eax, xs
                mov xm, eax         ; xm = xs
                jmp terminarCodigo  ; TERMINA EL CODIGO, PROCEDE A IMPRIMIR LA RAIZ, XS ES LA RAIZ

            finComp2:               ; else: continue
            
            finit
            fld y1
            fld ys
            fmul
            fstp aux                ; aux = y1*ys
            cmp aux, 0              ; if (y1*ys > 0) se sale del codigo porque no tiene raiz en el intervalo dado
            jl finComp3             ; si la resta es menor que cero, es decir que tiene una raiz en ese intervalo entonces sigue el codigo
            
                mov eax, 4
                mov x, eax          ; switch case x == 4 = > NO TIENE RAIZ EN EL INTERVALO DADO.
                jmp terminarCodigo  ; TERMINA EL CODIGO, PROCEDE A IMPRIMIR QUE NO HAY UNA RAIZ EN EL INTERVALO DADO.

            finComp3:

            inc ecx                 ; ecx++ para calcular ym

        mientras1:                  ; X1 izquierda, XM punto medio, XS derecha | swift

            finit
            fld x1
            fld xs
            fadd
            fld aux3                ; aux3 = 2 siempre
            fdiv
            fstp xm                 ; xm = (x1 + xs) / 2 <- PUNTO MEDIO

            mov eax, xm
            mov aux, eax            ; aux = xm
            jmp funcion             ; se busca f(xm) | y en el punto medio.

            retFunc3 :              ; se pone un breakpoint para volver al realizar la funcion para calcular ym, f(xm) regresa la enesima vez que se llama.
            mov eax, aux
            mov ym, eax             ; ym = f(xm) = e^xm + ln(xm) <- y en el punto medio.

            cmp ym, 0               ; if ym==0
            jz finMientras1         ; break HAY QUE CAPTURAR XM // SI YM=0 ENTONCES SE ENCONTRO LA RAIZ, SE PROCEDE A HACER EL SWITCH E IMPRIMIRLO.

            finit
            fld y1
            fld ym
            fmul
            fstp aux2               ; aux2= y1 * ym
            cmp aux2, 0             ; if (y1 * ym < 0) SE DEJA FIJO EL EXTREMO IZQUIERDO, SE MUEVE EL DERECHO.
            jg finComp4             ; else, finComp4 : SE DEJA FIJO EL EXTREMO DERECHO, SE MUEVE EL IZQUIERDO.

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
            cmp e, eax              ; if (e < tol ) SE DEBE SALIR PORQUE LA DIFERENCIA ENTRE LOS PUNTOS|ERROR ES MENOR QUE LA TOLERANCIA.
            jge finComp6            ; else: SIGA ITERANDO.

            jmp finMientras2        ; si la distancia entre los dos puntos es menor que la tolerancia, se sale del while, se procede a imprimir xm como la raiz por tolerancia.

            finComp6:               ; fin del if tolerancia

            finit
            fld it
            fld1
            fsub
            fstp it                 ; it -= 1 || it--

            mov eax, 0
            cmp it, eax             ; if (it - 0)
            jg mientras1            ; if (it > 0 ) : redo while
            jz finMientras3         ; if (it == 0) se terminan las iteraciones, se sale del while y se captura en el fin3 : NO SE ENCUENTRA RAIZ CON LAS ITERACIONES Y LA TOLERANCIA PARA ESE INTERVALO.
            
            ; HASTA ACA VA EL MIENTRAS
        
    finMientras1:                   ; cuando ym==0
        mov eax, 1
        mov x, eax                  ; switch case x==1, tiene raiz.

        jmp terminarCodigo

    finMientras2:                   ; cuando e<tol
        mov eax, 2
        mov x, eax                  ; switch case x==2, tiene raiz con error e.

        jmp terminarCodigo

    finMientras3:                   ; cuando se terminan las iteraciones
        mov eax, 3
        mov x, eax                  ; switch case x==3, no tiene raiz por culpa de las iteraciones y el error, en el intervalo si hay una raiz.

        jmp terminarCodigo

    finMientras4:                   ; cuando se ingresan numeros negativos
        mov eax, 5
        mov x, eax                  ; switch case x == 5, no tiene raiz por ingresar numeros negativos, la funcion no esta definida en negativos.

        terminarCodigo:
    }

    switch (x) {
        case 1: // x==1 tiene raiz
            std::cout << "Tiene raiz en el punto: " << xm << '\n';
            break;

        case 2: // x==2 tiene raiz en tal pero por tolerancia
            std::cout << "Tiene raiz en el punto: " << xm << ", con un error de: " << e << '\n';
            break;

        case 3:// x==3 no tiene raiz y se salio por la cantidad de iteraciones.
            std::cout << "No se encontro raiz con la cantidad de iteraciones y tolerancia." << '\n';
            break;

        case 4:// x==4 no tiene raiz por el intervalo.
            std::cout << "No hay una raiz entre el intervalo dado. [x1,xs]" << '\n';
            break;

        case 5:// x==5 error, ingreso numeros negativos
            std::cout << "NO PUEDE INGRESAR NUMEROS NEGATIVOS." << '\n';
            break;

        default: // catch default cuando no tiene riz en el intervalo.
            std::cout << "No hay una raiz entre el intervalo dado. [x1,xs]" << '\n';
            break;
    }
}
