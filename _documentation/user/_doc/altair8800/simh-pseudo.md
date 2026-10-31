---
layout: default
title: Device "simh-pseudo"
nav_order: 15
parent: MITS Altair8800
permalink: /altair8800/simh-pseudo
---

{% include analytics.html category="Altair8800" %}

# Pseudo-device "simh-pseudo"

This device is originally implemented as permanently connected to 88-SIO device in [simh][simh]{:target="_blank"} emulator.
It listens to custom, non-standard commands from operating system thus simplifies communication between emulator (host) and
running guest system. This device is required if you want to run CP/M operating system images made for simh emulator.

## Connections and configuration

Connect the plugin to an `8080-cpu` or `z80-cpu` context, `byte-mem`, and `88-ptr-ptp`. All three connections are
required at initialization, including the paper tape device when the guest does not use tape commands. The CPU port
is fixed at `FEh`. There are no plugin-specific configuration keys.

## GUI and settings

This device has no GUI or settings dialog. Guest software controls it through CPU port `FEh`.

This plugin implements the commands listed below; it is not a complete SIMH monitor. Commands 19 and 20 do not replace
the CPU plugin. Select the desired CPU in the virtual-computer configuration.

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
3       | N/A        | N/A          | rewind the attached PTR tape
4       | N/A        | 1 byte       | attach the PTR to the file named at the beginning of the CP/M command line; returns `0` on success or `1` on failure
5       | N/A        | N/A          | detach the PTR file
6       | N/A        | 8 bytes (`"SIMH004\0"`) | get the current version of the SIMH pseudo device
7       | N/A        | 6 bytes      | get the current time in ZSDOS format, all BCD values: byte 0: year modulo 100, byte 1: month, byte 2: day, byte 3: hour, byte 4: minute, byte 5: second
8       | 2 bytes (address of a 6-byte block in memory representing ZSDOS time in format YY MM DD HH MM SS) | N/A          | set the current time in ZSDOS format: reads the time from given address
9       | N/A        | 5 bytes      | get the current time in CP/M 3 format: bytes 0-1: days since 31 Dec 1977 (16-bit little endian), bytes 2-4: BCD values for hour, minute, second
10      | 2 bytes (address of a 5-byte block in memory representing CP/M 3 time in format: 0-1: days since 31 Dec 77, 2: HH, 3: MM, 4: SS)    | N/A | set the current time in CP/M 3 format: reads the time from given address
11      | N/A        | 1 byte       | get the selected bank
12      | 1 byte     | N/A          | set the selected bank
13      | N/A        | 2 bytes      | get the base address of the common memory segment
14      | N/A        | N/A          | clear the current command, timer stack, and host filenames list
15      | N/A        | N/A          | show time difference to timer on top of stack on stdout, in milliseconds (does not pop the timer)
16      | N/A        | 1 byte       | attach the PTP to the file named at the beginning of the CP/M command line; returns `0` on success or `1` on failure
17      | N/A        | N/A          | detach the PTP file
18      | N/A        | 1 byte       | determines whether machine has banked memory (returns number of memory banks)
19      | N/A        | N/A          | set the CPU to a Z80 (NOT IMPLEMENTED)
20      | N/A        | N/A          | set the CPU to an 8080 (NOT IMPLEMENTED)
21      | N/A        | N/A          | start timer interrupts
22      | N/A        | N/A          | stop timer interrupts
23      | 2 bytes    | N/A          | set the timer interval in which interrupts occur (in milliseconds; default 100 ms; value 0 restores the default)
24      | 2 bytes    | N/A          | set the address to call by timer interrupts (default `0xFC00`)
25      | N/A        | N/A          | reset the millisecond stop watch (starts counting from zero)
26      | N/A        | 4 bytes      | read the millisecond stop watch (32-bit elapsed time since last reset, in milliseconds)
27      | N/A        | N/A          | let emulation sleep for 1 millisecond (skipped when timer interrupts are active)
28      | N/A        | 1 byte       | obtain the file path separator of the OS under which emuStudio runs
29      | N/A        | file names separated by 0, ends with double 0 | perform wildcard expansion and obtain list of file names
30      | URL (N bytes terminated with 0) | max 1024 byte pairs (URL content) in form `availability, data` (when `availability` is 1 the `data` byte is valid) until `availability` is 0 | read the contents of a URL
31      | N/A        | 4 bytes      | get the clock frequency of the CPU (32-bit value in kHz)
32      | 4 bytes    | N/A          | set the clock frequency of the CPU (32-bit value in kHz). To take effect, the CPU must be paused and run again.
33      | 2 bytes (byte 0: (unused) interrupt vector, byte 1: interrupt data byte, an `RST` instruction) | N/A | generate interrupt
|---

