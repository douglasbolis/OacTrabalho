#include <stdio.h>

int main() {
/**
 * ~Variáveis:~.
 *
 * Lados do triângulo.
 */
    int ladoA;
    int ladoB;
    int ladoC;
/**
 * `Input`s para gravar os dados nos endereços das variáveis.
 */
    printf("Digite os valores dos lados do triângulo:\n");
    printf("Lado A: ");
    scanf("%d", &ladoA);
    printf("Lado B: ");
    scanf("%d", &ladoB);
    printf("Lado C: ");
    scanf("%d", &ladoC);
/**
 * Print inicial.
 */
    printf("Seu triângulo é ");
/**
 * Testando se, juntando os lados, os lados formam um triangulo.
 */
    if (ladoA + ladoB > ladoC && ladoA + ladoC > ladoB && ladoB + ladoC > ladoA) {
    /**
     * Caso forme um triangulo: testando se todos os lados são iguais.
     */
        if (ladoA == ladoB && ladoA == ladoC && ladoB == ladoC){
            printf("Equilátero.\n");
        }
        /**
         * Testando se apenas dois dos três lados são iguais.
         */
        else if (ladoA == ladoB || ladoA == ladoC || ladoB == ladoC){
            printf("Isósceles.\n");
        }
        /**
         * Testando se todos os lados do triângulo são diferentes.
         */
         else if (ladoA != ladoB && ladoA != ladoC && ladoB != ladoC){
            printf("Escaleno.\n");
        }
    }
    /**
     * Casos os valores não formam um triangulo, uma mensagem de triangulo inválido será impresso.
     */
    else {
        printf ("Inválido.\nOs valores digitados não formam um triangulo.\n");
    }
}