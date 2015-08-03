;; PROBLEMA1.ASM
ORG 100H

CALL CALCULA_FIB
RET


PROC PRINT_VIRGULA
  PUSH AX ; EMPILHANDO OS REGISTRADORES UTILIZADOS NO PROCEDIMENTO
  PUSH DX ; EMPILHANDO OS REGISTRADORES UTILIZADOS NO PROCEDIMENTO
  LEA DX, MSG_VIRGULA
  MOV AH,09H
  INT 21H
  POP DX ; DESEMPLILHANDO
  POP AX
  RET
ENDP



;usando o recurso do loop que armazena em cx ele decrementa acumulando multiplicadores até que cx fique um
PROC CALCULA_FIB
   MOV BX,elemA
   MOV DX,elemB
   MOV CX,qtdElements ;
   SUB CX,1 ; SUBTRAINDO 1 PARA QUE A CONTAGEM OCORRA DE DOIS ATÉ O NUMERO

   ;IMPRIMINDO OS DOIS PRIMEIROS MEMBROS DE FIBONACCI
   MOV AX,BX
   CALL PRINT_NUM ;IMPRIMINDO O NUMERO NA ORDEM DA SERIE DE FIB
   CALL PRINT_VIRGULA
   MOV AX,DX
   CALL PRINT_NUM ;IMPRIMINDO O NUMERO NA ORDEM DA SERIE DE FIB

   L_K:  MOV AX,BX ;ARMAZENANDO BX EM AX QUE VAI SER USADO PRA PIVOTEAR
         ADD AX,DX ;ADICIONANDO DX EM AX PARA OPERAR O FIBONACCI
         CALL PRINT_VIRGULA
         CALL PRINT_NUM ;IMPRIMINDO O NUMERO NA ORDEM DA SERIE DE FIB
         CMP CX,2 ;QUANDO
         JE L_END
         LOOP L_K
   L_END:
         RET


for (i = 2; i < qtdElements; i++) {
    auxC = elemA;
    elemA = elemA + elemB;
    elemB = auxC;

    printf("%d ", elemA);
}


ENDP




;MACROS IMPORTADAS  DO EMU8086.INC
;***************************************************************
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



qtdElements db 20;
elemA db 1;
elemB db 1;
auxC db 0;

DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS

;PARA LER UM NUMERO DE 2 CASAS, VOU ARMAZENAR EM DUAS VARIAVEIS
MSG_VIRGULA DB  ", $"