### Command details

#### Host time and version (commands 0, 6-10)

Command 0 prints host time to standard output; it returns no guest bytes. Command 6 returns the eight bytes
`53h 49h 4Dh 48h 30h 30h 34h 00h` (`SIMH004` followed by NUL). Consume all eight reads.

Commands 7 and 9 read the host clock, with separate guest offsets for the ZSDOS and CP/M 3 clocks. Reads use UTC.
A BCD byte holds two decimal digits: for example, 23 is `23h`, not decimal byte 23. CP/M 3 day 0 is **31 December
1977**, and day 1 is 1 January 1978; only its hour, minute, and second bytes are BCD.

For commands 8 and 10, write the low and high bytes of a guest memory address containing the corresponding time block.
These commands adjust a guest offset and do not change the host operating-system clock. ZSDOS years `00`–`49` mean
2000–2049; `50`–`99` mean 1950–1999. Supply valid dates and a block entirely within memory. The setters currently
calculate their offset against host local time, so on a host outside UTC their subsequent UTC reads can differ by the
host timezone offset. The CP/M 3 setter also interprets its day bytes as signed Java bytes; values with a high bit set
in either byte do not round-trip correctly.

#### Banked memory (commands 11-13, 18)

Command 11 reads the active bank index, command 12 selects the bank given by its next output byte, command 13 reads
the two-byte common boundary, and command 18 reads the bank count. Bank indices start at 0. Select only banks below
`banksCount`; one bank is the normal unbanked configuration. Configure banks and the common region in
[byte-mem]({{ site.baseurl }}/altair8800/byte-mem#memory-bank-switching). Commands 11, 13, and 18 do not select a bank.
The count is returned in one byte, so configurations of 256 or more banks cannot report their full count this way.

#### Paper tape commands (3-5, 16, 17)

Connect `simh-pseudo` to an `88-ptr-ptp` device in addition to its CPU and memory connections. Attach commands 4 and
16 read a host file name from the beginning of the CP/M command line at `0080h`. The file name is resolved by the host
and the command returns one status byte: `0` after a successful attach and `1` after an invalid name or I/O failure.
Command 3 rewinds the current reader file; commands 5 and 17 close and detach the corresponding file.

The CP/M tail has its length byte at `0080h`, a leading separator at `0081h`, and file-name characters from `0082h`.
These commands skip the separator and use the remaining tail as the path. Relative names resolve against the host
working directory. Attaching the punch **creates or truncates** the output file; it does not append.

#### Timer stack (commands 1, 2, 15)

Commands 1, 2 and 15 use a shared timer stack with a maximum depth of **10 entries**. Command 1 pushes the current
timestamp onto the stack. Command 2 pops the top entry and prints the elapsed time to stdout. Command 15 peeks at the
top entry (without popping) and prints the elapsed time to stdout. If the stack overflows (more than 10 active timers),
the push is silently ignored and a warning is printed to stdout.

#### Timer interrupts (commands 21-24)

When timer interrupts are started (command 21), the device checks elapsed host time periodically while CPU cycles are dispatched and generates a `CALL addr` interrupt
(opcode `0xCD` followed by the low and high byte of the handler address) when the configured timer interval elapses.
The interrupt handler address defaults to `0xFC00` and can be changed with command 24. The timer interval defaults to
**100 ms** and can be changed with command 23 (a value of 0 restores 100 ms).

{: .note }
> For Z80, use interrupt mode 0; the 8080 also accepts this three-byte `CALL addr` interrupt. Initialize a stack in
> writable memory, enable CPU interrupts with `EI`, and preserve registers in the handler. Re-enable interrupts before
> returning if repeated interrupts are needed. These are host-time interrupts, not cycle-exact timers.

#### Stop watch (commands 25, 26)

The stop watch measures host wall-clock time and is independent from the timer stack. Command 25 records the current timestamp (resetting the stop watch).
Command 26 reads the elapsed time since the last reset as a **32-bit** value in milliseconds. The value is returned in
little-endian order (4 reads: byte 0 = low, byte 3 = high).

#### CPU clock frequency (commands 31, 32)

The CPU clock frequency is a **32-bit** value in **kHz**. Command 31 returns it in little-endian order (4 reads), and
command 32 expects it in little-endian order (4 writes). Use a positive value no greater than `7FFFFFFFh`.
For example, 2 MHz is 2000 kHz: write `D0h 07h 00h 00h`. Pause and resume the CPU for a running emulation to
use its new frequency.

#### Host sleep and path separator (commands 27, 28)

Command 27 sleeps the emulation thread for approximately 1 ms, unless timer interrupts are active. Command 28 returns
one byte: the host file separator (`/` on Unix-like hosts, `\` on Windows). Neither command converts guest file paths.

#### File-name expansion (command 29)

Place a host path or wildcard pattern in the same CP/M command-tail layout used by attach commands. The device scans
its host directory and returns matching file names with the supplied directory prefix, each followed by NUL. A further NUL terminates the list; if
there are no matches, the first read is NUL. Ordering is unspecified. Patterns use the host Java directory-glob syntax,
rather than CP/M's fixed-width filename matching. The tail length is limited to 127 bytes, leaving at most 126 path characters
after the skipped separator. Consume the terminating NUL before issuing another read-dependent command.

#### URL text (command 30)

After command 30, write the URL bytes and a terminating `00h`. The plugin stores at most 1023 URL bytes and ignores
additional bytes until NUL. Fetching occurs synchronously after NUL, with connection and read timeouts of 10 seconds.

Read an availability byte. If it is `01h`, read one data byte and repeat; if it is `00h`, the response has ended and
there is **no following data byte**. Only the first 1024 text characters are returned. The host decodes the response
as text, normalizes its line endings to LF, and emits each character's low byte. This command does not preserve binary
files or arbitrary Unicode text. A failed request returns diagnostic text through the same stream, rather than a
separate failure status.

#### Software interrupt (command 33)

Write two bytes after the command: an unused vector byte, then the interrupt data/opcode byte. For an 8080 or a Z80
in mode 0, an `RST` opcode such as `FFh` requests `RST 7`. The CPU must have interrupts enabled. This command does
not bypass `DI`, initialize the stack, or change the Z80 interrupt mode.

#### Reset command (14)

Command 14 clears command processing, the timer stack, and the file-name iterator. It does not restore the CPU
frequency, stop timer interrupts, detach tapes, or reset the guest clock offsets. A full device reset through
emuStudio resets the other command state as well.

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


Complete each command's parameter writes and result reads before starting another command. While a command is waiting
for parameter bytes, an `OUT` containing 14 is a **parameter**, not a reset command. Finish the packet (including the
NUL for command 30) before sending command 14, or reset the device through emuStudio. Reading while no command is active
returns `00h`; unknown command numbers are logged and ignored.

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
;   31 - get CPU clock frequency (4 bytes, 32-bit little-endian kHz)

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
freq_msg: db "CPU kHz:  0x", 0
hz_msg:   db "h", 0
freq:     db 0, 0, 0, 0
```

When run, the output might look like:

```
Version: SIMH004
Time:    26/03/21 14:05:33
Bank:    0
CPU kHz:  0x000007D0h
```

The CPU frequency `0x000007D0` is 2,000 kHz (2 MHz).

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
