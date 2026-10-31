---
layout: default
title: Device "88-mds"
nav_order: 10
parent: MITS Altair8800
permalink: /altair8800/88-mds
---

{% include analytics.html category="Altair8800" %}

# MITS 88-MDS minidisk controller

## Introduction

The **88-MDS** was MITS' 5.25-inch minidisk system for the Altair. It combined an external floppy drive with
controller boards inside the computer, providing storage for programs and data without reloading them from tape.
The single-sided, single-density disks had 35 tracks and held about 70 KB. Altair BASIC and Altair DOS were
available for this system.

![Original MITS Altair minidisk drive in its blue cabinet, with drive-address and write-protect indicators]({{ site.baseurl }}/assets/altair8800/88-mds-minidisk.jpg){: style="max-width: 640px; width: 100%;" }

*Altair minidisk drive. Photo from [deramp.com's Altair collection][hardware-photo]{:target="_blank"}.*

The `88-mds` plugin emulates the MITS 88-MDS minidisk controller and up to 16 drives. Each raw image has 35 tracks,
16 sectors per track, and 137 bytes per sector, for a minimum image size of 76,720 bytes.

[hardware-photo]: https://deramp.com/altair.html

### Original manual

[MITS Altair 88-MDS Minidisk Documentation — Preliminary (PDF)][manual]{:target="_blank"} describes installation,
controller programming, disk format, and schematics for the minidisk system.

## CPU ports

|---
| Address | Purpose
|-|-
|`08h` | Drive select and controller status
|`09h` | Track positioning and sector status
|`0Ah` | Sector data
|---

The command and status protocol follows the MITS minidisk controller. Selecting a drive loads its head automatically;
the unload-head command is accepted but ignored. Data transfers use programmed I/O, not DMA.

These addresses overlap the 88-DCDD and 88-PIO. Connect only the controller required by the guest software.

## Programming protocol

Write to `08h` to select a drive: bits 3–0 choose drive 0–15, and bit 7 disables the selected drive when set. An
unmounted drive cannot be selected. Read `08h` for **active-low** status:

|---
| Bit | Meaning of 0
|-|-
| 7 | Read data available
| 6 | At track 0
| 4 | Head movement allowed
| 3 | Head loaded (compatibility status)
| 2 | Head loaded
| 1 | Head movement allowed (compatibility status)
| 0 | Write sequence enabled
|---

With a mounted drive selected at track 0, status is `21h`. With no selected drive, status is `FFh` and data reads
return `00h`. Status bit 5 is unused and remains 1.

Write control bits to `09h`:

|---
| Bit | Action
|-|-
| 0 | Step inward, increasing track; stops at track 34
| 1 | Step outward, decreasing track; stops at track 0
| 7 | Begin a write at byte offset 0 in the current sector
|---

Other control bits have no implemented effect; head unload is ignored, and interrupts are not generated.

Reading `09h` returns `C0h` plus the sector number in bits 4–1 and a toggling sector-true bit in bit 0. On every
read where bit 0 becomes 0, the sector advances modulo 16. Poll for bit 0 = 0 and the required sector before a transfer.
Selecting a drive or stepping a track resets this sequence; the first sector-true-low result is sector 0.

Read 137 consecutive bytes from `0Ah` for a full raw sector. Further data reads repeat that sector unless another
sector-position poll advances it. To write, select the sector, write `80h` to `09h`, then write 137 bytes to `0Ah`.
A complete sector is flushed to the image. Changing the track/sector, deselecting, or ejecting also flushes a partially
written buffer; write full sectors to avoid retaining stale buffer bytes.

## Disk images and GUI

The implementation models the original 88-MDS geometry and protocol. It does not use the unrelated SIMH HDSK
extension; use the `88-hdsk` plugin for that interface.

## GUI overview

On the **Debugger** tab, double-click `88-mds` in the device list:

{% include annotated-screenshot.html image="/assets/altair8800/88-mds-gui.png" alt="88-MDS minidisk window with numbered drive, image and position, attach and detach controls" width=550 points="1:92.73:8.89|2:92.73:45.93|3:26.73:87.41|4:71.09:87.41" %}

{: .list}
| <span class="circle">1</span> | **Drive**. Choose drive 0–15 to inspect or attach an image; guest software selects its active drive independently.
| <span class="circle">2</span> | **Image and status**. Shows the host file, current track and sector, and whether the drive is selected or idle.
| <span class="circle">3</span> | **Attach image**. Choose an existing readable, writable raw minidisk image of at least 76,720 bytes.
| <span class="circle">4</span> | **Detach**. Flush pending writes and eject the image from the selected drive.

There is no separate settings dialog. Attachments made here last for the current session; use `image0`–`image15` in the configuration for startup mounts.

## Configuration file

Set these keys in the existing `[DEVICE.settings]` table for `88-mds` in the computer's TOML file.

| Key | Default | Values | Meaning |
|---|---|---|---|
| `image0` … `image15` | Omitted (drive unmounted) | Path to an existing readable, writable file of at least 76,720 bytes | Raw minidisk image attached to the corresponding drive on startup |

The suffix selects drive 0–15. Omit a key to leave that drive unmounted; an invalid image path prevents initialization.
Relative paths resolve against emuStudio's working directory. For example, to mount two images:

```toml
[DEVICE.settings]
image0 = "disks/basic.dsk"
image1 = "disks/data.dsk"
```

Close and reopen the computer to apply file changes. CPU ports (`08h`–`0Ah`) and disk geometry are fixed;
there are no settings for remapping ports, changing geometry, or write protection.

[manual]: https://deramp.com/downloads/altair/hardware/minidisk/88-MDS%20Minidisk%20Manual.pdf
