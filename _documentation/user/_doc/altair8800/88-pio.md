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

{% include annotated-screenshot.html image="/assets/altair8800/88-pio-gui.png" alt="88-4PIO window with numbered attached device, channel, registers and input controls" width=571 points="1:93.87:3.88|2:28.02:22.87|3:48.16:27.71|4:92.47:27.71|5:92.12:77.52" %}

{: .list}
| <span class="circle">1</span> | **Attached device**. Shows the connected peripheral identity; `unknown` means an identity is unavailable.
| <span class="circle">2</span> | **Channel**. Select a PIA channel to inspect. This changes the view; the peripheral connection belongs to the whole board.
| <span class="circle">3</span> | **Control channel**. Shows control-register bits, the hexadecimal value and interrupt flags for the selected channel.
| <span class="circle">4</span> | **Data pins**. Shows input pins, output pins and the data-direction register. A DDR bit of `1` selects output.
| <span class="circle">5</span> | **Peripheral input**. Set an input byte or change C1/C2 while no peripheral is connected. C2 can be edited only when configured as an input; attached peripherals own these controls otherwise.

The original 88-PIO uses separate input and output latches instead of PIA channels:

{% include annotated-screenshot.html image="/assets/altair8800/88-pio-8212-gui.png" alt="Original 88-PIO window with numbered latches and manual handshake controls" width=515 points="1:43.30:25.39|2:92.43:25.39|3:92.43:77.48" %}

{: .list}
| <span class="circle">1</span> | **Control channel**. Shows input-data-ready (`D`), output-device-ready (`R`) and the interrupt-enable value.
| <span class="circle">2</span> | **Data latches**. Inspect the most recent input and output bytes.
| <span class="circle">3</span> | **Peripheral input**. Enter a byte and click **Strobe input** to place it in the input latch. **Output device ready** changes the output-ready flag.

## Settings dialog

Select `88-pio` in the device list and click **Show settings...**. Its three tabs are shown below.

### General settings

{% include annotated-screenshot.html image="/assets/altair8800/88-pio-settings-general-settings.png" alt="88-PIO general settings with numbered board model, PIA count and Save button" width=534 points="1:94.38:11.40|2:41.95:38.60|3:79.21:94.04" %}

{: .list}
| <span class="circle">1</span> | **Board**. Choose the Intel 8212-based 88-PIO or Motorola 6820-based 88-4PIO.
| <span class="circle">2</span> | **Populated PIAs**. Set one to four PIAs for 88-4PIO. This field is disabled for the original 88-PIO.
| <span class="circle">3</span> | **Save**. Persist all tabs and close the dialog. Reopen the computer to apply the new board, ports or interrupt vector. Press **Esc** to discard edits.

### Connection with CPU

{% include annotated-screenshot.html image="/assets/altair8800/88-pio-settings-connection-with-cpu.png" alt="88-PIO CPU connection settings with numbered base port, defaults and channel mapping" width=534 points="1:44.76:17.36|2:92.88:11.40|3:86.33:36.79" %}

{: .list}
| <span class="circle">1</span> | **CPU base port**. Enter a decimal or `0x` hexadecimal address with the alignment required by the selected board.
| <span class="circle">2</span> | **Set default**. Restore the selected board’s default base port and two PIAs.
| <span class="circle">3</span> | **Channel ports**. Preview the resulting register addresses; avoid overlaps with other devices.

### Interrupts

{% include annotated-screenshot.html image="/assets/altair8800/88-pio-settings-interrupts.png" alt="88-PIO interrupt settings with numbered RST vector and default button" width=534 points="1:47.75:35.23|2:73.78:78.50" %}

{: .list}
| <span class="circle">1</span> | **Interrupt vector**. Select the RST vector, from `0` to `7`. Guest software must also enable interrupts.
| <span class="circle">2</span> | **Set default**. Restore vector `7`. Click **Save** to persist it.

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
