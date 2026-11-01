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

## Bank-aware inspection and guest accesses

Expose `getBanksCount()`, `getSelectedBank()`, `getCommonBoundary()`, and `readBank(address, bank)` for bank-aware debugger
inspection. Addresses below the common boundary are banked; addresses at or above it use physical bank zero. Inspection
must keep bank selection and guest timing unchanged. The default context has one bank and delegates bank-zero inspection to
`read`; memory-mapped providers must implement side-effect-free inspection themselves.

Memory-change listeners serve UI refresh. Guest read/write watchpoints use the CPU's execution probe, so they still work
when those notifications are disabled. Instruction fetches count as reads and write events describe attempts, including
writes rejected by ROM. Inspectors and disassemblers retain the original context and do not emit guest access events.

Compiler annotations and their `.meta` sidecars remain address-based. The host's user labels/comments/bookmarks use separate
image-identity and bank-aware metadata; they do not add bank semantics to `SourceCodeAnnotation`. See
[Optional debugging ports]({{ '/cpu/debugging' | relative_url }}) for bank identity and hook integration.

## Shared GUI actions

Memory plugins with Swing interfaces can use emuLib's `GUI.runInBackground` for file and other blocking work. It
disables the supplied action, runs the task outside the event-dispatch thread, invokes success or error callbacks on
completion, and re-enables the action only after those callbacks finish. Errors are unwrapped before delivery.

Each memory plugin keeps its own clear-and-refresh (erase memory) action and its format-specific load and dump
operations.

[memory]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/memory/Memory.html
[memoryContext]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/memory/MemoryContext.html
[abstractMemory]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/memory/AbstractMemory.html
[abstractMemoryContext]: {{ site.baseurl}}/emulib_javadoc/net/emustudio/emulib/plugins/memory/AbstractMemoryContext.html
[memoryListener]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/memory/MemoryContext.MemoryListener.html
