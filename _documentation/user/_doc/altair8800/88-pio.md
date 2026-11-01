---
layout: default
title: Device "88-pio"
nav_order: 11
parent: MITS Altair8800
permalink: /altair8800/88-pio
---

{% include analytics.html category="Altair8800" %}

# MITS 88-PIO and 88-4PIO parallel interfaces

## Introduction

The MITS **88-PIO** and **88-4PIO** were S-100 expansion boards for connecting an Altair to parallel peripherals.
They transferred data over eight signal lines at a time, with handshake signals coordinating the computer and the
peripheral. The original 88-PIO had separate eight-bit input and output ports; the 88-4PIO used Motorola 6820
Peripheral Interface Adapters (PIAs), allowing each data line to be configured as an input or output.

![Original MITS 88-PIO S-100 board with two Intel 8212 chips and a parallel connector]({{ site.baseurl }}/assets/altair8800/88-pio-board.jpg){: style="max-width: 640px; width: 100%;" }

*Original 88-PIO board. Photo from the [deramp.com hardware archive][hardware-photos]{:target="_blank"}.*

![MITS 88-4PIO S-100 board populated with four Motorola 6820 PIAs and ribbon cables]({{ site.baseurl }}/assets/altair8800/88-4pio-board.jpg){: style="max-width: 640px; width: 100%;" }

*88-4PIO board populated with four PIAs. Photo from the [deramp.com hardware archive][hardware-photos]{:target="_blank"}.*

The `88-pio` plugin supports two boards: the original Intel 8212-based **88-PIO**, with separate input and output
latches, and the Motorola 6820-based **88-4PIO**, with two eight-bit channels per PIA. The default board is 88-4PIO.
Select the board expected by the guest software and avoid conflicts with other devices' CPU ports.

### Original manual

[MITS 88-PIO Parallel I/O Board Documentation (1975, PDF)][manual]{:target="_blank"} covers the original board.

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

## GUI overview

On the **Debugger** tab, double-click `88-pio` in the device list. The 88-4PIO window is shown below:

![88-4PIO window with numbered attached device, channel, registers and input controls]({{ site.baseurl }}/assets/altair8800/88-pio-gui.png){: style="max-width: 555px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Attached device**. Identify the board’s connected peripheral. |
| <span class="circle">2</span> | **Channel**. Select the PIA channel to inspect. This changes the view, not the attached peripheral. |
| <span class="circle">3</span> | **Registers**. Inspect data, direction, control, and handshake state for the selected channel. |
| <span class="circle">4</span> | **Input byte**. Enter the simulated input-pin value. |
| <span class="circle">5</span> | **Set input pins**. Apply the entered byte to the selected channel. |
| <span class="circle">6</span> | **C1 high**. Set the selected channel’s C1 input level. |
| <span class="circle">7</span> | **C2 high**. Set the selected channel’s C2 input level. |

The original 88-PIO uses separate input and output latches instead of PIA channels:

![Original 88-PIO window with numbered latches and manual handshake controls]({{ site.baseurl }}/assets/altair8800/88-pio-8212-gui.png){: style="max-width: 503px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Attached device**. Identify the peripheral connected to the original 88-PIO board. |
| <span class="circle">2</span> | **Latches and status**. Inspect the input/output latches and handshake flags. |
| <span class="circle">3</span> | **Input byte**. Enter a byte to present at the input. |
| <span class="circle">4</span> | **Strobe input**. Latch the entered byte as a new peripheral input. |
| <span class="circle">5</span> | **Output device ready**. Set the peripheral’s output-ready handshake input. |

## Settings dialog

Select `88-pio` in the device list and click **Show settings...**. Its three tabs are shown below.

### General settings

![88-PIO general settings with numbered board model, PIA count and Save button]({{ site.baseurl }}/assets/altair8800/88-pio-settings-general-settings.png){: style="max-width: 534px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Board**. Select original 88-PIO or 88-4PIO emulation. |
| <span class="circle">2</span> | **Populated PIAs**. Set how many PIAs the 88-4PIO board contains. |
| <span class="circle">3</span> | **Save**. Save the board configuration; reopen the computer to initialize it. |

### Connection with CPU

![88-PIO CPU connection settings with numbered base port, defaults and channel mapping]({{ site.baseurl }}/assets/altair8800/88-pio-settings-connection-with-cpu.png){: style="max-width: 534px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **CPU base port**. Set the first port claimed by the selected board. |
| <span class="circle">2</span> | **Set default**. Restore the selected model’s standard base port. |
| <span class="circle">3</span> | **Port map**. Review the CPU ports and channel registers derived from the base port. |
| <span class="circle">4</span> | **Save**. Save the mapping; reopen the computer to apply it. |

### Interrupts

![88-PIO interrupt settings with numbered RST vector and default button]({{ site.baseurl }}/assets/altair8800/88-pio-settings-interrupts.png){: style="max-width: 534px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Interrupt vector**. Choose the RST vector used for board interrupts. |
| <span class="circle">2</span> | **Set default**. Restore the standard interrupt vector. |
| <span class="circle">3</span> | **Save**. Save the vector; reopen the computer to apply it. |

## Configuration file

Set these keys in the existing `[DEVICE.settings]` table for `88-pio` in the computer's TOML file.

| Key | Default | Values | Meaning |
|---|---|---|---|
| `boardType` | `"88-4PIO"` | `"88-PIO"`, `"88-4PIO"` | Board model |
| `basePort` | `0xA0` for 88-4PIO; `0x04` for 88-PIO | 88-4PIO: multiples of 16 from `0x00` to `0xF0`; 88-PIO: even addresses from `0x00` to `0xFE` | First CPU port; avoid overlaps with other devices |
| `piaCount` | `2` | `1`–`4` | Number of 6820 PIAs on 88-4PIO; ignored by 88-PIO |
| `interruptVector` | `7` | `0`–`7` | RST vector used when the board raises an interrupt |

For example, the default 88-4PIO configuration is:

```toml
[DEVICE.settings]
boardType = "88-4PIO"
basePort = 0xA0
piaCount = 2
interruptVector = 7
```

Use decimal or hexadecimal TOML integers. For the original 88-PIO, set `boardType = "88-PIO"` and
`basePort = 0x04`. Close and reopen the computer to apply changes made directly to the file.
The settings dialog previews the port mapping; save its changes, then reopen the computer to apply them.

[manual]: https://deramp.com/downloads/altair/hardware/MITS%2088-PIO.pdf
[hardware-photos]: https://deramp.com/downloads/mfe_archive/010-S100%20Computers%20and%20Boards/00-MITS/10-MITS%20S100%20Boards/88-PIO%20Parallel%20IO/
