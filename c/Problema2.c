#include<stdio.h>

int main() {

    int qtdElements = 20;
    int elemA = 1;
    int elemB = 1;
    int auxC = 0;
    int i;

    printf("%d %d ", elemA, elemB);

    for (i = 2; i < qtdElements; i++) {
        auxC = elemA;
        elemA = elemA + elemB;
        elemB = auxC;

        printf("%d ", elemA);
    }
}
