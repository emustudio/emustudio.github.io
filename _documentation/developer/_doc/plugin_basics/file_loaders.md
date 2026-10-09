---
layout: default
title: File loaders
nav_order: 4
parent: Plugin basics
permalink: /plugin_basics/file_loaders
---

{% include analytics.html category="developer" %}

# File loaders

emuLib's `net.emustudio.emulib.runtime.io.FileLoader` loads BIN, Intel HEX (I8HEX), TAP and TZX
through one synchronous `FileLoader.Sink` contract. Available in the emuLib snapshot containing
[ticket #119](https://github.com/emustudio/emuLib/issues/119).

## Loading into memory

```java
FileLoader loader = FileLoader.forPath(path)
        .orElseGet(() -> FileLoader.forFormat(FileLoader.Format.BIN));
loader.load(path,
        FileLoader.memorySink((address, bytes) ->
                memory.write(address, NumberUtils.nativeBytesToBytes(bytes))),
        FileLoader.Options.memory(startAddress));
```

BIN uses the supplied start address. HEX retains embedded addresses and sparse gaps.
TAP/TZX extract only Spectrum CODE headers followed by matching data; BASIC and array data are ignored.
Memory extraction validates tape checksums and declared lengths and rejects unsupported TZX blocks.
It does not execute BASIC or decode custom tape loaders and recordings into memory.
Banks and metadata sidecars remain the memory plugin's responsibility.

Format recognition is case-insensitive. `.com`, `.out` and `.rom` identify BIN.
Unknown extensions return an empty Optional; the caller chooses whether to fall back to BIN.
The existing `IntelHEX` generation API remains available. Its I8HEX reader retains its current checksum policy.

## Tape playback

```java
FileLoader loader = FileLoader.forPath(path)
        .filter(candidate -> candidate.getFormat().isTape())
        .orElseThrow(() -> new IOException("Unsupported tape file"));
loader.load(path, FileLoader.tapeSink(listener), FileLoader.Options.playback());
```

`TapeListener` receives data, timing, pause and metadata callbacks. Playback traversal follows
TZX jumps, loops and call sequences. The plugin owns CPU scheduling, device output and cassette state.
CSW/generalized recording bytes are preserved; consumers must implement playback support themselves.

Custom sinks can inspect immutable `FileLoader.Block` values directly.
`FileLoader.Options.fileOrder()` visits physical blocks once. Thread interruption always cancels loading;
`withCancellation(...)` adds a caller-provided cancellation signal. Failure/cancellation omits `onFileEnd()`.
Create separate stateful sinks for concurrent loads.
