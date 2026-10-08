---
layout: default
title: Space Invaders
description: "Set up Space Invaders in emuStudio — load arcade ROMs, use keyboard controls, and configure the display."
nav_order: 9
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

The display is already rotated into the upright arcade orientation. Sound effects are not implemented.

## Troubleshooting

| Symptom | What to check |
|:--------|:--------------|
| Space Invaders is missing from the chooser | Check that the installation includes `config/SpaceInvaders.toml` and the display plugin. |
| Blank display or game does not start | Check that all four ROM settings are uncommented, the paths exist, and the files have the sizes and addresses listed above. Reopen the computer, then Reset and Run. |
| Game stops during the attract screen | Check that `memorySize` is `65536`, rather than `16384`. |
| Keys do nothing | Focus the display window, check that the CPU is running, and insert a coin before starting. |
| Display settings have no effect | Close and reopen the computer after saving the configuration. |
| Device initialization fails | Keep the template's connections to both CPU and memory. In a custom schema, CPU ports `1`–`4` must be free. |

## Hardware overview

The bundled schema connects the assembler to memory, the CPU to memory, and the display device to both CPU and memory.
For custom programs, the framebuffer occupies `2400h` through `3FFFh`, with one bit per pixel.

| Port | Read | Write |
|:-----|:-----|:------|
| `1` | Coin, start, fire, and movement inputs | Ignored |
| `2` | Cabinet inputs, including tilt | Shift amount (low three bits) |
| `3` | Shift-register result | Ignored; sound is not emulated |
| `4` | Returns zero | Shift data |

A frame clock alternates 8080 `RST 1` and `RST 2` interrupts at 120 half-frames per second and refreshes the display
at approximately 60 Hz. Timing follows the host clock rather than cycle-exact scanlines. Interrupts also run during
[headless automation]({{ site.baseurl }}/application/automation), where no display window or keyboard controls are available.
