---
layout: default
title: Device "88-ptr-ptp"
nav_order: 13
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

Status bit 0 is set while an attached reader has another byte available. Status bit 1 is always set because the punch
can accept a byte. The first read after the reader reaches the end of its file returns CP/M end-of-file byte `1Ah`;
later reads return `00h` until the tape is rewound, replaced, or its end-of-file state is cleared.

Punch output is written and flushed immediately. Select a new output file before reusing a file whose contents must be
preserved.

## GUI and device context

Open the device window to load, rewind, or eject a reader file; choose or eject a punch file; and inspect reader
progress. The plugin also publishes a paper tape context so another device, such as `simh-pseudo`, can attach, detach,
and rewind tapes without duplicating file handling.
