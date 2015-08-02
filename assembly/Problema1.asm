;; PROBLEMA1.ASM
ORG 100H

CALL MAIN
RET


PROC LEIA_VARIAVEIS
  ;LADOA
  PUSH AX
  PUSH BX
  PUSH CX
  LEA DX, MSG_LADO_A             ; ARMAZENA ARRAY NO DX PARA SER UTILIZADO NO READ
  CALL READ
  POP CX
  POP BX
  POP AX
  MOV AL, READNUM

  ;LADOB
  PUSH AX
  PUSH BX
  PUSH CX
  LEA DX, MSG_LADO_B             ; ARMAZENA ARRAY NO DX PARA SER UTILIZADO NO READ
  CALL READ
  POP CX
  POP BX
  POP AX
  MOV BL, READNUM

  ;LADOC
  PUSH AX
  PUSH BX
  PUSH CX
  LEA DX, MSG_LADO_C             ; ARMAZENA ARRAY NO DX PARA SER UTILIZADO NO READ
  CALL READ
  POP CX
  POP BX
  POP AX
  MOV CL, READNUM
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
    ;LADOS DO TRIANGULO  AL,BL,CL SÃO OS LADOS A,B,C RESPECTIVAMENTE

    ;ANALISANDO SE FORMA UM TRIANGULO
    ; A <= B + C
    MOV DL,0
    ADD DL, BL
    ADD DL, CL
    CMP AL,DL
    JG L_NAO_TRIANGULO
    ; B <= A + C
    MOV DL,0
    ADD DL, AL
    ADD DL, CL
    CMP BL,DL
    JG L_NAO_TRIANGULO
    ; C <= A + B
    MOV DL,0
    ADD DL, AL
    ADD DL, CL
    CMP BL,DL
    JG L_NAO_TRIANGULO

    CMP AL,BL
    JE ANALISA_EQUILATERO
    JNE ANALISA_ESCALENO

    ANALISA_EQUILATERO:
    CMP AL,CL
    JE L_EQUILATERO
    JNE L_ISOSCELES

    ANALISA_ESCALENO:
    CMP AL,CL
    JE  L_ISOSCELES
    CMP BL,CL
    JE  L_ISOSCELES
    JNE L_ESCALENO

    L_NAO_TRIANGULO:
    LEA DX, MSG_ERRO
    JMP PRINT
    L_EQUILATERO:
    LEA DX, MSG_EQUILATERO
    JMP PRINT
    L_ISOSCELES:
    LEA DX, MSG_ISOSCELES
    JMP PRINT
    L_ESCALENO:
    LEA DX, MSG_ESCALENO
    JMP PRINT
    PRINT:
    MOV AH,09H
    INT 21H
    RET
ENDP







;PARA LER UM NUMERO DE 2 CASAS, VOU ARMAZENAR EM DUAS VARIAVEIS
NUM1 DB 0
TEN  DB 10
READNUM DB 0
MSG_ENTER DB  13, 10, "$"



MSG_LADO_A  DB "LADO A: $"
MSG_LADO_B  DB "LADO B: $"
MSG_LADO_C  DB "LADO C: $"
MSG_EQUILATERO  DB "SEU TRIÂNGULO É EQUILÁTERO. $"
MSG_ISOSCELES   DB "SEU TRIÂNGULO É ISÓSCELES. $"
MSG_ESCALENO    DB "SEU TRIÂNGULO É ESCALENO. $"
MSG_ERRO    DB "SEUS VALORES NÃO FORMAM UM TRIANGULO $"
