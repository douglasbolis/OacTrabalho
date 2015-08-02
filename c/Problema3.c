#include <stdio.h>

int main()
{
    int num;


    printf("Digite um número inteiro:");
    scanf("%d", &num);


    int tot = 1;


    for (int i = num; i >= 2; i--) {
        tot*=i;
    }

    printf("%d\n", tot);
}
