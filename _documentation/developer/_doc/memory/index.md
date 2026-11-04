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

`AbstractMemoryContext` supplies listener management; concrete contexts supply memory storage. Annotations are
independent of memory contexts: the application owns a live annotation engine for the loaded computer and exposes it
through `ApplicationApi.getAnnotations()`. Its entries use CPU-visible addresses and half-open cell ranges. Plugins
sharing the application API see the same annotations; physical banks do not own separate annotations.

An annotation has an owner ID and an entry ID. After a successful compilation and load, a compiler can atomically
replace its own source mappings, preserving annotations from other owners:

```java
AnnotationEngine annotations = applicationApi.getAnnotations();
AnnotationEngine.Entry mapping = new AnnotationEngine.Entry(
        pluginID, entryId, address, address + 1, "source", "",
        SourceCodePosition.of(line, column, sourcePath.toString()));
annotations.replaceOwner(pluginID, List.of(mapping));
```

Publish all mappings for the compiler in the same replacement, not one replacement per address. Failed compilation
must leave existing compiler mappings intact. The debugger uses source positions to open source files; user-created
annotations are managed and persisted by the application independently of compiler mappings.

Declare compiler column units as described in [source-position coordinates]({{ site.baseurl }}/compiler/#source-position-coordinates).
The application's `ProgramIndex` uses the live engine alongside execution-breakpoint presence and indexed instruction
flow for one image/layout. Plugins use emuLib contracts; they do not import application index classes.

## Guest accesses

Memory-change listeners serve UI refresh. Guest read/write watchpoints use the CPU's execution probe, so they still work
when those notifications are disabled. Instruction fetches count as reads and write events describe attempts, including
writes rejected by ROM. Inspectors and disassemblers retain the original context and do not emit guest access events.

`ApplicationApi.getAnnotations()` provides live labels and source mappings. `ApplicationApi.getExecutionState()`
provides the current instruction address and change listeners; `currentInstruction()` returns -1 when unavailable. Callbacks
may occur outside the Swing event thread. A plugin displaying physical memory decides whether its displayed cells belong
to the current CPU mapping. See
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
