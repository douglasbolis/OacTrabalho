;; PROBLEMA3.ASM
ORG 100H

CALL MAIN
RET

;leia variaveis - funcao generica que encapsula todas as entradas , utilizaremos lad_a/lado_b/lado_c para armazenar lados de triangulo
;----------------------------------------------------------------------------------------------------------------------
PROC LEIA_VARIAVEIS
  ;LENDO O NUMERO
  LEA DX, MSG_NUM             ; ARMAZENA ARRAY NO DX PARA SER UTILIZADO NO READ
  CALL MSG_WRITE ; procedimento responsavel pela leitura dos numeros em array at√© que ocorra o enter
  CALL SCAN_NUM
  MOV READNUM,CX
  RET
ENDP


;msg_write - modularizacao da impressao de mensagem do conteudo armazenado em DX
;----------------------------------------------------------------------------------------------------------------------
PROC MSG_WRITE
    ;IMPRESSAO DA MENSAGEM DE LEITURA DO CAMPO PELO REGISTRADOR DX
    MOV AH,09H
    INT 21H
    RET
ENDP

;MAIN - funcao principal do programa, que organiza todo o fluxo em
; - le o valor de entrada
; - processa o FATORIAL
; - imprime o resultado
;----------------------------------------------------------------------------------------------------------------------
PROC MAIN

    CALL LEIA_VARIAVEIS
    ;O VALOR DO NUMERO QUE DESEJA CALCULA O FATORIAL √â  OBTIDO EM READNUM

    ;ANALISANDO SE √â POSITIVO
    CMP  READNUM,0
    JL   L_ERRO  ;encaminha para o label de erro caso seja menor que zero
    JGE  L_PROCESSA

    L_ERRO:
      LEA DX, MSG_ERRO
      MOV AH,09H
      INT 21H
      MOV READNUM,0
      JMP L_END_MAIN
    L_PROCESSA:
      CALL CALCULA_FATORIAL
      LEA DX,MSG_RESULT
      MOV AH,09H
      INT 21H

      LEA DX,MSG_RESULT
      MOV AH,09H
      INT 21H
      ;DEPOIS DE CALCULADO O RESULT FICA COM O RESULTADO QUE PODE SER IMPRESSO
      MOV AX,RESULT
      CALL PRINT_NUM
    L_END_MAIN:
      RET
ENDP


;CALCULA_FATORIAL - com um loop baseado na variavel READNUM, ocorre um loop indo at√© zero multiplicando
;----------------------------------------------------------------------------------------------------------------------
PROC CALCULA_FATORIAL
  MOV CX,READNUM
  MOV BX,CX
  MOV AX,1
  ;loop decremental do numero inputado at√© zero, em caso do numero vier com zero, retorna 1
  CMP CX,0
  JE  L_END
  JNE L_K
  L_K:  MUL CX
        LOOP L_K
  L_END:
    MOV RESULT,AX
    RET
ENDP


;PARA LER UM NUMERO DE 2 CASAS, VOU ARMAZENAR EM DUAS VARIAVEIS
RESULT DW 1
READNUM DW 0
MSG_ENTER DB  13, 10, "$"



MSG_NUM  DB "DIGITE UM NUMERO: $"
MSG_ERRO    DB "NAO FOI POSSIVEL CALCULAR O FATORIAL $"
MSG_RESULT DW "FATORIAL √â: $"


;----------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------
; ZONA DO CONTROL+C E CONTROL+V



;MACROS IMPORTADAS  DO EMU8086.INC
;***************************************************************

; MACRO LE UM N√öMERO COM SINAL E ARMAZENA NO REGISTRADOR CX
DEFINE_SCAN_NUM         MACRO

; DEFININDO COMO ESCOPO LOCAL
LOCAL MAKE_MINUS, TEN, NEXT_DIGIT, SET_MINUS
LOCAL TOO_BIG, BACKSPACE_CHECKED, TOO_BIG2
LOCAL STOP_INPUT, NOT_MINUS, SKIP_PROC_SCAN_NUM
LOCAL REMOVE_NOT_DIGIT, OK_AE_0, OK_DIGIT, NOT_CR

