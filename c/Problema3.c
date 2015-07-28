#include<stdio.h>

int main(void) {

    int nFactory;
    int produto = 1;

    printf("Digite o numero para calcular o fatorial: ");
    scanf("%d\n", &nFactory);

    while (nFactory > 1) {
        produto = produto * nFactory;
        nFactory--;
    }

    printf("Fatorial do numero digitado %d.", produto);
}