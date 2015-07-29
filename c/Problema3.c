#include<stdio.h>

int main(void) {
    int elem;
    int aux;
    int prod = 1;

    printf("Digite um numero para calcular o fatorial: ");
    scanf("%d", &elem);

    if (elem < 0) {
        printf("Numero invalido!\nNao existe fatorial de numero negativo.\n\n");
        printf("Digite outro numero maior que 0: ");
        scanf("%d", &elem);
    }

    aux = elem;

    while (aux > 1) {
        prod = prod * aux;
        aux--;
    }

    printf("Fatorial de %d: %d.\n", elem, prod);
}