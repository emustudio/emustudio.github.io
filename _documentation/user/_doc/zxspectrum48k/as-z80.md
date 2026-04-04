---
layout: default
title: Assembler "as-z80"
nav_order: 1
parent: ZX Spectrum 48K
permalink: /zxspectrum48k/as-z80
---

{% include analytics.html category="ZXSpectrum48K" %}

# Assembler "as-z80"

The ZX Spectrum 48K uses the same Z80 assembler plugin as the [MITS Altair8800]({{ site.baseurl }}/altair8800/as-z80).
Please refer to the [as-z80 documentation]({{ site.baseurl }}/altair8800/as-z80) for the complete assembler reference,
including:

- Lexical symbols and constants
- Instruction syntax and address modes
- Expressions and operators
- Data definition (`DB`, `DW`, `DS`)
- Including other source files
- Origin address (`ORG`)
- Constants (`EQU`) and variables (`VAR`)
- Conditional assembly (`IF`/`ENDIF`)
- Macros (`MACRO`/`ENDM`)
- `END` pseudo-instruction

## Running from the command line

The assembler can be run independently:

- on Linux:
```
> bin/as-z80 [--output output_file.hex] [source_file.asm]
```

- on Windows:
```
> bin\as-z80.bat [--output output_file.hex] [source_file.asm]
```

## ZX Spectrum specific notes

When writing assembly for the ZX Spectrum, keep the following in mind:

- Programs should be assembled to start at address `0x8000` (32768) or higher, since addresses `0x0000`–`0x3FFF` are
  ROM and `0x4000`–`0x5AFF` are screen/attribute memory.
- The ULA is accessed through port `0xFE` (254). Writing controls border colour and audio; reading returns keyboard
  state.
- The ROM `BEEP` routine is available at address `0x03B5` (if the 48K ROM is loaded).
- The standard program entry point from BASIC is `RANDOMIZE USR <address>`.

### Example: Simple beeper tone

{:.code-example}
```
org 8000H

BEEPER_PORT equ 0FEH
BEEPER_ON   equ 10H    ; EAR bit on
BEEPER_OFF  equ 08H    ; EAR bit off

start:
    ld b, 255           ; number of half-waves

play_loop:
    ld a, BEEPER_ON
    out (BEEPER_PORT), a

    ld de, 200          ; half-period delay
delay1:
    dec de
    ld a, d
    or e
    jr nz, delay1

    ld a, BEEPER_OFF
    out (BEEPER_PORT), a

    ld de, 200
delay2:
    dec de
    ld a, d
    or e
    jr nz, delay2

    djnz play_loop

    halt
```


