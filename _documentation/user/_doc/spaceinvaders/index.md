---
layout: default
title: Space Invaders
description: "Set up Space Invaders in emuStudio — load arcade ROMs, use keyboard controls, and configure the display."
nav_order: 4
permalink: /spaceinvaders/
---

{% include analytics.html category="SpaceInvaders" %}

# Space Invaders

The `Space Invaders` virtual computer emulates the arcade machine using the
[Intel 8080 CPU]({{ site.baseurl }}/altair8800/8080-cpu),
[byte memory]({{ site.baseurl }}/altair8800/byte-mem), and the `spaceinvaders-display` device.
The device provides a 224 by 256 pixel display, keyboard controls, a hardware shift register, and the interrupts
needed by the game. The bundled `as-8080` assembler also lets you experiment with your own programs.

## Computer schema

The bundled `SpaceInvaders.toml` configuration uses the following schema:

![Space Invaders computer schema with numbered plugins]({{ site.baseurl }}/assets/spaceinvaders/spaceinvaders-schema.png)

{: .list}
| <span class="circle">1</span> | `as-8080` assembler. Compiles your own 8080 programs into memory; it is not needed to run the arcade ROMs. |
| <span class="circle">2</span> | `8080-cpu` processor. Executes the game code, handles the display interrupts, and communicates with the device through I/O ports. |
| <span class="circle">3</span> | `byte-mem` operating memory. Holds the ROM images, game state, and framebuffer. |
| <span class="circle">4</span> | `spaceinvaders-display` device. Reads the framebuffer from memory and provides the display, keyboard inputs, shift register, and raster interrupts to the CPU. |

The arrows show bidirectional connections: assembler–memory, CPU–memory, display–CPU, and display–memory.

## Getting started

Use an emuStudio installation containing `config/SpaceInvaders.toml` and `spaceinvaders-display.jar`.
emuStudio does not distribute the copyrighted arcade ROMs. Supply legally obtained copies of the four binary images:

| ROM file | Load address | Size |
|:---------|:-------------|:-----|
| `invaders.h` | `0000h` (0) | 2048 bytes |
| `invaders.g` | `0800h` (2048) | 2048 bytes |
| `invaders.f` | `1000h` (4096) | 2048 bytes |
| `invaders.e` | `1800h` (6144) | 2048 bytes |

### Configure the ROMs

1. Close the virtual computer before editing `config/SpaceInvaders.toml`.
2. In `[MEMORY.settings]`, set `memorySize = 65536` (64 KiB) and keep `banksCount = 1` and `commonBoundary = 0`.
   If your template uses `16384`, increase it: the game can access memory beyond the framebuffer.
3. Uncomment the twelve `imageName`, `imageAddress`, and `imageBank` lines by removing their leading `#`.
   Set each `imageName` to the path of its ROM file. Absolute paths avoid dependence on the launch directory.
   Keep the addresses and bank numbers shown below.

The image settings belong inside the existing `[MEMORY.settings]` section; do not add a second section with that name:

```toml
imageName0 = "/path/to/roms/invaders.h"
imageAddress0 = 0
imageBank0 = 0
imageName1 = "/path/to/roms/invaders.g"
imageAddress1 = 2048
imageBank1 = 0
imageName2 = "/path/to/roms/invaders.f"
imageAddress2 = 4096
imageBank2 = 0
imageName3 = "/path/to/roms/invaders.e"
imageAddress3 = 6144
imageBank3 = 0
```

Replace `/path/to/roms/` with your directory. On Windows, TOML literal strings such as
`imageName0 = 'C:\roms\invaders.h'` can be used for paths containing backslashes.
Keep the template's `ROMfrom` and `ROMto` settings, which protect ROM from writes by the emulated CPU.

### Start playing

1. Launch emuStudio and choose **Space Invaders** in the
   [computer chooser]({{ site.baseurl }}/application/opening-computer), or run
   `./emuStudio -cf config/SpaceInvaders.toml` from the installation directory.
