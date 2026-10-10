---
layout: default
title: Device "88-pio"
nav_order: 11
parent: MITS Altair8800
permalink: /altair8800/88-pio
---

{% include analytics.html category="Altair8800" %}

# MITS 88-PIO and 88-4PIO parallel interfaces

The `88-pio` plugin supports two boards: the original Intel 8212-based **88-PIO**, with separate input and output
latches, and the Motorola 6820-based **88-4PIO**, with two eight-bit channels per PIA. The default board is 88-4PIO.
Select the board expected by the guest software and avoid conflicts with other devices' CPU ports.

## Configuration

| Key | Default | Values | Meaning |
|---|---|---|---|
| `boardType` | `"88-4PIO"` | `"88-PIO"`, `"88-4PIO"` | Board model |
| `basePort` | `A0h` for 88-4PIO; `04h` for 88-PIO | See below | First CPU port |
| `piaCount` | 2 | 1–4 | Number of 6820 PIAs on 88-4PIO; unused by 88-PIO |
| `interruptVector` | 7 | 0–7 | RST vector used when the board raises an interrupt |

Use decimal integers or TOML hexadecimal integers, for example `basePort = 0xA0`. The settings dialog previews the
port mapping. Save changes, then reopen the computer to apply them; press **Esc** to discard the dialog's edits.

## Original 88-PIO

The base port must be even, from `00h` through `FEh`. With the default base:

| Address | Read | Write |
|---|---|---|
| `04h` | Status: bit 1 = input ready, bit 0 = output ready | Interrupt enables: bit 1 = input, bit 0 = output |
| `05h` | Input latch; clears input-ready status | Output latch; clears output-ready status |

The device publishes one byte `DeviceContext` at index 0. A peripheral writes a byte to fill the input latch and
set input-ready; reading the context consumes the output latch and sets output-ready. Input is a single latch,
so a new byte can replace an unread one. Reset clears both latches, ready flags and interrupt enables.

## 88-4PIO

The base must be aligned to 16 ports, from `00h` through `F0h`. Each PIA occupies four consecutive ports. With two
PIAs and the default base:

| Channel | Control | Data-direction register / data |
|---|---|---|
| PIA 1 A | `A0h` | `A1h` |
| PIA 1 B | `A2h` | `A3h` |
| PIA 2 A | `A4h` | `A5h` |
| PIA 2 B | `A6h` | `A7h` |

Control bit 2 selects the data-direction register (`0`) or data register (`1`) at the odd port. Each direction bit
selects output (`1`) or input (`0`). The control registers also configure handshake lines and interrupts. Reset clears
the control, direction and output registers; input pins default to `FFh`.

For example, this 8080 program configures PIA 1 B as output and writes `55h`:

```asm
xra a
out 0A2h       ; select direction register
mvi a, 0FFh
out 0A3h       ; all eight bits are outputs
mvi a, 04h
out 0A2h       ; select data register
mvi a, 55h
out 0A3h
hlt
```

The board publishes `PioContext` at index 0. A connected peripheral can drive input pins and control lines, and observe
output and handshake changes. The [MITS hard-disk controller]({{ site.baseurl }}/altair8800/88-hdsk#mits-hard-disk-mode)
requires this context with at least two PIAs; connect `88-hdsk` to `88-pio` in the computer schema.

## GUI

Open the device window to inspect the board's registers, input pins, output latches and attached peripheral.
Interrupts require guest enable bits and a CPU that supports interrupts. Changing input pins in the GUI follows the
selected board's direction and handshake rules.

## Original manual

[MITS 88-PIO Parallel I/O Board Documentation (1975, PDF)][manual]{:target="_blank"} covers the original board.

[manual]: https://deramp.com/downloads/altair/hardware/MITS%2088-PIO.pdf
