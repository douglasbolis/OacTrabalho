#include <stdio.h>

int main() {
/**
 * ~Variáveis:~
 *
 * Variável do loop for.
 */
    int i;
/**
 * Numero digitado a ser calculado o seu fatorial.
 */
    int num;
/**
 * Fatorial que será gerado ao final do loop.
 */
    int fat = 1;
/**
 * Input para armazenar o numero digitado no endereço da variável.
 */
    printf("DIGITE UM NUMERO: ");
    scanf("%d", &num);
/**
 * Loop for para gerar o fatorial decrementando a partir do numero digitado até chegar a dois,
 * assim, a cada loop o valor decrementado é multiplicado pelo valor contido em `fat`.
 */
    for (i = num; i >= 2; i--) {
        fat*=i;
    }
/**
 * Impressão do resultado final do fatorial de número digitado.
 */
    printf("FATORIAL E: %d\n", fat);
}
