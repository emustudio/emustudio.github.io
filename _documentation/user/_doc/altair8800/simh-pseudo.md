---
layout: default
title: Device simh-pseudo
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
1       | N/A        | N/A          | start a new timer on the top of the timer stack
2       | N/A        | N/A          | stop timer on top of timer stack and print time difference on stdout, in milliseconds
3       | N/A        | N/A          | reset the PTR device (NOT IMPLEMENTED)
4       | N/A        | N/A          | attach the PTR device (NOT IMPLEMENTED)
5       | N/A        | N/A          | detach the PTR device (NOT IMPLEMENTED)
6       | N/A        | 8 bytes (`"SIMH004\0"`) | get the current version of the SIMH pseudo device
7       | N/A        | 6 bytes      | get the current time in ZSDOS format, all BCD values: byte 0: year modulo 100, byte 1: month, byte 2: day, byte 3: hour, byte 4: minute, byte 5: second
8       | 2 bytes (address of a 6-byte block in memory representing ZSDOS time in format YY MM DD HH MM SS) | N/A          | set the current time in ZSDOS format: reads the time from given address
9       | N/A        | 5 bytes      | get the current time in CP/M 3 format, all BCD values: bytes 0-1: days since 1 Jan 1978 (low byte), byte 2: hour, byte 3: minute, byte 4: second
10      | 2 bytes (address of a 5-byte block in memory representing CP/M 3 time in format: 0-1: days since 31 Dec 77, 2: HH, 3: MM, 4: SS)    | N/A | set the current time in CP/M 3 format: reads the time from given address
11      | N/A        | 1 byte       | get the selected bank
12      | 1 byte     | N/A          | set the selected bank
13      | N/A        | 2 bytes      | get the base address of the common memory segment
14      | N/A        | N/A          | reset the SIMH-pseudo device (clears "undefined" state)
15      | N/A        | N/A          | show time difference to timer on top of stack
16      | N/A        | 1 byte       | attach PTP device to the file with name at beginning of CP/M command line (NOT IMPLEMENTED)
17      | N/A        | N/A          | detach PTP device (NOT IMPLEMENTED)
18      | N/A        | 1 byte       | determines whether machine has banked memory (returns number of memory banks)
19      | N/A        | N/A          | set the CPU to a Z80 (NOT IMPLEMENTED)
20      | N/A        | N/A          | set the CPU to an 8080 (NOT IMPLEMENTED)
21      | N/A        | N/A          | start timer interrupts
22      | N/A        | N/A          | stop timer interrupts
23      | 2 bytes    | N/A          | set the timer interval in which interrupts occur
24      | 2 bytes    | N/A          | set the address to call by timer interrupts
25      | N/A        | N/A          | reset the millisecond stop watch
26      | N/A        | 2 bytes      | read the millisecond stop watch
27      | N/A        | N/A          | let emulation sleep for 1000 milliseconds
28      | N/A        | 1 byte       | obtain the file path separator of the OS under which emuStudio runs
29      | N/A        | file names separated by 0, ends with double 0 | perform wildcard expansion and obtain list of file names
30      | URL (N bytes terminated with 0) | max 1024 byte pairs (URL content) in form `availability, data` (when `availability` is 1 the `data` byte is valid) until `availability` is 0 | read the contents of a URL
31      | N/A        | 2 bytes      | get the clock frequency of the CPU
32      | 2 bytes    | N/A          | set the clock frequency of the CPU. To make effect, CPU must be paused/run again.
33      | 2 bytes (byte 0: (unused) interrupt vector, byte 1: interrupt data byte, an `RST` instruction) | N/A | generate interrupt
|---

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




[simh]: http://simh.trailing-edge.com/
