---
layout: default
title: Device "88-mds"
nav_order: 14
parent: MITS Altair8800
permalink: /altair8800/88-mds
---

{% include analytics.html category="Altair8800" %}

# MITS 88-MDS minidisk controller

The `88-mds` plugin emulates the MITS 88-MDS minidisk controller and up to 16 drives. Each raw image has 35 tracks,
16 sectors per track, and 137 bytes per sector, for a minimum image size of 76,720 bytes.

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

## Disk images and GUI

Open the device window to mount or eject a raw image in any drive, create a new correctly sized image, and inspect the
selected drive, track, and sector. Changes are written directly to the mounted image. The plugin stores mounted image
paths in its settings so they can be restored with the virtual computer.

The implementation models the original 88-MDS geometry and protocol. It does not use the unrelated SIMH HDSK
extension; use the `88-hdsk` plugin for that interface.