; PROTEGE DA DEFINI«√O ERRADA DE LOCALIZA«√O:
JMP     SKIP_PROC_SCAN_NUM

SCAN_NUM        PROC    NEAR
        ;EMPILHANDO REGISTRADORES UTILIZADOS NA MACRO
        PUSH    DX
        PUSH    AX
        PUSH    SI

        ;CX SER√Å UTILIZADO NA LEITURA, INICIAMOS COM ZERO
        MOV     CX, 0

        ; REAJUSTANDO BANDEIRA:
        MOV     CS:MAKE_MINUS, 0

NEXT_DIGIT:

        ; CAPITURA CARACTER DO TECLADO
        ; MOVENDO PARA AL:
        MOV     AH, 00H
        INT     16H
        ; E IMPRIMINDO ELE:
        MOV     AH, 0EH
        INT     10H

        ; VERIFICANDO SE POSSUI SINAL DE `MENOS`:
        CMP     AL, '-'
        JE      SET_MINUS

        ; VERIFICANDO SE H¡ O CARACTER DE ENTER:
        CMP     AL, 13  ; RETORNO?
        JNE     NOT_CR
        JMP     STOP_INPUT
NOT_CR:


        CMP     AL, 8                   ; 'BACKSPACE' PRESSIONADO?
        JNE     BACKSPACE_CHECKED
        MOV     DX, 0                   ; REMOVE O ⁄LTIMO DIGITO
        MOV     AX, CX                  ; DIVIS√O:
        DIV     CS:TEN                  ; AX = DX:AX / 10 (DX-REM).
        MOV     CX, AX
        PUTC    ' '                     ; LIMPA A POSI«√O.
        PUTC    8                       ; BACKSPACE NOVAMENTE.
        JMP     NEXT_DIGIT
BACKSPACE_CHECKED:


        ; PERMITE SOMENTE DIGITOS:
        CMP     AL, '0'
        JAE     OK_AE_0
        JMP     REMOVE_NOT_DIGIT
OK_AE_0:
        CMP     AL, '9'
        JBE     OK_DIGIT
REMOVE_NOT_DIGIT:
        PUTC    8       ; BACKSPACE.
        PUTC    ' '     ; REMOVE O ULTIMO CARACTER N√O DIGITO.
        PUTC    8       ; BACKSPACE NOVAMENTE.
        JMP     NEXT_DIGIT ; ESPERANDO PR”XIMA ENTRADA DE DADO.
OK_DIGIT:


        ; MULTIPLICANDO CX POR 10 (A PRIMEIRA VEZ O RESULTADO … ZERO)
        PUSH    AX
        MOV     AX, CX
        MUL     CS:TEN                  ; DX:AX = AX*10
        MOV     CX, AX
        POP     AX

        ; VERIFICANDO SE O N⁄MERO … MUITO GRANDE
        ; (O RESULTADO DEVE SER DE 16 BITS)
        CMP     DX, 0
        JNE     TOO_BIG

        ; CONVERTENDO O CODIGO ASCII:
        SUB     AL, 30H

        ; ADD AL EM CX:
        MOV     AH, 0
        MOV     DX, CX      ; BACKUP, CASO O RESULTADO SEJA MUITO GRANDE.
        ADD     CX, AX
        JC      TOO_BIG2    ; JUMP IF THE NUMBER IS TOO BIG.

        JMP     NEXT_DIGIT

SET_MINUS:
        MOV     CS:MAKE_MINUS, 1 ;???
        JMP     NEXT_DIGIT

TOO_BIG2:
        MOV     CX, DX      ; RESTAURA O VALOR DE BACKUP ANTES DE  ADICIONAR
        MOV     DX, 0       ; DX FOI ZERO ANTES DO BACKUP!
