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

A memory listener (implementing [MemoryContext.MemoryListener][memoryListener]{:target="_blank"} interface) can observe memory
value changes on all address range. But when the emulation is in running state, emuStudio turns off the memory
notifications to speed up the emulation.

## Cell type, size, and annotations

`MemoryContext<CellType>.getCellTypeClass()` identifies the cell type; byte-oriented consumers must check for
`Byte.class` during initialization. `getSize()` reports allocated cells. The CPU independently reports its instruction
address space through `CPU.getAddressSpaceSize()`, which the debugger uses for address validation and pagination.

Implement `annotations()` to expose a `MemoryContextAnnotations` store. emuLib's `Annotations` implements
`MemoryAnnotations` and can be owned by the memory plugin and shared with its context. `AbstractMemoryContext` supplies
listener management; the concrete context supplies storage and annotations.

Annotations belong to the plugin ID in each annotation. Producers remove their own entries with `removeAll(pluginID)`
when rebuilding them. Compilers can add `SourceCodeAnnotation` entries after writing generated cells:

```java
MemoryContextAnnotations annotations = memory.annotations();
annotations.removeAll(pluginID);
annotations.add(address, new SourceCodeAnnotation(
        pluginID, SourceCodePosition.of(line, column, sourcePath.toString())
));
```

The debugger uses these positions to open source files. In `byte-mem`, successful writes invalidate source annotations
at the written addresses, including while notifications are disabled. Clearing memory removes all source annotations.
An ignored ROM write leaves them intact. Annotations are keyed by address, without a bank identifier.

Byte-memory image loaders and dumpers use a UTF-8 `.meta` sidecar to restore or save source positions. Sidecar addresses
are absolute: loading a binary image at another address does not relocate its metadata.

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
[memoryListener]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/memory/MemoryContext.MemoryListener.html
