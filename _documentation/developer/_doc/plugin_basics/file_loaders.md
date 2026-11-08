---
layout: default
title: File loaders
nav_order: 4
parent: Plugin basics
permalink: /plugin_basics/file_loaders
---

{% include analytics.html category="developer" %}

# File loaders

emuLib's [FileLoader][fileloader]{:target="_blank"} (`net.emustudio.emulib.runtime.io.FileLoader`) decodes BIN, Intel HEX (I8HEX), TAP and TZX
through one synchronous `FileLoader.Listener` contract in emuLib 12.1.0-SNAPSHOT.
The loader emits immutable blocks. The caller decides how to use them.

## Reading blocks

```java
FileLoader.Format format = FileLoader.Format.fromPath(path).orElse(FileLoader.Format.BIN);
FileLoader.load(path, format, block -> {
    byte[] bytes = block.getData();
    // Inspect, export or consume the block's bytes and metadata.
});
```

BIN produces one block with the whole file and no address. HEX produces one addressed block per contiguous address
range. TAP blocks have ID `0x10`; TZX blocks keep their IDs. For tape blocks, `getData()` returns the standard/turbo
Spectrum packet, including flag and checksum. `getSpectrumHeader()` exposes header metadata; `hasValidChecksum()`
reports packet validity. These methods do not write to memory or require a destination.

`Format.fromPath` recognizes the extension case-insensitively; `.com`, `.out` and `.rom` identify BIN.
Unknown extensions return an empty Optional; the caller chooses whether to fall back to BIN.
`Listener.onFileStart()` and `onFileEnd()` have empty defaults; `onFileEnd()` is called only after successful loading.

The separate `IntelHEX` class generates and parses Intel HEX files. Its `getCode()` returns an unmodifiable map that
iterates in ascending address order. Parsing ignores checksums; malformed input reports an `IOException` with a line
number.

## Loading into memory

For BIN and HEX, a plugin can consume the same API directly:

```java
FileLoader.load(path, format, block -> {
    int address = block.getAddress().orElse(startAddress);
    memory.write(address, NumberUtils.nativeBytesToBytes(block.getData()));
});
```

For TAP/TZX, byte-mem pairs Spectrum CODE headers with subsequent data blocks using shared
packet/header decoding. The plugin validates checksums, declared lengths and complete turbo bytes;
it ignores BASIC/arrays and rejects unsupported TZX blocks. Each load has fresh pairing state.
Memory placement is a plugin responsibility.
Direct loading does not execute BASIC or decode custom loaders and recordings into memory.

## Tape playback

```java
FileLoader.Format format = FileLoader.Format.fromPath(path)
        .filter(FileLoader.Format::isTape)
        .orElseThrow(() -> new IOException("Unsupported tape file"));
FileLoader.load(path, format, tapeListener);
```

`TapeListener` extends `FileLoader.Listener`. Its default `onBlock` method decodes each block into signal callbacks:
`onStandardData(packet)`, `onPulses(pulseLengths)`, `onPureData(...)`, `onDirectRecording(...)`, `onPause(ms)` and
`onSetSignalLevel(level)`. Pulse lengths are in Z80 T-states. `onInfo(type, details)` reports headers, informational
blocks and unsupported blocks (CSW and generalized data); it does nothing by default.
The loader delivers blocks in playback order, following TZX jumps, loops and call sequences.
The plugin owns CPU scheduling, device output and cassette state.

Interrupting the loading thread cancels loading with an `InterruptedIOException`. Create separate stateful listeners
for concurrent loads.

[fileloader]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/runtime/io/FileLoader.html
