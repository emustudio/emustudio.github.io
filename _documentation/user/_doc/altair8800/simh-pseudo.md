---
layout: default
title: Device "simh-pseudo"
nav_order: 9
parent: MITS Altair8800
permalink: /altair8800/simh-pseudo
---

{% include analytics.html category="Altair8800" %}

# Pseudo-device "simh-pseudo"

This device is originally implemented as permanently connected to 88-SIO device in [simh][simh]{:target="_blank"} emulator.
It listens to custom, non-standard commands from operating system thus simplifies communication between emulator (host) and
running guest system. This device is required if you want to run CP/M operating system images made for simh emulator.

## Programming

SIMH-pseudo device can be pretty useful also for users of emuStudio. Z80 or 8080 programs communicate with it via 
port `0xFE`.

Some commands sent to the port require parameters, in which case there must be sent multiple bytes. If a command returns
anything, the returned value can be read using `IN` instruction. 

### List of commands

In case of multibyte parameters or return value, if it's a numeric value it's always in a form of little endian.

|---
Command | Parameters | Return value | Description
|-|-|-|-
0       | N/A        | N/A          | print the current time on stdout, in milliseconds
1       | N/A        | N/A          | start a new timer on the top of the timer stack (max depth 10)
2       | N/A        | N/A          | stop timer on top of timer stack and print time difference on stdout, in milliseconds
3       | N/A        | N/A          | reset the PTR device (NOT IMPLEMENTED)
4       | N/A        | N/A          | attach the PTR device (NOT IMPLEMENTED)
5       | N/A        | N/A          | detach the PTR device (NOT IMPLEMENTED)
6       | N/A        | 8 bytes (`"SIMH004\0"`) | get the current version of the SIMH pseudo device
7       | N/A        | 6 bytes      | get the current time in ZSDOS format, all BCD values: byte 0: year modulo 100, byte 1: month, byte 2: day, byte 3: hour, byte 4: minute, byte 5: second
8       | 2 bytes (address of a 6-byte block in memory representing ZSDOS time in format YY MM DD HH MM SS) | N/A          | set the current time in ZSDOS format: reads the time from given address
9       | N/A        | 5 bytes      | get the current time in CP/M 3 format: bytes 0-1: days since 1 Jan 1978 (16-bit little endian), bytes 2-4: BCD values for hour, minute, second
10      | 2 bytes (address of a 5-byte block in memory representing CP/M 3 time in format: 0-1: days since 31 Dec 77, 2: HH, 3: MM, 4: SS)    | N/A | set the current time in CP/M 3 format: reads the time from given address
11      | N/A        | 1 byte       | get the selected bank
12      | 1 byte     | N/A          | set the selected bank
13      | N/A        | 2 bytes      | get the base address of the common memory segment
14      | N/A        | N/A          | reset the SIMH-pseudo device (clears "undefined" state, resets timer stack and host filenames list)
15      | N/A        | N/A          | show time difference to timer on top of stack on stdout, in milliseconds (does not pop the timer)
16      | N/A        | 1 byte       | attach PTP device to the file with name at beginning of CP/M command line (NOT IMPLEMENTED)
17      | N/A        | N/A          | detach PTP device (NOT IMPLEMENTED)
18      | N/A        | 1 byte       | determines whether machine has banked memory (returns number of memory banks)
19      | N/A        | N/A          | set the CPU to a Z80 (NOT IMPLEMENTED)
20      | N/A        | N/A          | set the CPU to an 8080 (NOT IMPLEMENTED)
21      | N/A        | N/A          | start timer interrupts
22      | N/A        | N/A          | stop timer interrupts
23      | 2 bytes    | N/A          | set the timer interval in which interrupts occur (in milliseconds; default 100 ms; value 0 is ignored)
24      | 2 bytes    | N/A          | set the address to call by timer interrupts (default `0xFC00`)
25      | N/A        | N/A          | reset the millisecond stop watch (starts counting from zero)
26      | N/A        | 4 bytes      | read the millisecond stop watch (32-bit elapsed time since last reset, in milliseconds)
27      | N/A        | N/A          | let emulation sleep for 1 millisecond (skipped when timer interrupts are active)
28      | N/A        | 1 byte       | obtain the file path separator of the OS under which emuStudio runs
29      | N/A        | file names separated by 0, ends with double 0 | perform wildcard expansion and obtain list of file names
30      | URL (N bytes terminated with 0) | max 1024 byte pairs (URL content) in form `availability, data` (when `availability` is 1 the `data` byte is valid) until `availability` is 0 | read the contents of a URL
31      | N/A        | 4 bytes      | get the clock frequency of the CPU (32-bit value in Hz)
32      | 4 bytes    | N/A          | set the clock frequency of the CPU (32-bit value in Hz). To take effect, the CPU must be paused and run again.
33      | 2 bytes (byte 0: (unused) interrupt vector, byte 1: interrupt data byte, an `RST` instruction) | N/A | generate interrupt
|---

