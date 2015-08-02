org 100h

proc read
    mov dx,offset msg
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h
    sub al,48
    mov num1,al

    mov ah,01h
    int 21h
    sub al,48
    mov num2,al

    mov al,num1
    mul ten
    add al,num2

    mov readNum,al
    ret
endp
