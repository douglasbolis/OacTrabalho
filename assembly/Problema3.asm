;; PROBLEMA3.ASM
ORG 100H

CALL MAIN
RET

;leia variaveis - funcao generica que encapsula todas as entradas , utilizaremos lad_a/lado_b/lado_c para armazenar lados de triangulo
;----------------------------------------------------------------------------------------------------------------------
PROC LEIA_VARIAVEIS
  ;LENDO O NUMERO
  LEA DX, MSG_NUM             ; ARMAZENA ARRAY NO DX PARA SER UTILIZADO NO READ
  CALL MSG_WRITE ; procedimento responsavel pela leitura dos numeros em array até que ocorra o enter
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
    ;O VALOR DO NUMERO QUE DESEJA CALCULA O FATORIAL É  OBTIDO EM READNUM

    ;ANALISANDO SE É POSITIVO
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
      ;DEPOIS DE CALCULADO O RESULT FICA COM O RESULTADO QUE PODE SER IMPRESSO
      MOV AX,RESULT
      CALL PRINT_NUM
    L_END_MAIN:
      RET
ENDP


;CALCULA_FATORIAL - com um loop baseado na variavel READNUM, ocorre um loop indo até zero multiplicando
;----------------------------------------------------------------------------------------------------------------------
PROC CALCULA_FATORIAL
  MOV CX,READNUM
  MOV BX,CX
  MOV AX,1
  ;loop decremental do numero inputado até zero, em caso do numero vier com zero, retorna 1
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
MSG_RESULT DW "FATORIAL E: $"


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


; this macro prints a char in AL and advances
; the current cursor position:
PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h
        POP     AX
ENDM



;***************************************************************

; This macro defines a procedure that prints number in AX,
; used with PRINT_NUM_UNS to print signed numbers:
; Requires DEFINE_PRINT_NUM_UNS !!!
DEFINE_PRINT_NUM        MACRO
LOCAL not_zero, positive, printed, skip_proc_print_num

; protect from wrong definition location:
JMP     skip_proc_print_num

PRINT_NUM       PROC    NEAR
        PUSH    DX
        PUSH    AX

        CMP     AX, 0
        JNZ     not_zero

        PUTC    '0'
        JMP     printed

not_zero:
        ; the check SIGN of AX,
        ; make absolute if it's negative:
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

; This macro defines a procedure that prints out an unsigned
; number in AX (not just a single digit)
; allowed values from 0 to 65535 (0FFFFh)
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

        ; flag to prevent printing zeros before number:
        MOV     CX, 1

        ; (result of "/ 10000" is always less or equal to 9).
        MOV     BX, 10000       ; 2710h - divider.

        ; AX is zero?
        CMP     AX, 0
        JZ      print_zero

begin_print:

        ; check divider (if zero go to end_print):
        CMP     BX,0
        JZ      end_print

        ; avoid printing zeros before number:
        CMP     CX, 0
        JE      calc
        ; if AX<BX then result of DIV will be zero:
        CMP     AX, BX
        JB      skip
calc:
        MOV     CX, 0   ; set flag.

        MOV     DX, 0
        DIV     BX      ; AX = DX:AX / BX   (DX=remainder).

        ; print last digit
        ; AH is always ZERO, so it's ignored
        ADD     AL, 30h    ; convert to ASCII code.
        PUTC    AL


        MOV     AX, DX  ; get remainder from last div.

skip:
        ; calculate BX=BX/10
        PUSH    AX
        MOV     DX, 0
        MOV     AX, BX
        DIV     CS:ten  ; AX = DX:AX / 10   (DX=remainder).
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
ten             DW      10      ; used as divider.
PRINT_NUM_UNS   ENDP

skip_proc_print_num_uns:

DEFINE_PRINT_NUM_UNS    ENDM
;***************************************************************








DEFINE_SCAN_NUM
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS

END