2. Select the **Emulator** tab and double-click `spaceinvaders-display` in the device list to open the game window.
3. Click **Reset**, then **Run** in the [debugger toolbar]({{ site.baseurl }}/application/main-window#debugger-toolbar).
   The ROMs are already loaded; no source compilation is needed to play.
4. Focus the game window, press and release **C** to insert a coin, then press **1** to start a one-player game.
5. Use the arrow keys to move and **Space** to fire. Use **Pause** and **Run** in the main window to pause and resume.

## GUI overview

To open the display, double-click `spaceinvaders-display` in the device list on the **Emulator** tab.
The following screenshot shows a one-player game with `scale = 2` and `colorOverlay = true`:

![Space Invaders game screen with numbered score, invaders, player area, and lives and credits]({{ site.baseurl }}/assets/spaceinvaders/spaceinvaders-screen.png){:style="max-width:448px"}

{: .list}
| <span class="circle">1</span> | Score area. Shows player scores and the high score. |
| <span class="circle">2</span> | Invader formation. Move your cannon and fire at the advancing enemies. |
| <span class="circle">3</span> | Player area and shields. The cannon moves along the bottom of the playfield; the shields provide cover until they are damaged. |
| <span class="circle">4</span> | Remaining lives and credits. Press **C** to insert a coin before starting a game. |

The red upper band and green lower band come from the optional color overlay. The underlying framebuffer is monochrome.
Use the main window's debugger toolbar to pause, resume, or reset the game.

### Controls

The game window must have keyboard focus. Inputs are active while a key is held and clear when it is released.

| Key | Action |
|:----|:-------|
| **C** | Insert coin |
| **1** | Start one-player game |
| **2** | Start two-player game |
| **Space** | Fire |
| **Left** / **Right** | Move |
| **T** | Tilt |

Movement and fire keys drive the player-one input port. Separate player-two movement and fire inputs are not mapped,
so use one-player mode for normal play.

## Display settings

Edit the existing `[DEVICE.settings]` section in `SpaceInvaders.toml`, then close and reopen the computer to apply changes.
The display device has no settings dialog.

```toml
[DEVICE.settings]
scale = 2
colorOverlay = true
```

| Setting | Default | Description |
|:--------|:--------|:------------|
| `scale` | `2` | Integer pixel scale, at least `1`. At `2`, the initial display area is 448 by 512 pixels. |
| `colorOverlay` | `true` | Red and green bands over the monochrome image. Set to `false` for white pixels on black. |
| `soundEnabled` | `true` in GUI, `false` headless | Enable playback of external sound samples. |
| `soundSamplesDirectory` | `examples/space-invaders/sounds` | Directory containing the sound samples `0.wav` through `9.wav`. |

The display is already rotated into the upright arcade orientation. Sound effects use external WAV samples supplied
by the user. Missing samples or an unavailable audio device leave emulation running with a warning in the log.

## Troubleshooting

| Symptom | What to check |
|:--------|:--------------|
| Space Invaders is missing from the chooser | Check that the installation includes `config/SpaceInvaders.toml` and the display plugin. |
| Blank display or game does not start | Check that all four ROM settings are uncommented, the paths exist, and the files have the sizes and addresses listed above. Reopen the computer, then Reset and Run. |
| Game stops during the attract screen | Check that `memorySize` is `65536`, rather than `16384`. |
| Keys do nothing | Focus the display window, check that the CPU is running, and insert a coin before starting. |
| Display settings have no effect | Close and reopen the computer after saving the configuration. |
| Device initialization fails | Keep the template's connections to both CPU and memory. In a custom schema, CPU ports `1`–`5` must be free. |

## Programming the display

Programs draw by writing directly to byte memory and access the device's input, shift-register, and sound functions
with the 8080 `IN` and `OUT` instructions. The device reserves CPU ports `1` through `5`; a port's read and write
functions can differ.

### Screen memory layout

The framebuffer occupies `2400h` through `3FFFh`: 7168 bytes for 224 by 256 pixels, with one bit per pixel.
A set bit lights a pixel; a clear bit leaves it black. Each column occupies 32 consecutive bytes, starting at its
bottom edge. Bit 0 is the lowest pixel in a byte and bit 7 is the highest.

For screen coordinates `x = 0..223` and `y = 0..255`, with `(0, 0)` at the upper-left corner:

```text
hardwareY = 255 - y
address   = 2400h + x * 32 + (hardwareY / 8)   ; integer division
mask      = 1 << (hardwareY & 7)
```

To light one pixel without changing its neighbours, OR the byte with `mask`. To erase it, AND the byte with the
8-bit complement of `mask`.

| Pixel | Address | Mask |
|:------|:--------|:-----|
| Upper-left `(0, 0)` | `241Fh` | `80h` |
| Lower-left `(0, 255)` | `2400h` | `01h` |
| Upper-right `(223, 0)` | `3FFFh` | `80h` |
| Lower-right `(223, 255)` | `3FE0h` | `01h` |

There is no colour attribute memory. With `colorOverlay = true`, lit pixels are red in rows `0`–`63`, white in
rows `64`–`183`, and green in rows `184`–`255`. With the overlay disabled, all lit pixels are white.

### I/O ports

| Port | Read | Write |
|:-----|:-----|:------|
| `1` | Coin, start, fire, and movement inputs | Ignored |
| `2` | Cabinet inputs, including tilt | Shift amount (low three bits) |
| `3` | Shift-register result | Sound control 1 |
| `4` | Returns zero | Shift data |
| `5` | Returns zero | Sound control 2 |

#### Keyboard input

`IN 1` returns the following bits. Keyboard inputs are active high: a pressed key sets its bit and releasing the key
clears it. Reading a port does not clear the inputs.

| Bit | Mask | Meaning |
|:----|:-----|:--------|
| `0` | `01h` | Coin (**C**) |
| `1` | `02h` | Start two-player game (**2**) |
| `2` | `04h` | Start one-player game (**1**) |
| `3` | `08h` | Always set |
| `4` | `10h` | Fire (**Space**) |
| `5` | `20h` | Move left (**Left**) |
| `6` | `40h` | Move right (**Right**) |
| `7` | `80h` | Always clear |

On `IN 2`, only bit 2 (`04h`) is mapped, for tilt (**T**). Other bits return zero; cabinet DIP switches and separate
player-two movement/fire inputs are not implemented. For example, `IN 1` followed by `ANI 10h` tests whether Fire is held.

#### Hardware shift register

The 16-bit shift register helps programs align sprite data. `OUT 4` loads a new byte into the high half and moves the
previous high byte into the low half. `OUT 2` selects a shift amount from `0` to `7`; other bits are ignored.
`IN 3` returns the shifted eight-bit result:

```text
OUT 4: register = (newByte << 8) | (oldRegister >> 8)
OUT 2: amount   = value & 7
IN 3:  result   = (register >> (8 - amount)) & FFh
```

Writing `AAh`, then `55h`, to port `4` leaves `55AAh` in the register. Selecting shift amount `2` makes `IN 3` return `56h`.
Reading the result does not change the register. Reset clears both the register and shift amount.

#### Sound output

`OUT 3` and `OUT 5` latch sound-control bits. In addition to enabling playback in the configuration, software must
set bit 5 of port `3` to enable the emulated amplifier.

| Bit | `OUT 3` | `OUT 5` |
|:----|:--------|:--------|
| `0` | UFO loop (`0.wav`) | Fleet step 1 (`4.wav`) |
| `1` | Shot (`1.wav`) | Fleet step 2 (`5.wav`) |
| `2` | Player hit (`2.wav`) | Fleet step 3 (`6.wav`) |
| `3` | Invader hit (`3.wav`) | Fleet step 4 (`7.wav`) |
| `4` | Bonus (`9.wav`) | UFO hit (`8.wav`) |
| `5` | Amplifier enable | Ignored |
| `6`–`7` | Ignored | Ignored |

One-shot effects trigger when their bit changes from 0 to 1 while the amplifier is enabled. Clear the bit before
setting it again to replay an effect; repeatedly writing the same value does not retrigger it. Keep the other
control bits when changing an effect. The UFO sample loops while port `3` bits 0 and 5 are both set.
Clearing bit 0 stops the UFO loop; clearing bit 5 stops all sounds. Reset clears both sound latches and stops playback.

For example, writing `20h`, then `22h`, then `20h` to port `3` enables sound, triggers a shot, and clears its trigger
bit ready for another shot.

### Raster interrupts

A frame clock alternates 8080 `RST 1` and `RST 2` interrupts at 120 half-frames per second and refreshes the display
at approximately 60 Hz. Timing follows the host clock rather than cycle-exact scanlines. Interrupts also run during
[headless automation]({{ site.baseurl }}/application/automation), where no display window or keyboard controls are available.

`RST 1` enters the handler at `0008h`; `RST 2` enters the handler at `0010h`. Before enabling interrupts with `EI`,
initialize a stack in writable RAM and install handlers at both vectors. A handler must preserve the registers it
changes and return with `RET`; use `EI` before returning to allow subsequent interrupts.

The arcade ROMs already supply these handlers. For your own handlers, use a separate computer configuration and
remove the ROM images and write protection covering the vector addresses. A program that does not use interrupts
can keep them disabled with `DI`; the display still refreshes.

### Example: draw and read Fire

This program clears the framebuffer, draws a vertical line at column 112, and lights the upper-left pixel while
**Space** is held. It starts at `2000h`, in writable RAM in the bundled configuration, and leaves interrupts disabled.
It does not need the arcade ROMs.

1. Stop the game and open a new source file in the editor. Paste the program below and compile it with
   [`as-8080`]({{ site.baseurl }}/altair8800/as-8080).
2. Click **Reset**, then use **Jump to location** to set the next instruction address to `0x2000`.
3. Open the display, click **Run**, then focus the display window and hold/release **Space**.

```asm
org 2000h

di
lxi sp,2400h        ; stack grows down into RAM below the framebuffer
lxi h,2400h
lxi b,1C00h        ; clear all 7168 framebuffer bytes
clear_screen:
mvi m,0
inx h
dcx b
mov a,b
ora c
jnz clear_screen

lxi h,3200h        ; start of column 112: 2400h + 112 * 32
mvi b,32
draw_column:
mvi m,0FFh
inx h
dcr b
jnz draw_column

poll_fire:
in 1
ani 10h
jz fire_released
mvi a,80h          ; bit 7 at 241Fh is the upper-left pixel
jmp write_pixel
fire_released:
xra a
write_pixel:
sta 241Fh
jmp poll_fire
```

The example writes the whole byte at `241Fh`, clearing the other seven pixels in that byte. In a program that shares
that byte with other graphics, use the read–modify–write operations described above instead.