### Command details

#### Timer stack (commands 1, 2, 15)

Commands 1, 2 and 15 use a shared timer stack with a maximum depth of **10 entries**. Command 1 pushes the current
timestamp onto the stack. Command 2 pops the top entry and prints the elapsed time to stdout. Command 15 peeks at the
top entry (without popping) and prints the elapsed time to stdout. If the stack overflows (more than 10 active timers),
the push is silently ignored and a warning is printed to stdout.

#### Timer interrupts (commands 21-24)

When timer interrupts are started (command 21), the device monitors CPU cycles and generates a `CALL addr` interrupt
(opcode `0xCD` followed by the low and high byte of the handler address) when the configured timer interval elapses.
The interrupt handler address defaults to `0xFC00` and can be changed with command 24. The timer interval defaults to
**100 ms** and can be changed with command 23 (a value of 0 is ignored and the default is used instead).

{: .note }
> Timer interrupts work only in interrupt mode 0 of the CPU. The interrupt is delivered as a 3-byte `CALL addr`
> instruction on the data bus.

#### Stop watch (commands 25, 26)

The stop watch is independent from the timer stack. Command 25 records the current timestamp (resetting the stop watch).
Command 26 reads the elapsed time since the last reset as a **32-bit** value in milliseconds. The value is returned in
little-endian order (4 reads: byte 0 = low, byte 3 = high).

#### CPU clock frequency (commands 31, 32)

The CPU clock frequency is a **32-bit** value in Hz. Command 31 returns it in little-endian order (4 reads), and
command 32 expects it in little-endian order (4 writes).

### How to call a command

Calling a command always starts with an `OUT` instruction:

{:.code-example}
```
ld  a, <cmd>  ; replace "<cmd>" with command number
out (0xFE), a
```

Then, if a command requires a parameter, it must be supplied with additional `OUT` instruction(s), depending on how many
bytes are expected, as follows:

{:.code-example}
```
ld a, <param0>  ; replace "<param0>" with parameter byte 0
out (0xFE), a
ld a, <param1>  ; replace "<param1>" with parameter byte 1
out (0xFE), a
...              ; etc.
```

After last parameter is recognized by SIMH-pseudo device, the command is executed. Then, if the command returns a
result, it must be read with `IN` instructions, depending on how many bytes are to be returned, as follows:

{:.code-example}
```
in a, (0xFE)    ; register A contains first byte of result
...             ; save the byte somewhere
in a, (0xFE)    ; register A contains second byte of result
```


Note: The program must send/receive all bytes. Otherwise, the device will stay in a state when it "expects" the rest of
parameter bytes, or result bytes to be read. It is however possible to "reset" the device by sending a reset command 
to the device (command 14).

## Examples

The following examples are written in as-z80 assembler dialect for the Altair8800 Z80 configuration. They output text
to the terminal via 88-SIO (status port `0x10`, data port `0x11`).

### Example: Status page

This program reads and displays the SIMH-pseudo device version, current time in ZSDOS format, selected memory bank, and
CPU clock frequency.

