;   ~Variáveis:~
mov ah, 20     ;  Quantidade de elementos a serem impressos
mov al, 2      ;  'al' variável do loop for
mov bh, 1      ;  'bh' seria o valor atual(corrente) na sequência
mov bl, 1      ;  'bl' seria o valor anterior do valor corrente na sequência
mov cl, 0      ;

;  Imprimindo primeiros dois números da sequência
;  printf("Sequencia de Fibinacci:\n%d %d ", bh, bl)

;  loop for iniciando em 2(porque os dois primeiros já foram 'calculados') e
;  com parada em 19(número de elementos da sequência, contando o zero).

loopFor:
    mov aux, bh             ;  guardando o valor corrente da sequência
    sum bh, bl   ;  gerando o novo valor para a sequência
    mov bl, aux             ;  adicionando o antigo valor corrente na variável de valor anterior
    inc al

loop loopFor

;     printf("%d ", bh);    ;  e ao final de cada rodada de execução o valor atual da sequência é impresso