#include <iostream>

int main(){
    unsigned int x1, x2;
    float tol, it, y1, ys, resultado, resul; // 4 bytes //
    std::cout << "X1\n";
    std::cin >> x1;
    /*std::cout << "X2\n";
    std::cin >> x2;
    std::cout << "Tolerancia\n";
    std::cin >> tol;
    std::cout << "Iteraciones\n";
    std::cin >> it;*/
    float e = exp(1);
    resul = 1;
    _asm {
        mov ecx, x1
        
        exponente:              ; while (ecx > 0)
            cmp ecx, 0          ; if (ecx <= 0)
            jle fin_exponente   ; then break while
            dec ecx

            finit
            fld e               ; se ingresa e
            fld resul           ; se ingresa el resultado anterior || 1
            fmul                ; se multiplican
            fstp resul          ; se guarda en resul

            jmp exponente       ; redo
        fin_exponente :

        mov ebx, resul
        mov y1, ebx
    }
    std::cout << "Valor real:    " << exp(x1) << '\n';
    std::cout << "Tiene raiz en: " << y1;
}