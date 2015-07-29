#include<stdio.h>

int main(void) {
/* ~Variáveis:~ */
    int qtdElements = 20; // Quantidade de elementos a serem impressos
    int elemA = 1;        // 'elemA' seria o valor atual(corrente) na sequência
    int elemB = 1;        // 'elemB' seria o valor anterior do valor corrente na sequência
    int aux = 0;          //
    int i;                // 'i' variável do loop for

// Imprimindo primeiros dois números da sequência
    printf("Sequencia de Fibinacci:\n%d %d ", elemA, elemB);

/* loop for iniciando em 2(porque os dois primeiros já foram 'calculados') e
com parada em 19(número de elementos da sequência, contando o zero). */
    for (i = 2; i < qtdElements; i++) {
        aux = elemA;            // guardando o valor corrente da sequência
        elemA = elemA + elemB;  // gerando o novo valor para a sequência
        elemB = aux;            // adicionando o antigo valor corrente na variável de valor anterior

        printf("%d ", elemA);   // e ao final de cada rodada de execução o valor atual da sequência é impresso
    }
    printf("\n");
}