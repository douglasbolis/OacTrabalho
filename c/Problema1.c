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
    printf("LADO A: ");
    scanf("%d", &ladoA);
    printf("LADO B: ");
    scanf("%d", &ladoB);
    printf("LADO C: ");
    scanf("%d", &ladoC);
/**
 * Testando se, juntando os lados, os lados formam um triangulo.
 */
    if (ladoA + ladoB > ladoC && ladoA + ladoC > ladoB && ladoB + ladoC > ladoA) {
    /**
     * Caso forme um triangulo: testando se todos os lados são iguais.
     */
        if (ladoA == ladoB && ladoA == ladoC && ladoB == ladoC){
            printf("SEU TRIANGULO E EQUILATERO.\n");
        }
        /**
         * Testando se apenas dois dos três lados são iguais.
         */
        else if (ladoA == ladoB || ladoA == ladoC || ladoB == ladoC){
            printf("SEU TRIANGULO E ISOCELES.\n");
        }
        /**
         * Testando se todos os lados do triângulo são diferentes.
         */
         else if (ladoA != ladoB && ladoA != ladoC && ladoB != ladoC){
            printf("SEU TRIANGULO E ESCALENO.\n");
        }
    }
    /**
     * Casos os valores não formem um triangulo, uma mensagem de triangulo inválido será impresso.
     */
    else {
        printf ("SEUS VALORES NAO FORMAM UM TRIANGULO.\n");
    }
}
