;; PROBLEMA1.ASM
;; Desenvolvido por Clayton Silva <clayton@xdevel.com.br> e Douglas Lima <douglas@xdevel.com.br>
ORG 100H

CALL LEIA_VARIAVEIS
;LADOS DO TRIANGULO  AX,BX,CX SÃO OS LADOS A,B,C RESPECTIVAMENTE

CALL PROCESSA_TRIANGULO
RET
;leia variaveis - funcao generica que encapsula todas as entradas , utilizaremos lad_a/lado_b/lado_c para armazenar lados de triangulo
;----------------------------------------------------------------------------------------------------------------------
PROC LEIA_VARIAVEIS
    ;LADOA
    LEA DX, MSG_LADO_A             ; ARMAZENA ARRAY NO DX PARA SER UTILIZADO NO READ
    CALL MSG_WRITE
    CALL SCAN_NUM
    MOV LADO_A,CX

    ;LADOB
    LEA DX, MSG_LADO_B             ; ARMAZENA ARRAY NO DX PARA SER UTILIZADO NO READ
    CALL MSG_WRITE
    CALL SCAN_NUM
    MOV LADO_B,CX

    ;LADOC
    LEA DX, MSG_LADO_C             ; ARMAZENA ARRAY NO DX PARA SER UTILIZADO NO READ
    CALL MSG_WRITE
    CALL SCAN_NUM
    MOV LADO_C,CX
    RET
ENDP
;fim de leia variaveis
;----------------------------------------------------------------------------------------------------------------------


;msg_write - modularizacao da impressao de mensagem do conteudo armazenado em DX
;----------------------------------------------------------------------------------------------------------------------
PROC MSG_WRITE
    ;IMPRESSAO DA MENSAGEM DE LEITURA DO CAMPO PELO REGISTRADOR DX
    MOV AH,09H
    INT 21H
    RET
ENDP


;PROCESSA TRIANGULO - TODA REGRA DE NEGOCIO DO PROBLEMA FICAR ARMAZENADO NELA, COM AX/BX/CX VERIFICAMOS:
; - SE FORMA TRIANGULO
; - QUAL TRIANGULO É FORMADO (ESCALENO,EQUILATERO,ISOSCELES)
;----------------------------------------------------------------------------------------------------------------------
PROC PROCESSA_TRIANGULO

    ;APLICANDO LADO_A , LADO_B E LADO_C EM AX,BX,CX RESPECTIVAMENTE
    MOV AX,LADO_A
    MOV BX,LADO_B
    MOV CX,LADO_C


    ;ANALISANDO SE FORMA UM TRIANGULO
    ; A <= B + C
    MOV DX,0
    ADD DX, BX
    ADD DX, CX
    CMP AX,DX
    JG L_NAO_TRIANGULO
    ; B <= A + C
    MOV DX,0
    ADD DX, AX
    ADD DX, CX
    CMP BX,DX
    JG L_NAO_TRIANGULO
    ; C <= A + B
    MOV DX,0
    ADD DX, AX
    ADD DX, CX
    CMP BX,DX
    JG L_NAO_TRIANGULO

    CMP AX,BX
    JE ANALISA_EQUILATERO
    JNE ANALISA_ESCALENO

    ANALISA_EQUILATERO:
      CMP AX,CX
      JE L_EQUILATERO
      JNE L_ISOSCELES

    ANALISA_ESCALENO:
      CMP AX,CX
      JE  L_ISOSCELES
      CMP BX,CX
      JE  L_ISOSCELES
      JNE L_ESCALENO
    ;COMO OBJETIVO FINAL É IMPRIMIR O RESULTADO OBTIDO, FIZ UMA TRILHA DE RESPOSTA INDO DO ERRO DO TRIANGULO NAO FORMADO
    ;ATE A IMPRESSAO DE UM DOS TRIANGULOS, TODOS ELES FAZEM JMP PARA O LABEL L_PRINT
    L_NAO_TRIANGULO:
      LEA DX, MSG_ERRO
      JMP L_PRINT
    L_EQUILATERO:
      LEA DX, MSG_EQUILATERO
      JMP  L_PRINT
    L_ISOSCELES:
      LEA DX, MSG_ISOSCELES
      JMP L_PRINT
    L_ESCALENO:
      LEA DX, MSG_ESCALENO
      JMP L_PRINT
    L_PRINT:
      CALL MSG_WRITE
    RET
ENDP




;VARIAVEL APARA OS LADOS DO TRIANGULO
LADO_A DW 0
LADO_B DW 0
LADO_C DW 0


MSG_ENTER DB  13, 10, "$" ;cr + lf para forçar o enter e gerar uma nova linha
MSG_LADO_A  DB "LADO A: $"
MSG_LADO_B  DB "LADO B: $"
MSG_LADO_C  DB "LADO C: $"
MSG_EQUILATERO  DB "SEU TRIÂNGULO É EQUILÁTERO. $"
MSG_ISOSCELES   DB "SEU TRIÂNGULO É ISÓSCELES. $"
MSG_ESCALENO    DB "SEU TRIÂNGULO É ESCALENO. $"
MSG_ERRO    DB "SEUS VALORES NÃO FORMAM UM TRIANGULO $"

;----------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------
; ZONA DO CONTROL+C E CONTROL+V


;MACROS IMPORTADAS  DO EMU8086.INC
;***************************************************************