{:.code-example}
```
; Status Page - reads information from SIMH-pseudo and displays it
; Assembler: as-z80, Computer: Altair8800 (Z80)
;
; SIMH-pseudo commands used:
;   6  - get SIMH version (8 bytes, null-terminated ASCII)
;   7  - get time in ZSDOS format (6 BCD bytes: YY MM DD HH MM SS)
;   11 - get selected bank (1 byte)
;   31 - get CPU clock frequency (4 bytes, 32-bit little-endian Hz)

SIOSTA  equ 0x10            ; 88-SIO status port
SIODAT  equ 0x11            ; 88-SIO data port
SIMH    equ 0xFE            ; SIMH-pseudo device port

        org 0
        ld sp, 0xFF00       ; set up stack

        ; --- Print SIMH Version ---
        ld hl, ver_msg
        call puts
        ld a, 6             ; cmd 6: get SIMH version
        out (SIMH), a
ver_lp: in a, (SIMH)        ; read next version byte
        or a                ; null terminator?
        jr z, ver_end
        call putch
        jr ver_lp
ver_end:
        call crlf

        ; --- Print Current Time (ZSDOS) ---
        ld hl, time_msg
        call puts
        ld a, 7             ; cmd 7: get clock ZSDOS
        out (SIMH), a
        in a, (SIMH)        ; byte 0: year (BCD)
        call putbcd
        ld a, "/"
        call putch
        in a, (SIMH)        ; byte 1: month (BCD)
        call putbcd
        ld a, "/"
        call putch
        in a, (SIMH)        ; byte 2: day (BCD)
        call putbcd
        ld a, " "
        call putch
        in a, (SIMH)        ; byte 3: hour (BCD)
        call putbcd
        ld a, ":"
        call putch
        in a, (SIMH)        ; byte 4: minute (BCD)
        call putbcd
        ld a, ":"
        call putch
        in a, (SIMH)        ; byte 5: second (BCD)
        call putbcd
        call crlf

        ; --- Print Memory Bank ---
        ld hl, bank_msg
        call puts
        ld a, 11            ; cmd 11: get bank select
        out (SIMH), a
        in a, (SIMH)        ; 1 byte: bank number
        call putd8
        call crlf

        ; --- Print CPU Frequency ---
        ld hl, freq_msg
        call puts
        ld a, 31            ; cmd 31: get CPU clock frequency
        out (SIMH), a
        in a, (SIMH)        ; byte 0 (low byte)
        ld (freq), a
        in a, (SIMH)        ; byte 1
        ld (freq+1), a
        in a, (SIMH)        ; byte 2
        ld (freq+2), a
        in a, (SIMH)        ; byte 3 (high byte)
        ld (freq+3), a
        ; display 32-bit value as hex, high byte first
        ld a, (freq+3)
        call puthex
        ld a, (freq+2)
        call puthex
        ld a, (freq+1)
        call puthex
        ld a, (freq)
        call puthex
        ld hl, hz_msg
        call puts
        call crlf

        halt

; ==== Subroutines ====

; Print character in A to terminal
putch:  push af
putchw: in a, (SIOSTA)
        and 2               ; bit 1 = transmitter ready
        jr z, putchw
        pop af
        out (SIODAT), a
        ret

; Print null-terminated string at HL
puts:   ld a, (hl)
        or a
        ret z
        call putch
        inc hl
        jr puts

; Print CR+LF
crlf:   ld a, 0x0D
        call putch
        ld a, 0x0A
        call putch
        ret

; Print BCD byte in A as two decimal digits
putbcd: push af
        rrca
        rrca
        rrca
        rrca
        and 0x0F
        add a, "0"
        call putch
        pop af
        and 0x0F
        add a, "0"
        call putch
        ret

; Print byte in A as two hex digits
puthex: push af
        rrca
        rrca
        rrca
        rrca
        and 0x0F
        call hexnib
        pop af
        and 0x0F
        call hexnib
        ret
hexnib: cp 10
        jr c, hexdig
        add a, "A" - 10
        call putch
        ret
hexdig: add a, "0"
        call putch
        ret

; Print byte in A as decimal (0-255), no leading zeros
putd8:  ld b, 0             ; leading zero flag
        ld c, 100
        call putd8d
        ld c, 10
        call putd8d
        add a, "0"          ; always print ones digit
        call putch
        ret
putd8d: ld d, 0
putd8l: cp c
        jr c, putd8p
        sub c
        inc d
        jr putd8l
putd8p: push af
        ld a, d
        or b
        jr z, putd8s        ; skip leading zero
        ld b, 1
        ld a, d
        add a, "0"
        call putch
putd8s: pop af
        ret

; ==== Data ====

ver_msg:  db "Version: ", 0
time_msg: db "Time:    ", 0
bank_msg: db "Bank:    ", 0
freq_msg: db "CPU Hz:  0x", 0
hz_msg:   db "h", 0
freq:     db 0, 0, 0, 0
```

