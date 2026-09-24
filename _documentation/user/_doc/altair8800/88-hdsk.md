---
layout: default
title: Device "88-hdsk"
nav_order: 15
parent: MITS Altair8800
permalink: /altair8800/88-hdsk
---

{% include analytics.html category="Altair8800" %}

# SIMH HDSK controller

The `88-hdsk` plugin implements the SIMH Altair HDSK extension. HDSK is a synthetic host-backed block device for SIMH
software, not a physical MITS multi-port controller. It uses port `FDh` and transfers sector data directly between a
disk image and guest memory.

## Command packet

Write one command byte followed by its packet bytes to port `FDh`. Read the same port for the command result.

|---
| Command | Operation
|-|-
|`01h` | Reset controller
|`02h` | Read one sector into guest memory
|`03h` | Write one sector from guest memory
|`04h` | Return drive parameters
|---

Read and write use a seven-byte packet: command, drive number, sector number, 16-bit little-endian track number, and
16-bit little-endian DMA address. Invalid drives, geometry, memory ranges, or I/O operations return an error status.

## Images and geometry

Up to 16 raw images can be mounted. Default geometry is 2,048 tracks, 32 sectors per track, and 128 bytes per sector
(8 MiB). Each drive can instead use a power-of-two sector size from 128 through 1,024 bytes and 1 through 255 sectors
per track. Reads beyond a short image return `E5h`, matching empty CP/M media.

Open the device window to mount, create, or eject images and change per-drive geometry. The same values can be set in
the plugin settings with `imageN`, `sectorSizeN`, and `sectorsPerTrackN`, where `N` is the zero-based drive number.
