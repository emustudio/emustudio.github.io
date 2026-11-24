---
layout: default
title: Memory "byte-mem"
nav_order: 5
parent: BrainDuck
permalink: /brainduck/byte-mem
---

{% include analytics.html category="BrainDuck" %}

# Memory `byte-mem`

The bundled BrainDuck configuration shares 65,536 bytes between instructions and data. Inspect either region in the byte-memory window. The CPU places the data pointer immediately after the program.

The memory window lets you inspect and edit cells, load and save images, and search for text or bytes. See the
[full byte-mem guide]({{ site.baseurl }}/altair8800/byte-mem) for these controls and all configuration keys, including
memory size, startup images, ROM ranges, and banks. BrainDuck programs normally use a single writable bank.
