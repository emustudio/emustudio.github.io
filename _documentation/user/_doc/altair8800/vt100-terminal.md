---
layout: default
title: Device "vt100-terminal"
nav_order: 9
parent: MITS Altair8800
permalink: /altair8800/vt100-terminal
---

{% include analytics.html category="Altair8800" %}

# VT100 Terminal for Altair8800

Besides the [LSI ADM-3A terminal]({{ site.baseurl }}/altair8800/adm3a-terminal), it is also possible to use the
**VT100 terminal** (`vt100-terminal`) with the Altair8800 computer. The VT100 terminal offers a richer set of features
compared to the ADM-3A, most notably ANSI color support, text attributes (bold, italic, underline, and more), and
additional cursor and screen manipulation sequences. This makes it a better choice for running software that relies on
ANSI escape codes, such as some CP/M programs or custom applications.

The VT100 terminal connects to the Altair8800 through the [88-SIO serial board]({{ site.baseurl }}/altair8800/88-sio)
in exactly the same way as the ADM-3A terminal. In the abstract schema, simply use `vt100-terminal` instead of
`adm3A-terminal` as the device connected to `88-sio`.

For the full reference of all supported VT100 control codes, escape sequences, SGR attributes, and color palette, please
see the [VT100 terminal documentation]({{ site.baseurl }}/brainduck/terminal).

Abstract schema for emuStudio (with VT100 terminal):

![Abstract schema of MITS Altair8800 (with VT100 terminal)]({{ site.baseurl }}/assets/altair8800/altair-vt100-schema.png)

## Programming with ANSI escape sequences

When using the VT100 terminal with Altair8800, ANSI escape sequences are sent as raw bytes through the 88-SIO data
port (default `0x11`). An escape sequence typically starts with the ESC character (ASCII `0x1B`, decimal `27`), followed
by `[` (ASCII `0x5B`, decimal `91`), then parameters and a final command character.

The following examples are written in the `as-8080` assembler.

### Utility: print procedure

All examples below use the following procedure for printing a null-terminated string:

{:.code-example}
```
; Procedure for printing text to terminal.
; Input: pair HL must contain the address of the ASCIIZ string
print:
    mov a, m  ; load character from HL
    inx h     ; increment HL
    cpi 0     ; is the character = 0?
    rz        ; yes; return
    out 11h   ; otherwise; send to terminal via 88-SIO
    jmp print ; and repeat
```

### Example 1: Red text

This example prints "Hello!" in red on the default (black) background, and resets attributes afterwards.

{:.code-example}
```
    lxi h, red_hello
    call print
    hlt

; ESC[31m sets red foreground, ESC[0m resets all attributes
red_hello: db 27,'[31m','Hello!',27,'[0m',0

print:
    mov a, m
    inx h
    cpi 0
    rz
    out 11h
    jmp print
```

### Example 2: Green text on white background

{:.code-example}
```
    lxi h, green_msg
    call print
    hlt

; ESC[32;47m = green foreground + white background
green_msg: db 27,'[32;47m','Green on white',27,'[0m',0

print:
    mov a, m
    inx h
    cpi 0
    rz
    out 11h
    jmp print
```

### Example 3: Bold and underlined text

{:.code-example}
```
    lxi h, bold_msg
    call print
    hlt

; ESC[1;4m = bold + underline
bold_msg: db 27,'[1;4m','Bold & Underlined',27,'[0m',0

print:
    mov a, m
    inx h
    cpi 0
    rz
    out 11h
    jmp print
```

### Example 4: Multiple colors in one program

This example shows several colored lines, each with a different color, and resets after each line.

{:.code-example}
```
    lxi h, line1
    call print
    lxi h, line2
    call print
    lxi h, line3
    call print
    lxi h, line4
    call print
    lxi h, line5
    call print
    lxi h, reset
    call print
    hlt

; Red text
line1: db 27,'[31m','Red line',10,13,0
; Green text
line2: db 27,'[32m','Green line',10,13,0
; Yellow bold text
line3: db 27,'[1;33m','Yellow bold line',27,'[0m',10,13,0
; Blue on cyan background
line4: db 27,'[34;46m','Blue on cyan',27,'[0m',10,13,0
; Bright magenta, italic
line5: db 27,'[3;95m','Bright magenta italic',27,'[0m',10,13,0
; Reset all attributes
reset: db 27,'[0m',0

print:
    mov a, m
    inx h
    cpi 0
    rz
    out 11h
    jmp print
```

### Example 5: Clear screen and position cursor

This example clears the screen, positions the cursor at row 10, column 20, and prints a message in bright cyan.

{:.code-example}
```
    lxi h, cls
    call print
    lxi h, pos_msg
    call print
    hlt

; ESC[2J = clear entire screen
; ESC[H  = move cursor to home (top-left)
cls: db 27,'[2J',27,'[H',0

; ESC[10;20H = move cursor to row 10, column 20
; ESC[96m    = bright cyan foreground
pos_msg: db 27,'[10;20H',27,'[96m','Hello from row 10, col 20!',27,'[0m',0

print:
    mov a, m
    inx h
    cpi 0
    rz
    out 11h
    jmp print
```

### Example 6: Inverse video and strikethrough

{:.code-example}
```
    lxi h, inverse_msg
    call print
    lxi h, newline
    call print
    lxi h, strike_msg
    call print
    hlt

; ESC[7m = inverse (swaps foreground and background)
inverse_msg: db 27,'[7m','Inverse video',27,'[0m',0
newline: db 10,13,0
; ESC[9m = strikethrough
strike_msg: db 27,'[9m','Strikethrough text',27,'[0m',0

print:
    mov a, m
    inx h
    cpi 0
    rz
    out 11h
    jmp print
```

## ANSI escape sequence quick reference

For convenience, here is a quick reference of the most useful sequences when programming for the VT100 terminal with
the Altair8800. The full reference is available in the [VT100 terminal documentation]({{ site.baseurl }}/brainduck/terminal).

|---
| Sequence | Description
|-|-
| `ESC[0m`  | Reset all attributes
| `ESC[1m`  | Bold
| `ESC[4m`  | Underline
| `ESC[7m`  | Inverse video
| `ESC[30m`–`ESC[37m` | Set foreground color (black, red, green, yellow, blue, magenta, cyan, white)
| `ESC[40m`–`ESC[47m` | Set background color
| `ESC[90m`–`ESC[97m` | Set bright foreground color
| `ESC[2J`  | Clear entire screen
| `ESC[H`   | Move cursor to home (top-left)
| `ESC[row;colH` | Move cursor to specific position
| `ESC[Pt;Pbr` | Set scrolling region (DECSTBM) from row `Pt` to row `Pb` (1-based; cursor moves to home)
|---

Escape character (ESC) has ASCII code `27` (decimal) or `1Bh` (hexadecimal).

