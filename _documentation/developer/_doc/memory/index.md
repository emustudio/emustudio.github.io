---
layout: default
title: Writing a memory
nav_order: 6
permalink: /memory/
---

{% include analytics.html category="developer_memory" %}

# Writing a memory

In emuStudio, plugin root class must either implement [Memory][memory]{:target="_blank"} interface, or can extend more
bloat-free [AbstractMemory][abstractMemory]{:target="_blank"} class.

Generally, a memory in an emulator is usually implemented as an array of bytes. Indexes to the array represent
addresses, and values are the memory cell values. In emuStudio, this kind of implementation is reflected by memory
context. Memory context should be a class which either implements [MemoryContext][memoryContext]{:target="_blank"}
interface, or extends [AbstractMemoryContext][abstractMemoryContext]{:target="_blank"} class. The latter provide
additional functionality - management of memory "listeners".

A memory listener (implementing [Memory.MemoryListener][memoryListener]{:target="_blank"} interface) can observe memory
value changes on all address range. But when the emulation is in running state, emuStudio turns off the memory
notifications to speed up the emulation.

## Shared GUI actions

Memory plugins with Swing interfaces can use emuLib's `GUI.runInBackground` for file and other blocking work. It
disables the supplied action, runs the task outside the event-dispatch thread, invokes success or error callbacks on
completion, and re-enables the action only after those callbacks finish. Errors are unwrapped before delivery.

`net.emustudio.emulib.runtime.ui.EraseMemoryAction` provides the standard clear-and-refresh behavior for a
`MemoryContext` and its table model. Pass the icon loaded by the plugin so resource lookup stays inside the isolated
plugin classloader. These helpers define the common UI lifecycle; individual memory plugins only supply their format-
specific load and dump operations.

[memory]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/memory/Memory.html
[memoryContext]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/memory/MemoryContext.html
[abstractMemory]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/memory/AbstractMemory.html
[abstractMemoryContext]: {{ site.baseurl}}/emulib_javadoc/net/emustudio/emulib/plugins/memory/AbstractMemoryContext.html
[memoryListener]: {{ site.baseurl}}/emulib_javadoc/net/emustudio/emulib/plugins/memory/Memory.MemoryListener.html
