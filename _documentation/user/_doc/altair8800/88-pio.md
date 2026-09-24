---
layout: default
title: Device "88-pio"
nav_order: 12
parent: MITS Altair8800
permalink: /altair8800/88-pio
---

{% include analytics.html category="Altair8800" %}

# MITS 88-PIO parallel interface

The `88-pio` plugin emulates the Intel 8255-compatible parallel interface used by the MITS 88-PIO. It implements
mode 0: three parallel ports with independently configured input and output directions.

## CPU ports

|---
| Address | Read | Write
|-|-|-
|`08h` | Port A pins or output latch | Port A output latch
|`09h` | Port B pins or output latch | Port B output latch
|`0Ah` | Port C pins and output latch | Writable Port C bits
|`0Bh` | Current control word | Mode-set or bit set/reset command
|---

These default addresses overlap the 88-DCDD and 88-MDS disk controllers. A virtual computer must choose the device
required by its software; it cannot connect those plugins to the same CPU ports simultaneously.

## Mode-set control word

Write a value with bit 7 set to configure directions. Modes 1 and 2 are normalized to mode 0.

|---
| Bit | Meaning when set
|-|-
|4 | Port A is input
|3 | Upper Port C bits are input
|1 | Port B is input
|0 | Lower Port C bits are input
|---

Changing the mode clears all output latches. At reset, all ports are inputs and unconnected pins read as `FFh`.

Write a value with bit 7 clear to change one Port C output latch bit. Bits 3-1 select Port C bit 0-7; bit 0 chooses
reset (`0`) or set (`1`). Input-configured Port C bits continue to read their input pins.

## Connecting parallel devices

Ports A, B, and C are also published as byte device contexts. A connected device writes a byte to provide input pin
values and reads a byte to observe the current port value. Direction rules still apply, including separate upper and
lower directions for Port C.

## GUI

Open the device from the emulator device list to inspect the control word, directions, input pins, and output latches.
The GUI can change input pin values for interactive testing; it does not bypass direction control.
