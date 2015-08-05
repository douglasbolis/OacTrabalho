#include<stdio.h>

int main(void) {
/**
 * ~Variáveis:~
 *
 * Quantidade de elementos a serem impressos.
 */
    int qtdElements = 20;
/**
 * Valor atual(corrente) na sequência.
 */
    int elemA = 1;
/**
 * Valor anterior do valor corrente na sequência.
 */
    int elemB = 1;
/**
 * Variável para auxiliar no cálculo da sequência.
 */
    int aux = 0;
/**
 * Variável do loop for.
 */
    int i;
/**
 * Imprimindo primeiros dois números da sequência
 */
    printf("%d %d ", elemA, elemB);
/**
 * Loop for iniciando em 2(porque os dois primeiros elementos da sequência
 * já foram impresso) com parada em 19(número de elementos da sequência, contando o zero).
 */
    for (i = 2; i < qtdElements; i++) {
        /**
         * Guardando o valor corrente da sequência.
         */
        aux = elemA;
        /**
         * Gerando o novo valor para a sequência.
         */
        elemA = elemA + elemB;
        /**
         * Adicionando o antigo valor corrente na variável de valor anterior.
         */
        elemB = aux;
        /**
         * E ao final de cada loop o valor atual da sequência é impresso.
         */
        printf("%d ", elemA);
    }
    printf("\n");
}
