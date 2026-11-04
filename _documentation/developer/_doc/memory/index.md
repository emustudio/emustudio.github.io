---
layout: default
title: Writing a memory
nav_order: 6
permalink: /memory/
---

{% include analytics.html category="developer_memory" %}

# Writing a memory

A memory plugin root implements [Memory][memory]{:target="_blank"}, usually by extending
[AbstractMemory][abstractMemory]{:target="_blank"}.

Memory is often stored as an array whose indices are addresses and whose elements are cell values. emuStudio exposes
it through [MemoryContext][memoryContext]{:target="_blank"}; cells can have any Java type, not just `Byte`.
[AbstractMemoryContext][abstractMemoryContext]{:target="_blank"} provides listener management for implementations.

A memory listener (implementing [MemoryContext.MemoryListener][memoryListener]{:target="_blank"} interface) can observe memory
value changes on all address range. But when the emulation is in running state, emuStudio turns off the memory
notifications to speed up the emulation.

## Cell type, size, and annotations

`MemoryContext<CellType>.getCellTypeClass()` identifies the cell type; byte-oriented consumers must check for
`Byte.class` during initialization. Addresses and ranges count cells, including for word and typed-instruction memory.
`CPU.getAddressSpaceSize()` reports the debugger's exclusive upper bound of valid CPU addresses.
`MemoryContext.getSize()` reports the provider-defined size of its current storage. RAM/RASP retain their loaded
occupancy/high-water behavior; their CPU plugins expose the logical instruction domain even before a program is loaded.

`MemoryContext.peek(address)` reads through the provider's current CPU mapping without guest timing, device effects or
access events. Pure memory can use its ordinary read; providers with execution side effects override this operation.
CPU plugins wire inspection decoders through this view while execution continues through the normal memory interface.

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
An ignored ROM write leaves them intact. Annotations are keyed by CPU-visible address.

Declare compiler column units as described in [source-position coordinates]({{ site.baseurl }}/compiler/#source-position-coordinates).
The application's `ProgramIndex` combines source mappings, user annotations, execution-breakpoint presence, and indexed
instruction flow for one image/layout. Plugins continue to use emuLib contracts; they do not import application index
classes. Compiler reindexing preserves user annotations and other owners' metadata.

## Guest accesses

Memory-change listeners serve UI refresh. Guest read/write watchpoints use the CPU's execution probe, so they still work
when those notifications are disabled. Instruction fetches count as reads and write events describe attempts, including
writes rejected by ROM. Inspectors and disassemblers retain the original context and do not emit guest access events.

Compiler annotations remain address-based. The host's user labels/comments/bookmarks use separate
configured-machine/layout identity and CPU-visible addresses.
`ApplicationApi.getDebuggerMemory()` exposes labels, comments and the current instruction by CPU address. A plugin that
displays physical memory decides whether its displayed cells belong to the current CPU mapping. See
[Optional debugging ports]({{ '/cpu/debugging' | relative_url }}) for hook integration.

Debugger searches and string scans inspect paused live memory. Flow analysis uses the CPU's disassembler and its
plugin-provided memory wiring. These operations retain derived
addresses, strings or instruction metadata and reject results when session or memory revisions change.
User annotation identity derives from the CPU, normalized configuration URI and layout; it does not hash or copy memory cells.
Annotation import rejects the former memory-content identities and snapshot exports.

## Shared GUI actions

Memory plugins with Swing interfaces can use emuLib's `GUI.runInBackground` for file and other blocking work. It
disables the supplied action, runs the task outside the event-dispatch thread, invokes success or error callbacks on
completion, and re-enables the action only after those callbacks finish. Errors are unwrapped before delivery.

Each memory plugin keeps its own clear-and-refresh (erase memory) action and format-specific program-image loader.

[memory]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/memory/Memory.html
[memoryContext]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/memory/MemoryContext.html
[abstractMemory]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/memory/AbstractMemory.html
[abstractMemoryContext]: {{ site.baseurl}}/emulib_javadoc/net/emustudio/emulib/plugins/memory/AbstractMemoryContext.html
[memoryListener]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/memory/MemoryContext.MemoryListener.html