; MACRO LE UM NÚMERO COM SINAL E ARMAZENA NO REGISTRADOR CX
DEFINE_SCAN_NUM         MACRO
LOCAL MAKE_MINUS, TEN, NEXT_DIGIT, SET_MINUS
LOCAL TOO_BIG, BACKSPACE_CHECKED, TOO_BIG2
LOCAL STOP_INPUT, NOT_MINUS, SKIP_PROC_SCAN_NUM
LOCAL REMOVE_NOT_DIGIT, OK_AE_0, OK_DIGIT, NOT_CR

; PROTECT FROM WRONG DEFINITION LOCATION:
JMP     SKIP_PROC_SCAN_NUM

SCAN_NUM        PROC    NEAR
        ;EMPILHANDO REGISTRADORES UTILIZADOS NA MACRO
        PUSH    DX
        PUSH    AX
        PUSH    SI

        ;CX SERÁ UTILIZADO NA LEITURA, INICIAMOS COM ZERO
        MOV     CX, 0

        ; RESET FLAG:
        MOV     CS:MAKE_MINUS, 0

NEXT_DIGIT:

        ; GET CHAR FROM KEYBOARD
        ; INTO AL:
        MOV     AH, 00H
        INT     16H
        ; AND PRINT IT:
        MOV     AH, 0EH
        INT     10H

        ; CHECK FOR MINUS:
        CMP     AL, '-'
        JE      SET_MINUS

        ; CHECK FOR ENTER KEY:
        CMP     AL, 13  ; CARRIAGE RETURN?
        JNE     NOT_CR
        JMP     STOP_INPUT
NOT_CR:


        CMP     AL, 8                   ; 'BACKSPACE' PRESSED?
        JNE     BACKSPACE_CHECKED
        MOV     DX, 0                   ; REMOVE LAST DIGIT BY
        MOV     AX, CX                  ; DIVISION:
        DIV     CS:TEN                  ; AX = DX:AX / 10 (DX-REM).
        MOV     CX, AX
        PUTC    ' '                     ; CLEAR POSITION.
        PUTC    8                       ; BACKSPACE AGAIN.
        JMP     NEXT_DIGIT
BACKSPACE_CHECKED:


        ; ALLOW ONLY DIGITS:
        CMP     AL, '0'
        JAE     OK_AE_0
        JMP     REMOVE_NOT_DIGIT
OK_AE_0:
        CMP     AL, '9'
        JBE     OK_DIGIT
REMOVE_NOT_DIGIT:
        PUTC    8       ; BACKSPACE.
        PUTC    ' '     ; CLEAR LAST ENTERED NOT DIGIT.
        PUTC    8       ; BACKSPACE AGAIN.
        JMP     NEXT_DIGIT ; WAIT FOR NEXT INPUT.
OK_DIGIT:


        ; MULTIPLY CX BY 10 (FIRST TIME THE RESULT IS ZERO)
        PUSH    AX
        MOV     AX, CX
        MUL     CS:TEN                  ; DX:AX = AX*10
        MOV     CX, AX
        POP     AX

        ; CHECK IF THE NUMBER IS TOO BIG
        ; (RESULT SHOULD BE 16 BITS)
        CMP     DX, 0
        JNE     TOO_BIG

        ; CONVERT FROM ASCII CODE:
        SUB     AL, 30H

        ; ADD AL TO CX:
        MOV     AH, 0
        MOV     DX, CX      ; BACKUP, IN CASE THE RESULT WILL BE TOO BIG.
        ADD     CX, AX
        JC      TOO_BIG2    ; JUMP IF THE NUMBER IS TOO BIG.

        JMP     NEXT_DIGIT

SET_MINUS:
        MOV     CS:MAKE_MINUS, 1 ;???
        JMP     NEXT_DIGIT

TOO_BIG2:
        MOV     CX, DX      ; RESTORE THE BACKUPED VALUE BEFORE ADD.
        MOV     DX, 0       ; DX WAS ZERO BEFORE BACKUP!
TOO_BIG:
        MOV     AX, CX
        DIV     CS:TEN  ; REVERSE LAST DX:AX = AX*10, MAKE AX = DX:AX / 10
        MOV     CX, AX
        PUTC    8       ; BACKSPACE.
        PUTC    ' '     ; CLEAR LAST ENTERED DIGIT.
        PUTC    8       ; BACKSPACE AGAIN.
        JMP     NEXT_DIGIT ; WAIT FOR ENTER/BACKSPACE.


STOP_INPUT:
        ; CHECK FLAG:
        CMP     CS:MAKE_MINUS, 0 ; ????
        JE      NOT_MINUS
        NEG     CX
NOT_MINUS:
        ;RESTAURANDO OS VALORES ORIGINAIS QUE ESTAVAM ARMAZENADOS NA PILHA
        POP     SI
        POP     AX
        POP     DX

        ;Adicionado intencionalmente para adicionar uma nova linha a cada leitura
        LEA DX, MSG_ENTER             ; ARMAZENA ARRAY NO DX PARA SER UTILIZADO NO READ
        CALL MSG_WRITE




        RET
MAKE_MINUS      DB      ?       ; USADO COMO MARCADOR DE -.
TEN             DW      10      ; MULTIPLICADOR DE CASAS.
SCAN_NUM        ENDP

SKIP_PROC_SCAN_NUM:

DEFINE_SCAN_NUM         ENDM
;***************************************************************


;esta macro imprime um caractere em AL
;e avan�a a posi��o atual do cursor:
PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h
        POP     AX
ENDM

DEFINE_SCAN_NUM

END
