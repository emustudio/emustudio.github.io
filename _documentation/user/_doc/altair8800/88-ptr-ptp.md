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

## GUI and device context

Open the device window to load, rewind, or eject a reader file; choose or eject a punch file; and inspect reader
progress. The plugin also publishes a paper tape context so another device, such as `simh-pseudo`, can attach, detach,
and rewind tapes without duplicating file handling.

## Reset and configuration

Reset rewinds an attached reader and clears its EOF state; it does not detach either file or truncate the punch again.
Writing `03h` to the status port clears EOF without rewinding, so a reader still at the end returns `1Ah` again.

There are no plugin-specific configuration keys or settings dialog. Attach files in the device window, or from guest
software through [SIMH pseudo-device commands]({{ site.baseurl }}/altair8800/simh-pseudo#paper-tape-commands-3-5-16-17).
In a custom computer, `simh-pseudo` requires a connection to this device's paper tape context, as well as CPU and memory.