TOO_BIG:
        MOV     AX, CX
        DIV     CS:TEN  ; REVERTE O ULTIMO DX:AX = AX*10, MAKE AX = DX:AX / 10
        MOV     CX, AX
        PUTC    8       ; BACKSPACE.
        PUTC    ' '     ; REMOVE O ULTIMO DIGITO INTRODUZIDO.
        PUTC    8       ; BACKSPACE NOVAMENTE.
        JMP     NEXT_DIGIT ; ESPERANDO POR UM ENTER OU BACKSPACE.


STOP_INPUT:
        ; VERIFICANDO A FLAG:
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


; esta macro imprime um caractere em AL e avanÁos
; a posiÁ„o atual do cursor:
PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h
        POP     AX
ENDM



;***************************************************************

; Essa macro define um procedimento que imprime n˙mero em AX,
; usado com PRINT_NUM_UNS para imprimir n˙meros assinados:
; Requer DEFINE_PRINT_NUM_UNS !!!
DEFINE_PRINT_NUM        MACRO
LOCAL not_zero, positive, printed, skip_proc_print_num

; PROTEGE DE DEFINI«√O COM LOCALIZA«√O ERRADA:
JMP     skip_proc_print_num

PRINT_NUM       PROC    NEAR
        PUSH    DX
        PUSH    AX

        CMP     AX, 0
        JNZ     not_zero

        PUTC    '0'
        JMP     printed

not_zero:
        ; o sinal de verificaÁ„o de AX,
††††††† ; tornar absoluto se È negativo:
        CMP     AX, 0
        JNS     positive
        NEG     AX

        PUTC    '-'

positive:
        CALL    PRINT_NUM_UNS
printed:
        POP     AX
        POP     DX
        RET
PRINT_NUM       ENDP

skip_proc_print_num:

DEFINE_PRINT_NUM        ENDM

;***************************************************************

; Essa macro define um procedimento que imprime um sem assinatura
; n˙mero em AX (e n„o apenas um ˙nico dÌgito)
; valores permitidos 0-65535 (0FFFFh)
DEFINE_PRINT_NUM_UNS    MACRO
LOCAL begin_print, calc, skip, print_zero, end_print, ten
LOCAL skip_proc_print_num_uns

; protect from wrong definition location:
JMP     skip_proc_print_num_uns

PRINT_NUM_UNS   PROC    NEAR
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX

        ; flag para evitar a impress„o de zeros antes do n˙mero:
        MOV     CX, 1

        ; (resultado de "/ 10000" È sempre menor ou igual a 9).
        MOV     BX, 10000       ; 2710h - DIVISOR.

        ; AX … ZERO?
        CMP     AX, 0
        JZ      print_zero

begin_print:

        ; VERIFICANDO DIVISOR (SE FOR ZERO VA PARA END_PRINT)
        CMP     BX,0
        JZ      end_print

        ; evitar a impress„o de zeros antes do n˙mero:
        CMP     CX, 0
        JE      calc
        ; se AX <BX ent„o resultar de DIV ser· zero:
        CMP     AX, BX
        JB      skip
calc:
        MOV     CX, 0   ; SETANDO A  FLAG.

        MOV     DX, 0
        DIV     BX      ; AX = DX:AX / BX   (DX=RESTANTE).

        ; imprimir ˙ltimo dÌgito
††††††† ; AH È sempre zero, por isso È ignorado
        ADD     AL, 30h    ; CONVERTENDO PARA CODIGO ASCII.
        PUTC    AL


        MOV     AX, DX  ; PEGANDO O RESTANTE DA ULTIMA DIV.

skip:
        ; calculate BX=BX/10
        PUSH    AX
        MOV     DX, 0
        MOV     AX, BX
        DIV     CS:ten  ; AX = DX:AX / 10   (DX=RESTANTE).
        MOV     BX, AX
        POP     AX

        JMP     begin_print

print_zero:
        PUTC    '0'

end_print:

        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
ten             DW      10      ; USADO COMO DIVISOR.
PRINT_NUM_UNS   ENDP

skip_proc_print_num_uns:

DEFINE_PRINT_NUM_UNS    ENDM
;***************************************************************








DEFINE_SCAN_NUM
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS

END
