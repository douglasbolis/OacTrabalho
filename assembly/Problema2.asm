
mov ah, qtdElem
mov cx, i
mov bh, valorAtual
mov bl, valorAnterior
mov cl, valorAux

;  Imprimindo primeiros dois números da sequência
;  printf("Sequencia de Fibinacci:\n%d %d ", bh, bl)

putc bh
putc bl

;  loop for iniciando em 2(porque os dois primeiros já foram 'calculados') e
;  com parada em 19(número de elementos da sequência, contando o zero).
dec cx + 2

loopFor:
    mov aux, bh             ;  guardando o valor corrente da sequência
    sum bh, bl              ;  gerando o novo valor para a sequência
    mov bl, aux             ;  adicionando o antigo valor corrente na variável de valor anterior
    inc al

loop loopFor

;     printf("%d ", bh);    ;  e ao final de cada rodada de execução o valor atual da sequência é impresso

;   ~Variáveis~
qtdElem        db 20     ;  Quantidade de elementos a serem impressos
i              db 2      ;  variável do loop for
valorAtual     db 1      ;  valor atual na sequência
valorAnterior  db 1      ;  valor anterior ao valor corrente na sequência
valorAux       db 0      ;