;; PROBLEMA1.ASM
ORG 100H

CALL MAIN
RET


PROC LEIA_VARIAVEIS
  ;LENDO O NUMERO
  PUSH AX
  LEA DX, MSG_NUM             ; ARMAZENA ARRAY NO DX PARA SER UTILIZADO NO READ
  CALL READ
  POP CX
  MOV AL, READNUM
  RET
ENDP


; FUNCIONAMENTO : O PROCEDIMENTO LE DOIS NUMEROS , MULTIPLICA O PRIMEIRO POR 10 E SOMA COM O SEGUNDO, ASSIM RETORNA EM READNUM
PROC READ
    ;impressao da mensagem de leitura do campo pelo registrador dx
    MOV AH,09H
    INT 21H
    MOV READNUM,0


    ;interruptor le o numero e armazena no registrador AL
    LENUMERO:
    MOV AH,01H
    INT 21H

    ;se o caracter lido for enter, finaliza a leitura, senão deve ser feito um loop
    CMP AL,13
    JE  FIMREAD


    SUB AL,48  ; remove 48 do numero de entrada, pois a entrada é o codigo em ascii do valor digitado
    MOV NUM1,AL ; reserva em num1 para fazer calculo
    MOV AL,READNUM
    MUL TEN ; por se tratar de base decimal na operação de entrada (inteiro) a cada digitado, deve pegar o valor já ARMAZENADO
            ; multiplicar por 10 e por fim somar com o ultimo valor lido do teclado, essa condicao é parada quando é pressionado o enter

    ADD AL,NUM1
    MOV READNUM,AL
    JMP LENUMERO ;loop incondicional em que é quebrado somente caso o "JE FIMREAD" ocorra

    FIMREAD:
    LEA DX, MSG_ENTER ; nova linha impressa no monitor ao final da leitura
    MOV AH,09H
    INT 21H
    RET
ENDP


PROC MAIN

    CALL LEIA_VARIAVEIS
    ;O VALOR DO NUMERO QUE DESEJA CALCULA O FATORIAL É  OBTIDO EM AL

    ;ANALISANDO SE É POSITIVO
    CMP AL,0
    JLE L_ERRO
    JG  PROCESSA

    L_ERRO:
      LEA DX, MSG_ERRO
      MOV AH,09H
      INT 21H
      MOV READNUM,0
    PROCESSA:
      CALL CALCULA_FATORIAL
      MOV DX,AX
      MOV AH,09H
      INT 21H


    RET
ENDP

PROC CALCULA_FATORIAL
  ;CALCULA PELO VALOR ARMAZENADO EM AL
  MOV AH,0
  MOV CX,AX
  MOV BX,CX
  MOV AX,1
  K:  MUL CX
      LOOP K

  MOV RESULT,AX
ENDP







;PARA LER UM NUMERO DE 2 CASAS, VOU ARMAZENAR EM DUAS VARIAVEIS
NUM1 DB 1
RESULT DW 1
TEN  DB 10
READNUM DB 0
MSG_ENTER DB  13, 10, "$"



MSG_NUM  DB "DIGITE UM NUMERO: $"
MSG_ERRO    DB "NAO FOI POSSIVEL CALCULAR O FATORIAL $"
