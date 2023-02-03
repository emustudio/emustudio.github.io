---
layout: default
title: CPU "z80-cpu"
nav_order: 4
parent: MITS Altair8800
permalink: /altair8800/z80-cpu
---

{% include analytics.html category="Altair8800" %}

# Zilog Z80 CPU emulator

It was possible to upgrade your Altair 8800 computer with a "better" 8-bit processor [Zilog Z80][z80]{:target="_blank"}.
The processor was probably the most used 8-bit processor in the '80s. It was backward compatible with 8080 and brought
many enhancements. It was originally targeted for embedded systems, but it became popular very soon. Z80 was used for
all
kinds of computers - including desktop computers, arcade games, etc. Today the CPU is still used in some MP3 players,
see e.g. [S1 MP3 Player][mp3]{:target="_blank"}.

Main features of the emulator include:

* Interpretation as an emulation technique,
* Correct real timing of instructions,
* Ability to set clock frequency manually at run-time,
* Emulation of all instructions including interrupts,
* Disassembler implementation,
* Ability to "dump" instruction history to console at run-time,
* Support of breakpoints,
* The ability of communication with up to 256 I/O devices,
* Status window shows all registers, flags, and run-time frequency.

## Configuration file

The following table shows all the possible settings of Zilog Z80 CPU plugin:

