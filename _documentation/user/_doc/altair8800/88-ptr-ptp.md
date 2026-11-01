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

On the **Debugger** tab, double-click `88-ptr-ptp` in the device list. The **Reader** tab is shown below:

![Paper tape reader window with numbered directory, file list, load action, status, progress and reader controls]({{ site.baseurl }}/assets/altair8800/88-ptr-ptp-gui-reader.png){: style="max-width: 800px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Directory**. Choose the directory to list. |
| <span class="circle">2</span> | **Browse directory**. Select a paper-tape directory. |
| <span class="circle">3</span> | **Tape files**. Select the file to load. |
| <span class="circle">4</span> | **Refresh**. Reload the directory listing. |
| <span class="circle">5</span> | **Load**. Load the selected file into the reader. |
| <span class="circle">6</span> | **Reader status**. Inspect the loaded file and read position. |
| <span class="circle">7</span> | **Rewind**. Return to the beginning of the loaded tape. |
| <span class="circle">8</span> | **Eject**. Unload the reader’s tape. |

Select the **Punch** tab to manage the output tape:

![Paper tape punch window with numbered output status, Save tape and Close output controls]({{ site.baseurl }}/assets/altair8800/88-ptr-ptp-gui-punch.png){: style="max-width: 800px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Punch status**. Inspect the output file and punched-byte count. |
| <span class="circle">2</span> | **Save tape**. Choose an output file for punched bytes. |
| <span class="circle">3</span> | **Close output**. Finish writing and close the punch output. |

## Settings dialog

Select `88-ptr-ptp` in the device list and click **Show settings...**:

![Paper tape settings with numbered startup checkbox, fixed CPU ports and Save button]({{ site.baseurl }}/assets/altair8800/88-ptr-ptp-settings.png){: style="max-width: 223px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Show GUI at startup**. Open the reader/punch window when the computer opens. |
| <span class="circle">2</span> | **CPU ports**. The reader/punch uses fixed status port `12h` and data port `13h`. |
| <span class="circle">3</span> | **Save**. Save the startup preference. |

## Reset and configuration

The plugin also publishes a paper tape context so `simh-pseudo` can attach, detach and rewind tapes.

Reset rewinds an attached reader and clears its EOF state; it does not detach either file or truncate the punch again.
Writing `03h` to the status port clears EOF without rewinding, so a reader still at the end returns `1Ah` again.

Attach files in the device window, or from guest
software through [SIMH pseudo-device commands]({{ site.baseurl }}/altair8800/simh-pseudo#paper-tape-commands-3-5-16-17).
In a custom computer, `simh-pseudo` requires a connection to this device's paper tape context, as well as CPU and memory.

## Configuration file

| Key | Default | Description |
|:----|:--------|:------------|
| `showGuiAtStartup` | `false` | Open the device window when the computer is initialized in GUI mode. |
