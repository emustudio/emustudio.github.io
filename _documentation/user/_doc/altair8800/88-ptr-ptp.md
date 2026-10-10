---
layout: default
title: Device "88-ptr-ptp"
nav_order: 12
parent: MITS Altair8800
permalink: /altair8800/88-ptr-ptp
---

{% include analytics.html category="Altair8800" %}

# Paper tape reader and punch

The `88-ptr-ptp` plugin provides a paper tape reader (PTR) and paper tape punch (PTP) through the Altair serial-style
paper tape ports. It streams files byte for byte; Intel HEX, binary, and other paper tape formats are not interpreted by
the device.

## CPU ports

|---
| Address | Read | Write
|-|-|-
|`12h` | Status bits | Write `03h` to clear the reader end-of-file state
|`13h` | Next reader byte | Append one byte to the punch file
|---

Status bit 0 is set while a reader is attached and its EOF state has not yet been set. It remains set after the last
file byte until the next data read returns the EOF marker. Status bit 1 is always set because the punch
can accept a byte. The first read after the reader reaches the end of its file returns CP/M end-of-file byte `1Ah`;
later reads return `00h` until the tape is rewound, replaced, or its end-of-file state is cleared.

Attaching a punch file creates or **truncates** it. Each output byte is written and flushed immediately. Status bit 1
is also set with no punch attached; in that case, output bytes are discarded. A reader with no file attached returns
`00h`.

## GUI overview

On the **Emulator** tab, double-click `88-ptr-ptp` in the device list. The **Reader** tab is shown below:

{% include annotated-screenshot.html image="/assets/altair8800/88-ptr-ptp-gui-reader.png" alt="Paper tape reader window with numbered directory, file list, load action, status, progress and reader controls" width=790 points="1:21.01:5.95|2:29.37:31.08|3:22.03:90.27|4:93.67:19.73|5:93.67:73.24|6:58.73:90.00" %}

{: .list}
| <span class="circle">1</span> | **Directory**. Browse for the folder containing paper tapes.
| <span class="circle">2</span> | **Available tapes**. Select a readable `.pt`, `.bin` or `.hex` file. The device streams the file’s bytes without interpreting its format.
| <span class="circle">3</span> | **Refresh / Load**. Refresh the list after changing files on disk; **Load** attaches the selected reader tape.
| <span class="circle">4</span> | **Reader status**. Shows the attached filename and whether the reader is ready or at end of tape.
| <span class="circle">5</span> | **Progress**. Shows bytes consumed by guest software; loading a tape does not execute it.
| <span class="circle">6</span> | **Rewind / Eject**. Rewind to byte zero or detach the reader file.

Select the **Punch** tab to manage the output tape:

{% include annotated-screenshot.html image="/assets/altair8800/88-ptr-ptp-gui-punch.png" alt="Paper tape punch window with numbered output status, Save tape and Close output controls" width=790 points="1:93.67:19.73|2:52.78:89.19|3:76.71:89.19" %}

{: .list}
| <span class="circle">1</span> | **Punch status**. Shows the output file and current punch state.
| <span class="circle">2</span> | **Save tape**. Choose an output file to receive guest writes. Opening it creates or truncates the file immediately.
| <span class="circle">3</span> | **Close output**. Close the punch file. Further guest output is discarded until another output tape is attached.

## Settings dialog

Select `88-ptr-ptp` in the device list and click **Show settings...**:

{% include annotated-screenshot.html image="/assets/altair8800/88-ptr-ptp-settings.png" alt="Paper tape settings with numbered startup checkbox, fixed CPU ports and Save button" width=231 points="1:89.18:18.26|2:8.23:66.96|3:56.71:80.87" %}

{: .list}
| <span class="circle">1</span> | **Show GUI at startup**. Open the reader/punch window when the computer is initialized in GUI mode.
| <span class="circle">2</span> | **CPU ports**. The status and data ports are fixed at `12h` and `13h`; this dialog does not remap them.
| <span class="circle">3</span> | **Save**. Persist the startup preference and close the dialog. Press **Esc** to discard edits.

## Configuration file

| Key | Default | Description |
|:----|:--------|:------------|
| `showGuiAtStartup` | `false` | Open the device window when the computer is initialized in GUI mode. |

The plugin also publishes a paper tape context so `simh-pseudo` can attach, detach and rewind tapes.

## Reset and configuration

Reset rewinds an attached reader and clears its EOF state; it does not detach either file or truncate the punch again.
Writing `03h` to the status port clears EOF without rewinding, so a reader still at the end returns `1Ah` again.

Attach files in the device window, or from guest
software through [SIMH pseudo-device commands]({{ site.baseurl }}/altair8800/simh-pseudo#paper-tape-commands-3-5-16-17).
In a custom computer, `simh-pseudo` requires a connection to this device's paper tape context, as well as CPU and memory.
