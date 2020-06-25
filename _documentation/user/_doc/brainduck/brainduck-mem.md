---
layout: default
title: Memory "brainduck-mem"
nav_order: 4
parent: BrainDuck
permalink: /brainduck/mem
---

# Memory "brainduck-mem"

BrainDuck memory is used as a part of BrainDuck computer, which acts as the operating memory, holding both of brainfuck program and data.

BrainDuck CPU reads/writes instructions from/to the memory. Memory updates its cells and notifies debugger in emuStudio about the update.

Memory plugin contains a simple graphical window, a GUI, which provides a set of the following features:

- paginated view of memory cells, arranged into 16x16 table per page.
- cells are displayed in hexadecimal form and can be changed directly by the user.
- there are hard-coded 256 pages, so the memory size is 256 * (16x16) = 64 kB

## Graphical user interface (GUI)

In the following screenshot, it is possible to see GUI of `brainduck-mem`.

![BrainDuck memory window]({{ site.baseurl }}/assets/brainduck/brainduck-mem.png)

- *A*: Shows currently displayed page. Can be edited manually by entering a number and pressing the <kbd>ENTER</kbd> key
- *B*: By double-clicking on a memory cell, the cell editor is enabled and the user can overwrite the content of the cell. Supported number formats are decimal or hexadecimal. The hexadecimal number must begin with `0x` prefix.
- *C*: By clicking on button `Clear` the whole memory is cleared. By clicking on `Page down`, the page number is increased; button `Page up` decreases the page number.