|---
|Name | Default value | Valid values | Description
|-|-|-|-
|`printCode`       | false | true / false | Whether the emulator should print executed instructions, and its internal state to console (dump)
|`printCodeUseCache`| false | true / false | If `printCode` is set to `true`, then a cache will be used which remembers already visited blocks of code so the instruction dump will not be bloated with infinite loops
|`frequency_khz` | 4000 | > 0 | CPU frequency set on emuStudio startup (it can be changed in runtime, but won't be saved in settings)
|---

## Dumping executed instructions

The CPU offers a unique feature, which is the ability to dump executed instructions as a sequence to the console.
When enabled, then each executed instruction - together with the content of flags and register values after the
execution is printed. This feature might be extremely useful in two cases:

1. Reverse engineering of some unknown software
2. It allows us to build tools for automatic checking of register values during the emulation when performing automatic
   emulation.

To enable this feature, please see the section "Configuration file".

For example, let's take an example which computes a reverse text:

{:.code-example}
```
; Print reversed text

org 1000

dec sp       ; stack initialization (0FFFFh)

ld hl,text1
call putstr  ; print text1
ld de,input  ; address for string input
call getline ; read from keyboard

ld bc,input

ld d,0      ; chars counter

char_loop:
ld a, (bc)
inc bc        ; bc = bc+1
cp 10       ; end of input?
jp z, char_end
cp 13
jp z, char_end

inc d        ; d =d+1
jp char_loop
char_end:

dec bc        ;  bc = bc-1
dec bc

call newline

char2_loop:
ld a, (bc)
call putchar

dec bc

dec d
jp z, char2_end

jp char2_loop
char2_end:

halt

include "include\getchar.inc"
include "include\getline.inc"
include "include\putstr.inc"
include "include\putchar.inc"
include "include\newline.inc"

text1: db "Reversed text ...",10,13,"Enter text: ",0
text2: db 10,13,"Reversed: ",0
input: ds 30
```

When the program is being run, and the dump instructions feature is turned on, on console you can see the following
output:

{:.code-example}
```
0000 | PC=03e8 |          dec SP |        3B  || regs=00 00 00 00 00 00 00 00  IX=0000 IY=0000 IFF=0 I=00 R=01 | flags=       | SP=ffff | PC=03e9
0001 | PC=03e9 |      ld HL, 485 |  21 85 04  || regs=00 00 00 00 04 85 00 00  IX=0000 IY=0000 IFF=0 I=00 R=02 | flags=       | SP=ffff | PC=03ec
0002 | PC=03ec |        call 46D |  CD 6D 04  || regs=00 00 00 00 04 85 00 00  IX=0000 IY=0000 IFF=0 I=00 R=03 | flags=       | SP=fffd | PC=046d
0002 | PC=046d |      ld A, (HL) |        7E  || regs=00 00 00 00 04 85 00 52  IX=0000 IY=0000 IFF=0 I=00 R=04 | flags=       | SP=fffd | PC=046e
0003 | PC=046e |          inc HL |        23  || regs=00 00 00 00 04 86 00 52  IX=0000 IY=0000 IFF=0 I=00 R=05 | flags=       | SP=fffd | PC=046f
0003 | PC=046f |            cp 0 |     FE 00  || regs=00 00 00 00 04 86 00 52  IX=0000 IY=0000 IFF=0 I=00 R=06 | flags=    N  | SP=fffd | PC=0471
0007 | PC=0471 |           ret Z |        C8  || regs=00 00 00 00 04 86 00 52  IX=0000 IY=0000 IFF=0 I=00 R=07 | flags=    N  | SP=fffd | PC=0472
0008 | PC=0472 |      out (11),A |     D3 11  || regs=00 00 00 00 04 86 00 52  IX=0000 IY=0000 IFF=0 I=00 R=08 | flags=    N  | SP=fffd | PC=0474
0008 | PC=0474 |          jp 46D |  C3 6D 04  || regs=00 00 00 00 04 86 00 52  IX=0000 IY=0000 IFF=0 I=00 R=09 | flags=    N  | SP=fffd | PC=046d
0009 | PC=046d |      ld A, (HL) |        7E  || regs=00 00 00 00 04 86 00 65  IX=0000 IY=0000 IFF=0 I=00 R=0a | flags=    N  | SP=fffd | PC=046e
0025 | Block from 0474 to 03EF; count=184
0025 | PC=03ef |      ld DE, 4B2 |  11 B2 04  || regs=00 00 04 b2 04 a5 00 00  IX=0000 IY=0000 IFF=0 I=00 R=42 | flags= Z  N  | SP=ffff | PC=03f2
0025 | PC=03f2 |        call 428 |  CD 28 04  || regs=00 00 04 b2 04 a5 00 00  IX=0000 IY=0000 IFF=0 I=00 R=43 | flags= Z  N  | SP=fffd | PC=0428
0025 | PC=0428 |         ld C, 0 |     0E 00  || regs=00 00 04 b2 04 a5 00 00  IX=0000 IY=0000 IFF=0 I=00 R=44 | flags= Z  N  | SP=fffd | PC=042a
0026 | PC=042a |        in A, 10 |     DB 10  || regs=00 00 04 b2 04 a5 00 02  IX=0000 IY=0000 IFF=0 I=00 R=45 | flags= Z  N  | SP=fffd | PC=042c
0026 | PC=042c |           and 1 |     E6 01  || regs=00 00 04 b2 04 a5 00 00  IX=0000 IY=0000 IFF=0 I=00 R=46 | flags= ZHP   | SP=fffd | PC=042e
0026 | PC=042e |       jp Z, 42A |  CA 2A 04  || regs=00 00 04 b2 04 a5 00 00  IX=0000 IY=0000 IFF=0 I=00 R=47 | flags= ZHP   | SP=fffd | PC=042a
0027 | PC=042a |        in A, 10 |     DB 10  || regs=00 00 04 b2 04 a5 00 02  IX=0000 IY=0000 IFF=0 I=00 R=48 | flags= ZHP   | SP=fffd | PC=042c
6323 | Block from 042E to 0431; count=1048716
6323 | PC=0431 |        in A, 11 |     DB 11  || regs=00 00 04 b2 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=54 | flags=  H    | SP=fffd | PC=0433
6323 | PC=0433 |            cp D |     FE 0D  || regs=00 00 04 b2 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=55 | flags=    N  | SP=fffd | PC=0435
6324 | PC=0435 |       jp Z, 461 |  CA 61 04  || regs=00 00 04 b2 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=56 | flags=    N  | SP=fffd | PC=0438
6324 | PC=0438 |            cp A |     FE 0A  || regs=00 00 04 b2 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=57 | flags=    N  | SP=fffd | PC=043a
6324 | PC=043a |       jp Z, 461 |  CA 61 04  || regs=00 00 04 b2 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=58 | flags=    N  | SP=fffd | PC=043d
6324 | PC=043d |            cp 8 |     FE 08  || regs=00 00 04 b2 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=59 | flags=    N  | SP=fffd | PC=043f
6324 | PC=043f |      jp NZ, 459 |  C2 59 04  || regs=00 00 04 b2 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=5a | flags=    N  | SP=fffd | PC=0459
6324 | PC=0459 |      out (11),A |     D3 11  || regs=00 00 04 b2 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=5b | flags=    N  | SP=fffd | PC=045b
6324 | PC=045b |      ld (DE), A |        12  || regs=00 00 04 b2 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=5c | flags=    N  | SP=fffd | PC=045c
6324 | PC=045c |          inc DE |        13  || regs=00 00 04 b3 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=5d | flags=    N  | SP=fffd | PC=045d
6325 | PC=045d |           inc C |        0C  || regs=00 01 04 b3 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=5e | flags=       | SP=fffd | PC=045e
6325 | PC=045e |          jp 42A |  C3 2A 04  || regs=00 01 04 b3 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=5f | flags=       | SP=fffd | PC=042a
6325 | PC=042a |        in A, 10 |     DB 10  || regs=00 01 04 b3 04 a5 00 02  IX=0000 IY=0000 IFF=0 I=00 R=60 | flags=       | SP=fffd | PC=042c
8683 | Block from 045E to 0461; count=440826
8683 | PC=0461 |         ld A, A |     3E 0A  || regs=00 04 04 b6 04 a5 00 0a  IX=0000 IY=0000 IFF=0 I=00 R=5a | flags= ZH N  | SP=fffd | PC=0463
8683 | PC=0463 |      ld (DE), A |        12  || regs=00 04 04 b6 04 a5 00 0a  IX=0000 IY=0000 IFF=0 I=00 R=5b | flags= ZH N  | SP=fffd | PC=0464
8683 | PC=0464 |          inc DE |        13  || regs=00 04 04 b7 04 a5 00 0a  IX=0000 IY=0000 IFF=0 I=00 R=5c | flags= ZH N  | SP=fffd | PC=0465
8683 | PC=0465 |         ld A, D |     3E 0D  || regs=00 04 04 b7 04 a5 00 0d  IX=0000 IY=0000 IFF=0 I=00 R=5d | flags= ZH N  | SP=fffd | PC=0467
8683 | PC=0467 |      ld (DE), A |        12  || regs=00 04 04 b7 04 a5 00 0d  IX=0000 IY=0000 IFF=0 I=00 R=5e | flags= ZH N  | SP=fffd | PC=0468
8684 | PC=0468 |          inc DE |        13  || regs=00 04 04 b8 04 a5 00 0d  IX=0000 IY=0000 IFF=0 I=00 R=5f | flags= ZH N  | SP=fffd | PC=0469
8684 | PC=0469 |         ld A, 0 |     3E 00  || regs=00 04 04 b8 04 a5 00 00  IX=0000 IY=0000 IFF=0 I=00 R=60 | flags= ZH N  | SP=fffd | PC=046b
8684 | PC=046b |      ld (DE), A |        12  || regs=00 04 04 b8 04 a5 00 00  IX=0000 IY=0000 IFF=0 I=00 R=61 | flags= ZH N  | SP=fffd | PC=046c
8684 | PC=046c |             ret |        C9  || regs=00 04 04 b8 04 a5 00 00  IX=0000 IY=0000 IFF=0 I=00 R=62 | flags= ZH N  | SP=ffff | PC=03f5
8684 | PC=03f5 |      ld BC, 4B2 |  01 B2 04  || regs=04 b2 04 b8 04 a5 00 00  IX=0000 IY=0000 IFF=0 I=00 R=63 | flags= ZH N  | SP=ffff | PC=03f8
8684 | PC=03f8 |         ld D, 0 |     16 00  || regs=04 b2 00 b8 04 a5 00 00  IX=0000 IY=0000 IFF=0 I=00 R=64 | flags= ZH N  | SP=ffff | PC=03fa
8684 | PC=03fa |      ld A, (BC) |        0A  || regs=04 b2 00 b8 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=65 | flags= ZH N  | SP=ffff | PC=03fb
8684 | PC=03fb |          inc BC |        03  || regs=04 b3 00 b8 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=66 | flags= ZH N  | SP=ffff | PC=03fc
8684 | PC=03fc |            cp A |     FE 0A  || regs=04 b3 00 b8 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=67 | flags=    N  | SP=ffff | PC=03fe
8684 | PC=03fe |       jp Z, 40A |  CA 0A 04  || regs=04 b3 00 b8 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=68 | flags=    N  | SP=ffff | PC=0401
8684 | PC=0401 |            cp D |     FE 0D  || regs=04 b3 00 b8 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=69 | flags=    N  | SP=ffff | PC=0403
8685 | PC=0403 |       jp Z, 40A |  CA 0A 04  || regs=04 b3 00 b8 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=6a | flags=    N  | SP=ffff | PC=0406
8685 | PC=0406 |           inc D |        14  || regs=04 b3 01 b8 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=6b | flags=       | SP=ffff | PC=0407
8685 | PC=0407 |          jp 3FA |  C3 FA 03  || regs=04 b3 01 b8 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=6c | flags=       | SP=ffff | PC=03fa
8685 | PC=03fa |      ld A, (BC) |        0A  || regs=04 b3 01 b8 04 a5 00 68  IX=0000 IY=0000 IFF=0 I=00 R=6d | flags=       | SP=ffff | PC=03fb
8685 | Block from 0407 to 040A; count=28
8685 | PC=040a |          dec BC |        0B  || regs=04 b6 04 b8 04 a5 00 0a  IX=0000 IY=0000 IFF=0 I=00 R=09 | flags= ZH N  | SP=ffff | PC=040b
8685 | PC=040b |          dec BC |        0B  || regs=04 b5 04 b8 04 a5 00 0a  IX=0000 IY=0000 IFF=0 I=00 R=0a | flags= ZH N  | SP=ffff | PC=040c
8685 | PC=040c |        call 47A |  CD 7A 04  || regs=04 b5 04 b8 04 a5 00 0a  IX=0000 IY=0000 IFF=0 I=00 R=0b | flags= ZH N  | SP=fffd | PC=047a
8685 | PC=047a |         ld A, A |     3E 0A  || regs=04 b5 04 b8 04 a5 00 0a  IX=0000 IY=0000 IFF=0 I=00 R=0c | flags= ZH N  | SP=fffd | PC=047c
8686 | PC=047c |        call 477 |  CD 77 04  || regs=04 b5 04 b8 04 a5 00 0a  IX=0000 IY=0000 IFF=0 I=00 R=0d | flags= ZH N  | SP=fffb | PC=0477
8686 | PC=0477 |      out (11),A |     D3 11  || regs=04 b5 04 b8 04 a5 00 0a  IX=0000 IY=0000 IFF=0 I=00 R=0e | flags= ZH N  | SP=fffb | PC=0479
8686 | PC=0479 |             ret |        C9  || regs=04 b5 04 b8 04 a5 00 0a  IX=0000 IY=0000 IFF=0 I=00 R=0f | flags= ZH N  | SP=fffd | PC=047f
8686 | PC=047f |         ld A, D |     3E 0D  || regs=04 b5 04 b8 04 a5 00 0d  IX=0000 IY=0000 IFF=0 I=00 R=10 | flags= ZH N  | SP=fffd | PC=0481
8686 | PC=0481 |        call 477 |  CD 77 04  || regs=04 b5 04 b8 04 a5 00 0d  IX=0000 IY=0000 IFF=0 I=00 R=11 | flags= ZH N  | SP=fffb | PC=0477
8686 | PC=0477 |      out (11),A |     D3 11  || regs=04 b5 04 b8 04 a5 00 0d  IX=0000 IY=0000 IFF=0 I=00 R=12 | flags= ZH N  | SP=fffb | PC=0479
8686 | Block from 0481 to 0484; count=2
8686 | PC=0484 |             ret |        C9  || regs=04 b5 04 b8 04 a5 00 0d  IX=0000 IY=0000 IFF=0 I=00 R=14 | flags= ZH N  | SP=ffff | PC=040f
8686 | PC=040f |      ld A, (BC) |        0A  || regs=04 b5 04 b8 04 a5 00 6a  IX=0000 IY=0000 IFF=0 I=00 R=15 | flags= ZH N  | SP=ffff | PC=0410
8686 | PC=0410 |        call 477 |  CD 77 04  || regs=04 b5 04 b8 04 a5 00 6a  IX=0000 IY=0000 IFF=0 I=00 R=16 | flags= ZH N  | SP=fffd | PC=0477
8686 | PC=0477 |      out (11),A |     D3 11  || regs=04 b5 04 b8 04 a5 00 6a  IX=0000 IY=0000 IFF=0 I=00 R=17 | flags= ZH N  | SP=fffd | PC=0479
8686 | Block from 0410 to 0413; count=2
8686 | PC=0413 |          dec BC |        0B  || regs=04 b4 04 b8 04 a5 00 6a  IX=0000 IY=0000 IFF=0 I=00 R=19 | flags= ZH N  | SP=ffff | PC=0414
8687 | PC=0414 |           dec D |        15  || regs=04 b4 03 b8 04 a5 00 6a  IX=0000 IY=0000 IFF=0 I=00 R=1a | flags=  H N  | SP=ffff | PC=0415
8687 | PC=0415 |       jp Z, 41B |  CA 1B 04  || regs=04 b4 03 b8 04 a5 00 6a  IX=0000 IY=0000 IFF=0 I=00 R=1b | flags=  H N  | SP=ffff | PC=0418
8687 | PC=0418 |          jp 40F |  C3 0F 04  || regs=04 b4 03 b8 04 a5 00 6a  IX=0000 IY=0000 IFF=0 I=00 R=1c | flags=  H N  | SP=ffff | PC=040f
8687 | PC=040f |      ld A, (BC) |        0A  || regs=04 b4 03 b8 04 a5 00 6f  IX=0000 IY=0000 IFF=0 I=00 R=1d | flags=  H N  | SP=ffff | PC=0410
8687 | Block from 0418 to 041B; count=23
8687 | PC=041b |            halt |        76  || regs=04 b1 00 b8 04 a5 00 61  IX=0000 IY=0000 IFF=0 I=00 R=34 | flags= ZH N  | SP=ffff | PC=041c
```

The dump format consists of lines, each line represents one instruction execution. The line is separated by `|` chars,
splitting it into so-called sections. Sections before the sequence `||` represent the state *before* instruction
execution,
and sections after it represent the state *after* instruction execution. Particular sections are described in the
following table.

|---
|Column | Description
|-|-
| 1 | Timestamp from program start (seconds)
| 2 | Program counter before instruction execution
| 3 | Disassembled instruction
| 4 | Instruction opcodes
| | Now follows the state *after* instruction execution
| 5 | Register values (`B`, `C`, `D`, `E`, `H`, `L`, reserved (always 0), `A`)
| 6 | Flags
| 7 | Stack pointer register (`SP`)
| 8 | Program counter after instruction execution
|---

## Testing the CPU

There are many Z80 testing frameworks online which can be used to test Z80 CPU emulator in emuStudio. This section
will list some tests and present how to use them.

### Patrik Rak's Z80 Test

As the author writes:

> This set of programs is intended to help the emulator authors reach the desired level of the CPU emulation authenticity.

The tests can be downloaded at [this link][z80test-raxoft]{:target="_blank"}. This test suite was designed for ZX Spectrum emulator
authors. That's why it expects ZX Spectrum memory map, and I/O devices. Since emuStudio does not currently emulate
ZX Spectrum, it is necessary to do some modifications to the original test suite to make it work.

Apply the following patch on top of commit `9f84881428c4257f9f429ab1ac00d1bae0623231`:

{:.code-example}
```
diff --git a/src/Makefile b/src/Makefile
index f9dac98..019e3de 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -7,7 +7,7 @@ PKG := $(NAME)-$(VERSION)
 PROGS := z80full z80flags z80doc z80docflags z80ccf z80memptr z80ccfscr
 SRCS  := main idea crctab tests testmacros print
 
-all: $(addsuffix .tap,$(PROGS))
+all: $(addsuffix .tap,$(PROGS)) $(addsuffix .out,$(PROGS))
 
 .DELETE_ON_ERROR: %.out

diff --git a/src/idea.asm b/src/idea.asm
index ada853d..c2263a3 100644
--- a/src/idea.asm
+++ b/src/idea.asm
@@ -44,7 +44,9 @@ test:       ld      (.spptr+1),sp
             call    .copy
             
             ld      a,0x07          ; Make sure we get 0
-            out     (0xfe),a        ; on MIC bit when doing IN.
+            nop
+            nop
+            ;out     (0xfe),a        ; on MIC bit when doing IN.
 
             ld      a,0xa9          ; Set I,R,AF' to known values.
             ld      i,a
diff --git a/src/main.asm b/src/main.asm
index e593e35..ca9b752 100644
--- a/src/main.asm
+++ b/src/main.asm
@@ -69,7 +69,8 @@ main:       di                                  ; disable interrupts
             exx
             pop     iy
             ei
-            ret
+            halt
+            ;ret
 
 .test       push    bc                          ; preserve number of failures
 
@@ -100,7 +101,10 @@ main:       di                                  ; disable interrupts
             ret                                 ; return success
 
 .incheck    xor     a                           ; expected IN value means do the test
-            in      a,(0xfe)
+            nop
+            nop
+           ; in      a,(0xfe)
+            ld a, 0xbf
             cp      0xbf                        ; %10111111 - just MIC bit is zero
             jr      z,.pass
 
diff --git a/src/print.asm b/src/print.asm
index bd26ac2..3c4809f 100644
--- a/src/print.asm
+++ b/src/print.asm
@@ -6,8 +6,10 @@
 
 
 printinit:  ld      a,2
-            jp      0x1601      ; CHAN-OPEN
-
+            nop
+            nop
+            ;jp      0x1601      ; CHAN-OPEN
+            ret
 
 print:      ex      (sp),hl
             call    printhl
@@ -70,8 +72,9 @@ printchr:   push    iy
             push    bc
             exx
             ei
+            out (0x11),a
             ; out     (0xff),a
-            rst     0x10
+          ;  rst     0x10
             di
             exx
             pop     bc
diff --git a/src/tests.asm b/src/tests.asm
index 5ccc77f..b292d3b 100644
--- a/src/tests.asm
+++ b/src/tests.asm
@@ -40,13 +40,13 @@ testtable:
             
             dw      .scf
             dw      .ccf
-            dw      .scf_nec
-            dw      .ccf_nec
-            dw      .scf_st
-            dw      .ccf_st
-            dw      .scfccf
-            dw      .ccfscf
-            
+;x       dw      .scf_nec
+;x       dw      .ccf_nec
+;x       dw      .scf_st
+;x       dw      .ccf_st
+;x       dw      .scfccf
+;x       dw      .ccfscf
+
             dw      .daa
             dw      .cpl
             dw      .neg
@@ -148,24 +148,24 @@ testtable:
             dw      .cpd
             dw      .cpir
             dw      .cpdr
-            
-            dw      .in_a_n
-            dw      .in_r_c
-            dw      .in_c
-            dw      .ini
-            dw      .ind
-            dw      .inir
-            dw      .indr
-            dw      .inir_nop
-            dw      .indr_nop
-
-            dw      .out_n_a
-            dw      .out_c_r
-            dw      .out_c_0
-            dw      .outi
-            dw      .outd
-            dw      .otir
-            dw      .otdr
+
+;x           dw      .in_a_n
+;x           dw      .in_r_c
+;x           dw      .in_c
+;x           dw      .ini
+;x           dw      .ind
+;x           dw      .inir
+;x           dw      .indr
+;x           dw      .inir_nop
+;x           dw      .indr_nop
+
+;x           dw      .out_n_a
+;x           dw      .out_c_r
+;x           dw      .out_c_0
+;x           dw      .outi
+;x           dw      .outd
+;x           dw      .otir
+;x           dw      .otdr
 
             dw      .jp_nn
             dw      .jp_cc_nn
```

Tests commented out with `;x` don't work yet.

#### How to compile test suite

- Install [sjasm 0.42c][sjasm]{:target="_blank"}
- Install [mktap-8][mktap]{:target="_blank"} or newest [mktap-16][mktap-16]{:target="_blank"} (&copy; Jan Bobrowski)
- Install `make`
- In terminal, run `make`

#### Running tests in emuStudio

Create new virtual computer, call it "ZX Spectrum":

![Abstract schema of ZX Spectrum]({{ site.baseurl }}/assets/altair8800/zs-spectrum-schema.png){:style="max-width:555"}

It is basically the same computer as Altair8800 with Z80, but instead of ADM-3A terminal it uses draft of 
ZX-spectrum display. This device is not even documented, because it's not really ZX spectrum. It exists just to be able
to run existing Z80 test suites.

When the computer is opened, load compiled test suite in memory, e.g. file `src/z80full.out` at address 0x8000.
Then, open the ZX-display and run emulation.

#### Selecting only some tests

Open file `src/tests.asm` and comment out tests below `testtable:` label you don't want to execute, e.g.:

```
testtable:
            if      selftests
            dw      .crc
            dw      .counter
            dw      .shifter
            endif

            dw      .selftest
            
            dw      .scf
            dw      .ccf
;x       dw      .scf_nec
;x       dw      .ccf_nec
;x       dw      .scf_st
;x       dw      .ccf_st
;x       dw      .scfccf
;x       dw      .ccfscf
```

Tests `.scf_ne`, `.ccf_ne`, `.scf_st`, `.ccf_st`, `.scfccf`, `.ccfscf` won't be executed in this case.

### ZXSpectrumNextTests

ZXSpectrumNextTests is another ZX Spectrum test suite, written by Kevin Watinks and Ped Helcmanovsky. It is actually 
a set of various test suites testing various aspects of ZX spectrum. I wasn't able to work out the tests, and
work is still in progress. So far in progress is a file for testing block instructions.

The test suite can be downloaded from [this repository][ZXSpectrumNextTests]{:target="_blank"}. Since it's counting
with ZX Spectrum architecture, tests must be modified for emuStudio.

Apply the following patch on top of commit `295c0e2005d5bd255ec2c26f06409a3afca77776`:

{:.code-example}
```
diff --git a/Tests/ZX48_ZX128/Z80BlockInstructionFlags/z80_block_flags_test.asm b/Tests/ZX48_ZX128/Z80BlockInstructionFlags/z80_block_flags_test.asm
index 4af203f..03cc51a 100644
--- a/Tests/ZX48_ZX128/Z80BlockInstructionFlags/z80_block_flags_test.asm
+++ b/Tests/ZX48_ZX128/Z80BlockInstructionFlags/z80_block_flags_test.asm
@@ -39,9 +39,9 @@
     OPT --syntax=abf
     DEVICE zxspectrum48, $7FFF
 
-ROM_ATTR_P: EQU     $5C8D
-ROM_CLS:    EQU     $0DAF
-ROM_PRINT:  EQU     $203C
+;ROM_ATTR_P: EQU     $5C8D
+;ROM_CLS:    EQU     $0DAF
+;ROM_PRINT:  EQU     $203C
 LAST_ATTR:  EQU     $5AFF
 LOG_AREA:   EQU     $8900
 TEST_AREA:  EQU     $E000
@@ -144,7 +144,7 @@ fill_test_area:
 
 ; print string terminated by $FF (and having all chars -1) from DE address
 print_FFstr.loop:
-        rst     $10
+       out (0x11), a
 print_FFstr:
         ld      a,(de)
         inc     de
@@ -152,11 +152,27 @@ print_FFstr:
         jr      nz,.loop
         ret
 
+ROM_PRINT.loop:
+       out (0x11), a
+ROM_PRINT:
+        ld      a,(de)
+        inc     de
+        dec     bc
+        jr      nz,.loop
+        ret
+
+clear_screen:
+
+
 ; main test code setting it up and doing all tests + printing results
 test_start:
-        ld      a,7<<3
-        ld      (ROM_ATTR_P),a  ; ATTR-P = PAPER 7 : INK 0 : BRIGHT 0 : FLASH 0
-        call    ROM_CLS
+        ld sp, STACK_TOP
+        ;ld      a,7<<3
+        ;ld      (ROM_ATTR_P),a  ; ATTR-P = PAPER 7 : INK 0 : BRIGHT 0 : FLASH 0
+        ;call    ROM_CLS
+        ld a, 0x1C
+        out (0x11), a
+
         ld      de,head_txt     ; text at top of screen
         call    print_FFstr
         ld      ix,i_meta       ; meta data about next instruction to test
@@ -191,6 +207,25 @@ test_start:
         ld      (hl),a
         ldir
         im      2
+
+        ; set CPU frequency 20 kHZ
+      ; ld a, 32 ; setCPUClockFrequency
+      ; out (0xFE), a
+      ; ld a, 20
+      ; out (0xFE), a
+      ; ld a, 0
+      ; out (0xFE), a
+
+        ; start timer interrupts (simh device)
+        ld a, 23 ; setTimerDeltaCmd
+        out (0xFE), a
+        ld a, 1
+        out (0xFE), a
+        ld a, 0x00
+        out (0xFE), a
+        ld a, 21 ; startTimerInterruptsCmd
+        out (0xFE), a
+
         ei
 
     ; calibrate initial BC delay before launching block instruction (delay depends on ZX type and prologue code)
@@ -210,11 +245,15 @@ test_start:
         ld      a,$FF           ; write $FF to last attribute of VRAM
         ld      (LAST_ATTR),a   ; to have also +2A/+3 models read $FF on port $FF (all test code is in fast memory)
         halt
-        in      a,($FE)
+      ;  in      a,($FE)
+     ;   ld a, 0x80
+        ld a, 0
         ld      (ulaB7),a       ; should be %1xxx'xxxx if ULA keyboard reads like Issue2+ model
-        in      a,($1F)
+      ;  in      a,($1F)
+        ld a, 0x80
         ld      (kempB7),a      ; should be %00xx'xxxx if Kempston interface is connected
-        in      a,($FF)
+      ;  in      a,($FF)
+        ld a, 0
         ld      (float),a       ; expected value $FF from floating bus
 
 next_instruction:
@@ -245,7 +284,7 @@ next_test:
 
     ; compare saved F flag with expected value and print result
         ld      a,' '
-        rst     $10
+        out (0x11), a
 .chkF+1 call    0               ; checkF function ; L = expected F value
         ld      a,l
         call    printHexByte
@@ -276,7 +315,7 @@ next_test:
     ; print ENTER after all four addresses were done
 .skip_test:
         ld      a,13
-        rst     $10
+        out (0x11), a
 
     ; advance test to next block instruction
         ld      hl,(.call)      ; advance test-call to next test-block (look for RET in current block)
@@ -296,10 +335,12 @@ next_test:
         ld      a,$3F
         ld      i,a
         im      1
-        ei
+
+        di
         ld      a,7
-        out     (254),a
-        ret
+       ; out     (254),a
+        ;ret
+        halt
 
 too_fast_machine:
         ld      de,calibrate_fail_txt
@@ -314,7 +355,7 @@ init_and_delay:
         push    hl
         ld      a,h
         and     7
-        out     (254),a         ; change BORDER based on ".af" value
+      ;  out     (254),a         ; change BORDER based on ".af" value
 .hl+1:  ld      hl,TEST_AREA
         or      a               ; +4T nop (CF is already 0)
         sbc     hl,bc
@@ -341,7 +382,7 @@ printHexDigit:                  ; Convert nibble to ASCII
         cp      10
         sbc     a,$69
         daa
-        rst     $10
+        out (0x11), a
         ret
 
 ulaB7:  DB      $00
@@ -349,7 +390,7 @@ kempB7: DB      $FF
 float:  DB      $00
 
 head_txt:
-        DB      $15,1           ; `OVER 1` for "!=" mixing
+       ; DB      $15,1           ; `OVER 1` for "!=" mixing
         DB      "v5.0 2022-01-11 Ped7g",13
         DB      "based on David Banks' research",13
         DB      "F of IM2 interrupted block inst",13
@@ -359,19 +400,23 @@ after_i_txt:
         DB      " F:",$FF
 
 expected_value_txt:
-        DB      '=',$13,0,$11,4,$FF         ; =, BRIGHT 0, PAPER 4
+;        DB      '=',$13,0,$11,4,$FF         ; =, BRIGHT 0, PAPER 4
+        DB      '=',$FF         ; =, BRIGHT 0, PAPER 4
 
 unexpected_value_txt:
-        DB      '=',8,'!',$13,1,$11,2,$FF   ; !=, BRIGHT 1, PAPER 2
+;        DB      '=',8,'!',$13,1,$11,2,$FF   ; !=, BRIGHT 1, PAPER 2
+        DB      '=',8,'!',$FF   ; !=, BRIGHT 1, PAPER 2
 
 restore_color:
-        DB      $13,0,$11,7,$10,0,$FF       ; BRIGHT 0 : PAPER 7 : INK 0
+;        DB      $13,0,$11,7,$10,0,$FF       ; BRIGHT 0 : PAPER 7 : INK 0
+        DB      $FF       ; BRIGHT 0 : PAPER 7 : INK 0
 
 skip_txt:
         DB      " unexpected IN 1F,FE,FF",$FF
 
 calibrate_fail_txt:
-        DB      $10,2,"failed delay calibration\ris frame > 73500T?",13,$FF
+;        DB      $10,2,"failed delay calibration\ris frame > 73500T?",13,$FF
+        DB      "failed delay calibration\ris frame > 73500T?",13,$FF
 
 ; default settings of init_and_delay for testing block instructions (used by LDIR/LDDR/CPIR/CPDR test)
 inst_default_init:
@@ -546,10 +591,10 @@ inxr_otxr_b_loop_test:
         ld      ix,i_meta_b
 .next_instruction:
     ; reset colors, print name of instruction, move four chars left (to overwrite it with progress indicators)
-        ld      a,$10
-        rst     $10
-        ld      a,4
-        rst     $10             ; INK 4 (green) for start of the test
+        ;ld      a,$10
+        ;rst     $10
+        ;ld      a,4
+        ;rst     $10             ; INK 4 (green) for start of the test
         ldi     hl,(ix)         ; fake-ok ; HL = address string with instruction name, IX+=2
         ld      de,hl           ; fake-ok ; DE = HL (for print)
         ld      bc,4
@@ -561,7 +606,7 @@ inxr_otxr_b_loop_test:
         ld      b,4
 .loop_left:
         ld      a,8
-        rst     $10
+        out     (0x11), a
         djnz    .loop_left
     ; call init and set up the test-call itself to desired instruction
         ldi     hl,(ix)         ; fake-ok ; HL = address of init function for next instruction test, IX+=2
@@ -609,15 +654,15 @@ inxr_otxr_b_loop_test:
         cp      c
         jr      z,.okF
     ; change INK to red for rest of tests with this instruction (but keep running + logging)
-        ld      a,$10
-        rst     $10
-        ld      a,2
-        rst     $10             ; INK 2 (red) for rest of the test
+        ;ld      a,$10
+        ;rst     $10
+        ;ld      a,2
+        ;rst     $10             ; INK 2 (red) for rest of the test
 .okF:   ; display progress char
 .p_hl+1:ld      hl,progress_chars
         ld      a,(hl)
         inc     l
-        rst     $10
+        out (0x11), a
         ld      a,low progress_chars.e
         cp      l
         ld      a,8             ; 8 = "left" to compose the char together next time
@@ -626,7 +671,7 @@ inxr_otxr_b_loop_test:
         ld      l,low progress_chars
 .progress_not_last:
         ld      (.p_hl),hl
-        rst     $10
+        out (0x11), a
 
         ; increment initial B by +3 65x times
         ld      a,(init_and_delay.bc+1)
@@ -642,11 +687,12 @@ inxr_otxr_b_loop_test:
         ld      de,restore_color
         call    print_FFstr     ; restore colors back to white paper, black ink
         ld      a,13
-        rst     $10
+        out (0x11), a
         ret
 
 b_loop_txt:
-        DB      "HF vs B, binary log at $8900",13,$13,1,$11,0,$FF       ; also BRIGHT 1, PAPER 0 for progress+results
+        ;DB      "HF vs B, binary log at $8900",13,$13,1,$11,0,$FF       ; also BRIGHT 1, PAPER 0 for progress+results
+        DB      "HF vs B, binary log at $8900",13,$FF       ; also BRIGHT 1, PAPER 0 for progress+results
 
 i_meta:     ; name of instruction + expected flag when interrupted by IM2 during block operation (BC!=0)
         ; LDIR: N=0, P/V=1, H=0, C=Z=S=unchanged (0), YF=PC.13, XF=PC.11
@@ -765,6 +811,10 @@ in_instr_regs:      SAVED_REGS
 im2isr:
         ASSERT low im2isr == high im2isr
         push    af,,hl,,de,,bc
+
+   ;     ld a, 'I'
+    ;    out (0x11), a
+
         ld      hl,0
         add     hl,sp
         ld      de,im_saved_regs
@@ -781,82 +831,85 @@ STACK_TOP:  EQU     $8800
 
 code_end:
 
+        SAVEBIN "z80bltst.bin", $8000, code_end - $8000 ; save 0x7FFF begin from 0x8000 of RAM to file
+
     ;; produce SNA file with test code
-        SAVESNA "z80bltst.sna", code_start
+;        SAVESNA "z80bltst.sna", code_start
 
-CODE        EQU     $AF
-USR         EQU     $C0
-LOAD        EQU     $EF
-CLEAR       EQU     $FD
-RANDOMIZE   EQU     $F9
-REM         EQU     $EA
+;CODE        EQU     $AF
+;USR         EQU     $C0
+;LOAD        EQU     $EF
+;CLEAR       EQU     $FD
+;RANDOMIZE   EQU     $F9
+;REM         EQU     $EA
 
     ;; produce TAP file with the test code
-        DEFINE tape_file "z80bltst.tap"
-        DEFINE prog_name "z80bltst"
+;        DEFINE tape_file "z80bltst.tap"
+;        DEFINE prog_name "z80bltst"
 
         ;; 10 CLEAR 32767:LOAD "z80bltst"CODE
         ;; 20 RANDOMIZE USR 32768
-        ORG     $5C00
-tap_bas:
-        DB      0,10    ;; Line number 10
-        DW      .l10ln  ;; Line length
-.l10:   DB      CLEAR,'8',$0E,0,0
-        DW      code_start-1
-        DB      0,':'
-        DB      LOAD,'"'
-.fname: DB      prog_name
-        ASSERT  ($ - .fname) <= 10
-        DB      '"',CODE,$0D
-.l10ln: EQU     $-.l10
-        DB      0,20    ;; Line number 20
-        DW      .l20ln
-.l20:   DB      RANDOMIZE,USR,"32768",$0E,0,0
-        DW      code_start
-        DB      0,$0D
-.l20ln: EQU     $-.l20
-        DB      0,99    ;; Line number 99
-        DW      .l99ln
-.l99:   DB      REM,"https://github.com/MrKWatkins/ZXSpectrumNextTests/\r"
-.l99ln: EQU     $-.l99
-.l:     EQU     $-tap_bas
-
-        EMPTYTAP tape_file
-        SAVETAP  tape_file,BASIC,prog_name,tap_bas,tap_bas.l,1
-        SAVETAP  tape_file,CODE,prog_name,code_start,code_end-code_start,code_start
+;        ORG     $5C00
+;tap_bas:
+;        DB      0,10    ;; Line number 10
+;        DW      .l10ln  ;; Line length
+;.l10:   DB      CLEAR,'8',$0E,0,0
+;        DW      code_start-1
+;        DB      0,':'
+;        DB      LOAD,'"'
+;.fname: DB      prog_name
+;        ASSERT  ($ - .fname) <= 10
+;        DB      '"',CODE,$0D
+;.l10ln: EQU     $-.l10
+;        DB      0,20    ;; Line number 20
+;        DW      .l20ln
+;.l20:   DB      RANDOMIZE,USR,"32768",$0E,0,0
+;        DW      code_start
+;        DB      0,$0D
+;.l20ln: EQU     $-.l20
+;        DB      0,99    ;; Line number 99
+;        DW      .l99ln
+;.l99:   DB      REM,"https://github.com/MrKWatkins/ZXSpectrumNextTests/\r"
+;.l99ln: EQU     $-.l99
+;.l:     EQU     $-tap_bas
+;
+;        EMPTYTAP tape_file
+;        SAVETAP  tape_file,BASIC,prog_name,tap_bas,tap_bas.l,1
+;        SAVETAP  tape_file,CODE,prog_name,code_start,code_end-code_start,code_start
 
     ;; produce TRD file with the test code
-        DEFINE trd_file "z80bltst.trd"
+;        DEFINE trd_file "z80bltst.trd"
 
         ;; 10 CLEAR 32767:RANDOMIZE USR 15619:REM:LOAD "z80bltst"CODE
         ;; 20 RANDOMIZE USR 32768
-        ORG     $5C00
-trd_bas:
-        DB      0,10    ;; Line number 10
-        DW      .l10ln  ;; Line length
-.l10:   DB      CLEAR,'8',$0E,0,0
-        DW      code_start-1
-        DB      0,':'
-        DB      RANDOMIZE,USR,"15619",$0E,0,0
-        DW      15619
-        DB      0,':',REM,':',LOAD,'"'
-.fname: DB      "z80bltst"
-        ASSERT  ($ - .fname) <= 8
-        DB      '"',CODE,$0D
-.l10ln: EQU     $-.l10
-        DB      0,20    ;; Line number 20
-        DW      .l20ln
-        ASSERT  32768 == code_start
-.l20:   DB      RANDOMIZE,USR,"32768",$0E,0,0
-        DW      code_start
-        DB      0,$0D
-.l20ln: EQU     $-.l20
-        DB      0,99    ;; Line number 99
-        DW      .l99ln
-.l99:   DB      REM,"https://github.com/MrKWatkins/ZXSpectrumNextTests/\r"
-.l99ln: EQU     $-.l99
-.l:     EQU     $-trd_bas
-
-        EMPTYTRD trd_file
-        SAVETRD  trd_file,"boot.B",trd_bas,trd_bas.l,10
-        SAVETRD  trd_file,"z80bltst.C",code_start,code_end-code_start
+;        ORG     $5C00
+;trd_bas:
+;        DB      0,10    ;; Line number 10
+;        DW      .l10ln  ;; Line length
+;.l10:   DB      CLEAR,'8',$0E,0,0
+;        DW      code_start-1
+;        DB      0,':'
+;        DB      RANDOMIZE,USR,"15619",$0E,0,0
+;        DW      15619
+;        DB      0,':',REM,':',LOAD,'"'
+;.fname: DB      "z80bltst"
+;        ASSERT  ($ - .fname) <= 8
+;        DB      '"',CODE,$0D
+;.l10ln: EQU     $-.l10
+;        DB      0,20    ;; Line number 20
+;        DW      .l20ln
+;        ASSERT  32768 == code_start
+;.l20:   DB      RANDOMIZE,USR,"32768",$0E,0,0
+;        DW      code_start
+;        DB      0,$0D
+;.l20ln: EQU     $-.l20
+;        DB      0,99    ;; Line number 99
+;        DW      .l99ln
+;.l99:   DB      REM,"https://github.com/MrKWatkins/ZXSpectrumNextTests/\r"
+;.l99ln: EQU     $-.l99
+;.l:     EQU     $-trd_bas
+;
+;        EMPTYTRD trd_file
+;        SAVETRD  trd_file,"boot.B",trd_bas,trd_bas.l,10
+;        SAVETRD  trd_file,"z80bltst.C",code_start,code_end-code_start
+;
\ No newline at end of file
```

#### How to compile test suite

- Install [sjasmplus][sjasmplus]{:target="_blank"}
- In terminal, run `./sjasmplus Tests/ZX48_ZX128/Z80BlockInstructionFlags/z80_block_flags_test.asm` (produces `z80bltst.bin`)

#### Running tests in emuStudio

Create new virtual computer, call it "ZX Spectrum" (see previous section on Patrik Rak's tests).

When the computer is opened, load compiled test suite in memory, file
`Tests/ZX48_ZX128/Z80BlockInstructionFlags/z80bltst.bin` at address 0x8000.
Then, open the ZX-display and run emulation.

Disclaimer: output will be awful.

### ZEXALL tests

Another test suite, which actually works in emuStudio with one small support code. The test suite can be downloaded
at [this repository][zexall]{:target="_blank"}.

#### How to compile test suite

- Install [ZSM4][zsm4]{:target="_blank"}
- Compile using command line:

```
zsm4 =zexall/L
link zexdoc
```

#### Running tests in emuStudio

Create new virtual computer, call it "ZX Spectrum" (see previous section on Patrik Rak's tests).

In source code editor, compile the following support code:

```
di
halt

; bdos simulation
org 5
push af
push de

ld a, 2
cp c ; print char
jp nz, str
ld a, e
out (0x11), a
jp exit


str:
ld a, 9
cp c ; print string
jp nz, exit

putstr:
ld a, (de)
inc de

cp '$'
jp z, exit

out (11h), a
jp putstr

exit:
pop de
pop af
ret
```

Then, load `zexall.com` or `zexdoc.com` at location 0x100 into memory. Set program address to 0x100, open the terminal
and run the emulation.


[z80]: https://en.wikipedia.org/wiki/Zilog_Z80
[mp3]: https://en.wikipedia.org/wiki/S1_MP3_player
[z80test-raxoft]: https://github.com/raxoft/z80test
[sjasm]: https://www.xl2s.tk/
[mktap]: {{ site.baseurl }}/assets/mktap-8.zip
[mktap-16]: https://torinak.com/~jb/zx/mktap-16.tar.gz
[ZXSpectrumNextTests]: https://github.com/MrKWatkins/ZXSpectrumNextTests
[sjasmplus]: https://github.com/z00m128/sjasmplus
[zexall]: https://github.com/agn453/ZEXALL
[zsm4]: https://github.com/hperaza/ZSM4
