---
layout: default
title: Memory "byte-mem"
nav_order: 4
parent: BrainDuck
permalink: /brainduck/byte-mem
---

{% include analytics.html category="BrainDuck" %}

# Memory `byte-mem`

BrainDuck uses the shared byte-addressed memory plugin, with 65,536 bytes in its bundled configuration. Program
instructions and data share this memory. The CPU initializes its data pointer immediately after the program's terminating
instruction, so data cells do not start at address 0.

The memory window lets you inspect and edit cells, load and save images, and search for text or bytes. See the
[full byte-mem guide]({{ site.baseurl }}/altair8800/byte-mem) for these controls and all configuration keys, including
memory size, startup images, ROM ranges, and banks. BrainDuck programs normally use a single writable bank.
