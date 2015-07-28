#include <stdio.h>

int main()
{
    int ladoA;
    int ladoB;
    int ladoC;
    
    printf("Digite os valores dos lados do triângulo:\n");
    printf("Lado A: ");
    scanf("%d\n", &ladoA);
    printf("Lado B: ");
    scanf("%d\n", &ladoB);
    printf("Lado C: ");
    scanf("%d\n", &ladoC);

    printf("Seu triângulo é ");
    
    if (ladoA + ladoB >= ladoC && ladoA + ladoC >= ladoB && ladoB + ladoC >= ladoA) {
        if (ladoA == ladoB && ladoA == ladoC && ladoB == ladoC){
            printf("Equilátero.");
        } else if (ladoA == ladoB || ladoA == ladoC || ladoB == ladoC){
            printf("Isósceles.");
        } else if (ladoA != ladoB && ladoA != ladoC && ladoB != ladoC){
            printf("Escaleno.");
        }
    } else
        printf ("Inválido.\nSeus valores não podem formar um triangulo");
}