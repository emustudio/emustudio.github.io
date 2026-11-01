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

On the **Debugger** tab, double-click `88-hdsk` in the device list. In SIMH mode, the window shows sixteen drives:

![SIMH HDSK window with numbered disk selection, status, geometry and mounted image]({{ site.baseurl }}/assets/altair8800/88-hdsk-gui.png){: style="max-width: 611px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Drive selector**. Choose a SIMH disk or a MITS removable/fixed platter to inspect. |
| <span class="circle">2</span> | **Activity**. Inspect controller status and the most recent command. |
| <span class="circle">3</span> | **Geometry and position**. Read the selected disk’s parameters and current position. |
| <span class="circle">4</span> | **Mounted image**. Read the path and protection state of the selected image. |

MITS mode shows four units, each with a removable (`R`) and fixed (`F`) platter:

![MITS HDSK window with numbered platter selection, activity and fixed geometry]({{ site.baseurl }}/assets/altair8800/88-hdsk-mits-gui.png){: style="max-width: 660px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Drive selector**. Choose a SIMH disk or a MITS removable/fixed platter to inspect. |
| <span class="circle">2</span> | **Activity**. Inspect controller status and the most recent command. |
| <span class="circle">3</span> | **Geometry and position**. Read the selected disk’s parameters and current position. |
| <span class="circle">4</span> | **Mounted image**. Read the path and protection state of the selected image. |

## Settings dialog

Select `88-hdsk` in the device list and click **Show settings...**.

### SIMH drive settings

![SIMH HDSK drive settings with numbered drive selection, image, media actions, parameters and Save]({{ site.baseurl }}/assets/altair8800/88-hdsk-settings-drive-settings.png){: style="max-width: 643px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Drive selector**. Choose a SIMH drive or a MITS unit’s removable (**R**) or fixed (**F**) platter. |
| <span class="circle">2</span> | **Image**. Enter the disk-image path. |
| <span class="circle">3</span> | **Browse**. Choose an existing disk image. |
| <span class="circle">4</span> | **Create**. Create an image for the selected drive. |
| <span class="circle">5</span> | **Unmount**. Remove the selected image when saving. |
| <span class="circle">6</span> | **Unmount all**. Remove all controller images when saving. |
| <span class="circle">7</span> | **Read-only**. Prevent writes to the selected image. |
| <span class="circle">8</span> | **Sectors per track**. Set SIMH geometry; MITS geometry is fixed. |
| <span class="circle">9</span> | **Sector size**. Set SIMH sector size; MITS uses 256-byte sectors. |
| <span class="circle">10</span> | **Set default**. Restore the standard geometry where editable. |
| <span class="circle">11</span> | **Save**. Apply and save the selected images and geometry. |

### MITS drive settings

![MITS HDSK drive settings with numbered platter selection, read-only protection and fixed parameters]({{ site.baseurl }}/assets/altair8800/88-hdsk-mits-settings-drive-settings.png){: style="max-width: 707px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Drive selector**. Choose a SIMH drive or a MITS unit’s removable (**R**) or fixed (**F**) platter. |
| <span class="circle">2</span> | **Image**. Enter the disk-image path. |
| <span class="circle">3</span> | **Browse**. Choose an existing disk image. |
| <span class="circle">4</span> | **Create**. Create an image for the selected drive. |
| <span class="circle">5</span> | **Unmount**. Remove the selected image when saving. |
| <span class="circle">6</span> | **Unmount all**. Remove all controller images when saving. |
| <span class="circle">7</span> | **Read-only**. Prevent writes to the selected image. |
| <span class="circle">8</span> | **Sectors per track**. Set SIMH geometry; MITS geometry is fixed. |
| <span class="circle">9</span> | **Sector size**. Set SIMH sector size; MITS uses 256-byte sectors. |
| <span class="circle">10</span> | **Set default**. Restore the standard geometry where editable. |
| <span class="circle">11</span> | **Save**. Apply and save the selected images and geometry. |

### Controller selection

![HDSK controller settings with numbered controller model and connection requirements]({{ site.baseurl }}/assets/altair8800/88-hdsk-settings-controller.png){: style="max-width: 643px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Controller**. Select the SIMH interface or the MITS controller behind 88-4PIO. The two models need different connections. |
| <span class="circle">2</span> | **Save**. Save the model selection; reopen the computer to initialize the selected controller. |

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

Use **Show settings...** to mount, create, or eject images and set their startup geometry. The device window's
**Apply geometry** button changes geometry for the current session. The configuration keys are `imageN`,
`sectorSizeN`, and `sectorsPerTrackN`, where `N` is the zero-based drive number.

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

## Configuration file

Set these keys in the existing `[DEVICE.settings]` table for `88-hdsk` in the computer's TOML file.

|---
| Key | Default | Values | Meaning
|-|-|-|-
| `controllerType` | `"SIMH"` | `"SIMH"`, `"MITS"` | Controller model; requires matching schema connections and reopening the computer |
| `image0` … `image15` | Omitted (drive unmounted) | File path | Startup image: SIMH uses drives 0–15 and creates missing files; MITS uses platter slots 0–7 and requires an existing image of exactly 4,988,928 bytes
| `sectorSize0` … `sectorSize15` | 128 | 128, 256, 512, 1024 | Physical sector size in bytes; SIMH only
| `sectorsPerTrack0` … `sectorsPerTrack15` | 32 | 1–255 | Physical sectors per track; SIMH only
| `readOnly0` … `readOnly7` | `false` | `true`, `false` | Write protection for MITS platter slots; ignored in SIMH mode
|---

Relative paths resolve against the host working directory. GUI mounts apply to the current session. Use the settings dialog or edit the computer configuration for
startup persistence. In SIMH mode, the CPU port is fixed at `FDh`. Writes modify the mounted file directly and may extend it.
