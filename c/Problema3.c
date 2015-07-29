#include<stdio.h>

int main(void) {
    int elem;
    int aux;
    int prod = 1;

    printf("Digite um numero para calcular o fatorial: ");
    scanf("%d\n", &elem);

    if (elem < 0) {
        print("Numero invalido!\nNao existe fatorial de numero negativo.\n\n");
        printf("Digite outro numero maior que 0: ");
        scanf("%d\n", &elem);
    }

    aux = elem;

    while (aux > 1) {
        prod = prod * aux;
        aux--;
    }

    printf("Fatorial de %d: %d.", elem, prod);
}