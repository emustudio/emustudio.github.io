---
layout: default
title: Space Invaders hardware
nav_order: 16
parent: MITS Altair8800
permalink: /altair8800/space-invaders
---

{% include analytics.html category="Altair8800" %}

# Space Invaders hardware

The `Space Invaders` virtual computer combines the 8080 CPU, 16 KiB byte memory, and the
`spaceinvaders-display` device. The device implements the original input ports, 16-bit shift register, rotated
framebuffer, and alternating raster interrupts needed by compatible game software.

emuStudio does not distribute the copyrighted arcade ROMs. Configure legally obtained `invaders.h`, `invaders.g`,
`invaders.f`, and `invaders.e` images in `SpaceInvaders.toml`; the template contains their standard load addresses.

## Controls

|---
| Key | Input
|-|-
|`C` | Insert coin
|`1` / `2` | Start one-player / two-player game
|Space | Fire
|Left / Right | Move
|`T` | Tilt
|---

## Hardware contract

CPU ports 1 and 2 expose cabinet inputs. Ports 2 through 4 implement the shift amount, shift-register result, and
shift data used by the arcade board. The 224 by 256 display reads the one-bit framebuffer at `2400h` through `3FFFh`
and rotates it into screen orientation.

A daemon frame clock runs at 120 half-frames per second and alternates 8080 `RST 1` and `RST 2` interrupts. Interrupts
remain active in headless mode, so automation exercises the same machine timing without opening the display window.

The device settings accept integer `scale` (minimum 1) and boolean `colorOverlay`. The overlay reproduces the colored
cellophane regions over the otherwise monochrome display.
