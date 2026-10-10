---
layout: default
title: File loaders
nav_order: 4
parent: Plugin basics
permalink: /plugin_basics/file_loaders
---

{% include analytics.html category="developer" %}

# File loaders

emuLib's `net.emustudio.emulib.runtime.io.FileLoader` decodes BIN, Intel HEX (I8HEX), TAP and TZX
through one synchronous `FileLoader.Listener` contract. Available in the emuLib snapshot containing
[ticket #119](https://github.com/emustudio/emuLib/issues/119).
The loader emits immutable blocks. The caller decides how to use them.

## Reading blocks

```java
FileLoader loader = FileLoader.forPath(path)
        .orElseGet(() -> FileLoader.forFormat(FileLoader.Format.BIN));
loader.load(path, block -> {
    byte[] bytes = block.getBytes();
    // Inspect, export or consume the block's bytes and metadata.
}, FileLoader.Options.fileOrder());
```

BIN returns raw bytes without an address. HEX preserves embedded addresses and sparse gaps.
TAP/TZX preserve block IDs and original body bytes, including timing fields, flags and checksums.
`getData()` extracts standard/turbo Spectrum packets, including flag and checksum.
`getSpectrumHeader()` exposes header metadata; `hasValidChecksum()` reports packet validity.
These methods do not write to memory or require a destination.

Format recognition is case-insensitive. `.com`, `.out` and `.rom` identify BIN.
Unknown extensions return an empty Optional; the caller chooses whether to fall back to BIN.
The existing `IntelHEX` generation API remains available. `getCode()` returns a mutable map that
iterates in ascending address order. Generation writes records incrementally; malformed input reports
an `IOException` with a line number. Its I8HEX reader retains its current checksum policy.

## Loading into memory

For BIN and HEX, a plugin can consume the same API directly:

```java
loader.load(path, block -> {
    int address = block.getAddress().orElse(startAddress);
    memory.write(address, NumberUtils.nativeBytesToBytes(block.getData()));
}, FileLoader.Options.fileOrder());
```

For TAP/TZX, byte-mem pairs Spectrum CODE headers with subsequent data blocks using shared
packet/header decoding. The plugin validates checksums, declared lengths and complete turbo bytes;
it ignores BASIC/arrays and rejects unsupported TZX blocks. Each load has fresh pairing state.
Memory placement, banks and metadata sidecars are plugin responsibilities.
Direct loading does not execute BASIC or decode custom loaders and recordings into memory.

## Tape playback

```java
FileLoader loader = FileLoader.forPath(path)
        .filter(candidate -> candidate.getFormat().isTape())
        .orElseThrow(() -> new IOException("Unsupported tape file"));
TapeListener listener = playbackListener;
loader.load(path, listener, FileLoader.Options.playback());
```

`TapeListener` extends `FileLoader.Listener`. Its default `onBlock` method emits data, timing,
pause and metadata callbacks. Playback traversal follows TZX jumps, loops and call sequences.
The plugin owns CPU scheduling, device output and cassette state.
CSW/generalized recording bytes are preserved; consumers must implement playback support themselves.

`FileLoader.Options.fileOrder()` visits physical blocks once. Thread interruption always cancels loading;
`withCancellation(...)` adds a caller-provided cancellation signal. Failure/cancellation omits `onFileEnd()`.
Create separate stateful listeners for concurrent loads.
