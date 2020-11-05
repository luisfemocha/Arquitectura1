// proyecto1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>

int main(){
    unsigned int x1, x2;
    float tol, it, y1, ys; // 4 bytes //
    std::cout << "X1: ";
    std::cin >> x1;
    /*std::cout << "X2: ";
    std::cin >> x2;
    std::cout << "Tolerancia: ";
    std::cin >> tol;
    std::cout << "Iteraciones: ";
    std::cin >> it;*/

    float e = exp(1);
    _asm {
        mov ecx, x1
        mov resul, 1

        exponente :             ; while (ecx > 0)
            cmp ecx, 0          ; if (ecx <= 0)
            jle fin_exponente   ; then break while
            dec ecx             ; ecx--

            finit
            fld e               ; se ingresa e
            fld resul           ; se ingresa el resultado anterior || 1
            fmul                ; se multiplican
            fstp resul          ; se guarda en resul

            jmp exponente       ; redo
        fin_exponente :         ; end while

        ; resul ahora contiene e^x
        

    }
    std::cout << "Valor real:    " << exp(x1) << '\n';
    std::cout << "Tiene raiz en: " << y1;
}
