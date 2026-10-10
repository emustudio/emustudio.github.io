---
layout: default
title: Device "88-hdsk"
nav_order: 9
parent: MITS Altair8800
permalink: /altair8800/88-hdsk
---

{% include analytics.html category="Altair8800" %}

# Altair hard-disk controllers

The `88-hdsk` plugin supports the SIMH Altair HDSK extension (default) and a MITS controller behind 88-4PIO.
The following port protocol describes SIMH mode. HDSK is a synthetic host-backed block device for SIMH
software, not a physical MITS multi-port controller. It uses port `FDh` and transfers sector data directly between a
disk image and guest memory.

## GUI overview

On the **Emulator** tab, double-click `88-hdsk` in the device list. In SIMH mode, the window shows sixteen drives:

{% include annotated-screenshot.html image="/assets/altair8800/88-hdsk-gui.png" alt="SIMH HDSK window with numbered disk selection, status, geometry and mounted image" width=620 points="1:91.61:5.19|2:47.74:31.69|3:92.58:31.69|4:91.61:74.29" %}

{: .list}
| <span class="circle">1</span> | **Disk selection**. Select drive A–P to inspect; this does not change the drive selected by guest software.
| <span class="circle">2</span> | **Flags and settings**. Shows the selected drive, mount state, write protection and recent activity.
| <span class="circle">3</span> | **Geometry**. Inspect track count, edit sectors per track and sector size, then click **Apply geometry** for the current session.
| <span class="circle">4</span> | **Mounted image**. Shows the host file attached to the selected drive. Mount and create images in the settings dialog.

MITS mode shows four units, each with a removable (`R`) and fixed (`F`) platter:

{% include annotated-screenshot.html image="/assets/altair8800/88-hdsk-mits-gui.png" alt="MITS HDSK window with numbered platter selection, activity and fixed geometry" width=612 points="1:93.14:5.51|2:50.65:27.55|3:92.48:27.55|4:92.48:72.73" %}

{: .list}
| <span class="circle">1</span> | **Platter selection**. Inspect `0R`–`3F`; the number is the unit and the letter selects its removable or fixed platter.
| <span class="circle">2</span> | **Flags and settings**. Shows mount state, write protection and controller activity for that platter.
| <span class="circle">3</span> | **Geometry**. MITS geometry is fixed at 406 cylinders, two surfaces, 24 sectors per track and 256 bytes per sector.
| <span class="circle">4</span> | **Mounted image**. Shows the selected platter’s host file.

## Settings dialog

Select `88-hdsk` in the device list and click **Show settings...**.

### SIMH drive settings

{% include annotated-screenshot.html image="/assets/altair8800/88-hdsk-settings-drive-settings.png" alt="SIMH HDSK drive settings with numbered drive selection, image, media actions, parameters and Save" width=595 points="1:4.71:10.07|2:5.55:36.69|3:89.08:48.92|4:91.93:63.55|5:82.02:95.92" %}

{: .list}
| <span class="circle">1</span> | **Drive**. Choose the drive whose settings you are editing. Switching drives keeps the other drives’ pending edits.
| <span class="circle">2</span> | **Image**. Enter the startup image path, or use **Browse...** to select it.
| <span class="circle">3</span> | **Media actions**. **Create image** creates a host file. **Unmount** and **Unmount all** clear paths for saving; **Save** applies those detachments.
| <span class="circle">4</span> | **Parameters**. Set the sectors per track and physical sector size. **Set default** restores 32 sectors of 128 bytes; read-only protection is available only in MITS mode.
| <span class="circle">5</span> | **Save**. Persist the settings and apply mounts and geometry when the controller mode is unchanged. Press **Esc** to discard pending settings; a file already created with **Create image** remains on disk.

### MITS drive settings

{% include annotated-screenshot.html image="/assets/altair8800/88-hdsk-mits-settings-drive-settings.png" alt="MITS HDSK drive settings with numbered platter selection, read-only protection and fixed parameters" width=659 points="1:4.86:10.66|2:30.20:52.03|3:92.26:61.42" %}

{: .list}
| <span class="circle">1</span> | **Drive**. Choose a removable or fixed platter of unit 0–3.
| <span class="circle">2</span> | **Read-only**. Protect that image from guest writes. The image must already exist with the required size; **Create image** creates one of that size.
| <span class="circle">3</span> | **Parameters**. Geometry is fixed, so sector size, sectors per track and defaults are disabled.

### Controller selection

{% include annotated-screenshot.html image="/assets/altair8800/88-hdsk-settings-controller.png" alt="HDSK controller settings with numbered controller model and connection requirements" width=595 points="1:30.76:13.19|2:92.44:24.46" %}

{: .list}
| <span class="circle">1</span> | **Controller**. Choose SIMH or MITS. Save, update the schema connections and reopen the computer to switch controller models.
| <span class="circle">2</span> | **Connection requirements**. SIMH uses CPU port `FDh` and memory for DMA. MITS uses the 88-4PIO peripheral connection described below.

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
| `controllerType` | `"SIMH"` | `"SIMH"`, `"MITS"` | Controller model; requires matching schema connections and reopening the computer |
| `image0` … `image15` | None | Writable file path | Image to attach on startup; a missing file is created
| `sectorSize0` … `sectorSize15` | 128 | 128, 256, 512, 1024 | Physical sector size in bytes
| `sectorsPerTrack0` … `sectorsPerTrack15` | 32 | 1–255 | Physical sectors per track
|---

Relative paths resolve against the host working directory. GUI mounts apply to the current session. Use the settings dialog or edit the computer configuration for
startup persistence. In SIMH mode, the CPU port is fixed at `FDh`. Writes modify the mounted file directly and may extend it.

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

## MITS hard-disk mode

Set `controllerType = "MITS"` and connect the controller to an [`88-pio`]({{ site.baseurl }}/altair8800/88-pio)
configured as `boardType = "88-4PIO"` with at least two PIAs. Communication uses four PIA channels and handshake lines;
the controller does not attach directly to `FDh` or use the SIMH command packet above. Use guest software written for
the MITS hard-disk interface.

MITS mode accepts `image0` through `image7`, with optional `readOnly0` through `readOnly7` (default `false`). Each image
must already exist and contain exactly **4,988,928 bytes**: 406 cylinders, two surfaces, 24 sectors per surface and
256 bytes per sector. The GUI can create an image of this size. `sectorSizeN` and `sectorsPerTrackN` apply only to SIMH
mode. Mounted image writes change the host file directly.

The controller stages transfers through four 256-byte buffers and implements seek, sector read/write, buffer
transfers, interface-register access and formatting. Reset clears the controller state while retaining mounted media.
The device window shows the selected unit and activity; the settings dialog controls startup images and write protection.
