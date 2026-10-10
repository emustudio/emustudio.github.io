---
layout: default
title: Device "88-hdsk"
nav_order: 9
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
16-bit little-endian DMA address. Drive, sector, and track numbers are zero-based. The transfer happens on the first
`IN FDh` **after all six parameter bytes have been written**. It returns `00h` on success or `01h` if the drive is
unattached, memory is unavailable, or an I/O operation fails. A further `OUT` before that result read discards the
completed packet.

The controller normalizes a drive number outside 0–15 to drive 0, an out-of-range sector to sector 0, and an
out-of-range track to track 0. DMA addresses wrap modulo the memory size. These cases do not automatically return an
error, so validate the packet in guest software. Memory ROM protections still apply to reads into guest memory.

For command `04h`, write the drive number next, then read **19 bytes** from `FDh`. The returned parameter block is:

|---
| Byte offsets | Field | Meaning
|-|-|-
| 0–1 | SPT | 128-byte logical records per track, little-endian
| 2 | BSH | `5` (4 KiB allocation blocks)
| 3 | BLM | `1Fh`
| 4 | EXM | `1`
| 5–6 | DSM | Allocation block count minus 1, little-endian; derived from image capacity after six reserved tracks
| 7–8 | DRM | `03FFh` (1,024 directory entries minus 1)
| 9–10 | AL0, AL1 | `FFh`, `00h`
| 11–12 | CKS | `0000h`
| 13–14 | OFS | `0006h` reserved tracks
| 15 | PSH | `log2(sectorSize / 128)`
| 16 | PHM | `sectorSize / 128 - 1`
| 17–18 | Sector size | Physical sector size in bytes, little-endian
|---

A controller reset discards the pending packet; it keeps mounted images and their geometry.

## Images and geometry

Up to 16 raw images can be mounted. Default geometry is 32 sectors per track and 128 bytes per sector. An empty
or unattached image reports 2,048 tracks (8 MiB at the default geometry); a nonempty image derives its track count
from its length, rounded up to a whole track and capped at 65,536 tracks. Each drive can instead use a power-of-two sector size from 128 through 1,024 bytes and 1 through 255 sectors
per track. Reads beyond a short image return `E5h`, matching empty CP/M media.

Open the device window to mount, create, or eject images and change per-drive geometry. The same values can be set in
the plugin settings with `imageN`, `sectorSizeN`, and `sectorsPerTrackN`, where `N` is the zero-based drive number.

## Configuration file

|---
| Key | Default | Values | Meaning
|-|-|-|-
| `image0` … `image15` | None | Writable file path | Image to attach on startup; a missing file is created
| `sectorSize0` … `sectorSize15` | 128 | 128, 256, 512, 1024 | Physical sector size in bytes
| `sectorsPerTrack0` … `sectorsPerTrack15` | 32 | 1–255 | Physical sectors per track
|---

Relative paths resolve against the host working directory. GUI mounts and geometry changes apply to the current
session; edit the computer configuration for startup persistence. There is no separate settings dialog, and the
CPU port is fixed at `FDh`. Writes modify the mounted file directly and may extend it.

## Read example

This 8080 program reads drive 0, track 0, sector 0 into guest address `2000h` and leaves the status in A:

```
mvi a, 2
out 0FDh
xra a
out 0FDh     ; drive 0
out 0FDh     ; sector 0
out 0FDh     ; track low
out 0FDh     ; track high
out 0FDh     ; DMA low
mvi a, 20h
out 0FDh     ; DMA high
in 0FDh      ; execute transfer and read status
hlt
```

Mount an image first and ensure the destination is writable memory with room for one physical sector.