When run, the output might look like:

```
Version: SIMH004
Time:    26/03/21 14:05:33
Bank:    0
CPU Hz:  0x001E8480h
```

The CPU frequency `0x001E8480` is 2,000,000 Hz (2 MHz).

### Example: Stopwatch

This program resets the millisecond stop watch, performs a busy loop to simulate work, then reads and displays the
elapsed time in milliseconds.

{:.code-example}
```
; Stopwatch - measures elapsed time of a busy loop
; Assembler: as-z80, Computer: Altair8800 (Z80)
;
; SIMH-pseudo commands used:
;   25 - reset the millisecond stop watch (starts counting)
;   26 - read the millisecond stop watch (4 bytes, 32-bit LE, ms)

SIOSTA  equ 0x10            ; 88-SIO status port
SIODAT  equ 0x11            ; 88-SIO data port
SIMH    equ 0xFE            ; SIMH-pseudo device port

        org 0
        ld sp, 0xFF00       ; set up stack

        ; --- Reset (start) the stop watch ---
        ld hl, start_msg
        call puts

        ld a, 25            ; cmd 25: reset stop watch
        out (SIMH), a

        ; --- Do some work (busy loop, 65536 iterations) ---
        ld bc, 0            ; BC = 65536 (wraps from 0)
delay:  dec bc
        ld a, b
        or c
        jr nz, delay

        ; --- Read the stop watch ---
        ld a, 26            ; cmd 26: read stop watch
        out (SIMH), a
        in a, (SIMH)        ; byte 0 (low byte)
        ld (elapsed), a
        in a, (SIMH)        ; byte 1
        ld (elapsed+1), a
        in a, (SIMH)        ; byte 2 (must read all 4 bytes)
        in a, (SIMH)        ; byte 3

        ; --- Display elapsed time ---
        ld hl, result_msg
        call puts
        ld a, (elapsed+1)   ; load lower 16 bits into HL
        ld h, a
        ld a, (elapsed)
        ld l, a
        call putd16          ; print HL as decimal
        ld hl, ms_msg
        call puts
        call crlf

        halt

; ==== Subroutines ====

; Print character in A to terminal
putch:  push af
putchw: in a, (SIOSTA)
        and 2               ; bit 1 = transmitter ready
        jr z, putchw
        pop af
        out (SIODAT), a
        ret

; Print null-terminated string at HL
puts:   ld a, (hl)
        or a
        ret z
        call putch
        inc hl
        jr puts

; Print CR+LF
crlf:   ld a, 0x0D
        call putch
        ld a, 0x0A
        call putch
        ret

; Print 16-bit value in HL as decimal, no leading zeros
putd16: ld b, 0             ; leading zero suppression flag
        ld de, 10000
        call pd16d
        ld de, 1000
        call pd16d
        ld de, 100
        call pd16d
        ld de, 10
        call pd16d
        ld a, l             ; ones digit, always printed
        add a, "0"
        call putch
        ret
pd16d:  ld c, 0             ; digit counter
pd16dl: or a                ; clear carry
        sbc hl, de
        jr c, pd16dd
        inc c
        jr pd16dl
pd16dd: add hl, de          ; restore HL (went one too far)
        ld a, c
        or b                ; any non-zero digit printed yet?
        ret z               ; skip leading zero
        ld b, 1             ; mark: we printed a digit
        ld a, c
        add a, "0"
        call putch
        ret

; ==== Data ====

start_msg:  db "Stopwatch started...", 0x0D, 0x0A, 0
result_msg: db "Elapsed: ", 0
ms_msg:     db " ms", 0
elapsed:    db 0, 0
```

When run, the output might look like:

```
Stopwatch started...
Elapsed: 42 ms
```

The actual elapsed time depends on the configured CPU clock frequency.

[simh]: http://simh.trailing-edge.com/
