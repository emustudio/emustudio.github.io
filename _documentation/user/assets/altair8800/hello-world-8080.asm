; Print a boxed greeting on the Altair's ADM-3A terminal.
; The default 88-SIO routes output on port 11h to the terminal.

org 0

    lxi h, message
next_char:
    mov a, m
    cpi 0
    jz done
    out 11h
    inx h
    jmp next_char

done:
    hlt

message:
    db 201, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 187, 10, 13
    db 186, "Hello world!", 186, 10, 13
    db 200, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 188
    db 0
