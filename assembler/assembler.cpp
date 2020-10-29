#include <iostream>

int main(){
    float x1, x2, tol, it, y1, ys, resultado; // 4 bytes //
    std::cout << "X1\n";
    std::cin >> x1;
    std::cout << "X2\n";
    std::cin >> x2;
    std::cout << "Tolerancia\n";
    std::cin >> tol;
    std::cout << "Iteraciones\n";
    std::cin >> it;

    _asm {
        mov eax, x1
        finit; comienza el coprocesador
        fld eax

        cmp y1, 0; if (y1 - 0...)
        jnz fin_si; si y1 != 0 vaya a fin_si
        mov eax, x1
        mov resultado, eax; resultado = x1
        
    }

    std::cout << "El resultado es: " << resultado;
}