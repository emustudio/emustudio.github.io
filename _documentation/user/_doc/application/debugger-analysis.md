---
layout: default
title: Debugger inspection
nav_order: 8
parent: emuStudio Application
permalink: /application/debugger-analysis
---

# Debugger inspection

Open the **Debugger** tab after compiling or loading your program. Run, pause and step with the existing debugger
toolbar. The instruction-aligned listing stays on the left. Drag the divider beneath it to resize the inspection pane,
which contains **Memory**, **Annotations**, **Breakpoints**, **References** and **History**. CPU status and registers,
expression watches, and peripheral-device selection occupy the right column, in that order. These tools share the
same workspace; no separate analysis window is needed.

Pause before inspecting or editing live state. Browsing addresses changes the inspection selection, not the PC.
The toolbar's **Breakpoints** button selects the embedded **Breakpoints** tab. **Pin address** keeps the inspection
at its selected address when execution pauses; otherwise it follows the PC. Back and Forward navigate recent selections.
Selecting a row in the instruction listing follows into inspection unless its address is pinned. Drag the dividers
to give more room to instructions, inspection or the right column.

## Memory and annotations

Choose the logical memory bank to inspect. Inspection does not change the CPU's bank selection. The common region
always uses physical bank zero. **Memory** shows bytes, labels, comments and captured strings; use the instruction
listing above it for disassembly. Instruction decoding and flow analysis use the CPU's active bank. **Show source**
opens the current compiled source mapping where available.

Memory controls distinguish live bytes, captured search results and the comparison baseline. Open **Compare / strings**
to reveal **Capture baseline**, **Compare baseline**, **Compare binary** and **Find strings**. Capture a baseline before
running an experiment, then pause and compare to locate changed bytes. Comparing a binary requires a full-size raw
image for the selected bank. Previous/Next result controls and the result count accompany the result set. Replacing
the comparison baseline preserves user annotations: their identity stays tied to the original annotation image.

Use the search type to find **Bytes**, an **Integer**, or **Text**. Byte patterns accept hexadecimal pairs and wildcards
(`3E ?? 32`, `A? ?F`). Integer searches use a byte width of 1, 2, 4 or 8 and the selected byte order. Text search uses UTF-8.
Rescan filters the previous result set by Changed, Equal, Increased or Decreased, comparing unsigned integers against
the previous scan. It retains the original search bank, width and byte order. String inspection finds printable ASCII
runs of at least four bytes and shows their captured text.

Select an existing annotation to edit it, or choose **Annotate inspected address** to start editing the current inspection
address. **Editing bank N:ADDR** identifies the edit target. **Save annotation** writes the label, comment, bookmark and
code/data classification to that target, even if stepping or browsing has since moved the inspected address. Search the
annotation list or show Bookmarks, then **Go to annotation**. User annotations are saved separately from compiler-generated source mappings.
They persist beside the computer configuration in a file bound to the capture's SHA-256, bank layout and physical addresses.
Save/Import also support explicit metadata files. Import rejects another image or an invalid layout without partial updates.

After compiling or loading a different program, choose **Use current program** in the inspection footer. This saves the
previous image's annotations, captures current memory, and loads annotations matching that image. Annotations and
metadata export then refer to the new capture. Use **Capture baseline** separately when starting a byte-comparison
experiment; refreshing that comparison baseline does not replace or clear annotations.

## Watches and breakpoints

8080/Z80 support portable registers and guest access hooks. Other CPUs keep their existing debugger; register editing,
portable watchpoints or recording may be unavailable. Watches can still inspect supported byte memory.

Expressions support register names, `reg(NAME)`, `mem[address]`, little-endian `mem16[address]`/`mem32[address]`, big-endian
`mem16be[address]`/`mem32be[address]`, arithmetic, shifts, bitwise operations, comparisons, and short-circuit `&&`/`||`.
Examples: `HL`, `mem16[SP]`, `A == 0x42`, `(mem[0x8000] & 1) != 0`. Choose **Hex + decimal**, **Binary** or **ASCII** to
format watch values; changed values have a marker. **Follow value as address** selects the evaluated address. Open
**Edit register** to reveal the register/value fields, then choose **Write register** to change a supported register
while paused. Invalid values remain in the form for correction, and register width is validated.

Add a named EXEC, READ, WRITE or SOURCE rule. Specify an address (a one-based source line for SOURCE), bank (`-1` for all),
optional condition, and qualifying hit count. SOURCE requires a file path and resolves current compiler source mappings;
lines without a current mapping are ineffective. Conditions are evaluated before EXEC/SOURCE instructions or after a guest
instruction for access watchpoints. Read watchpoints include instruction fetches; write events describe attempted guest writes.
Debugger inspection produces no guest access events. Resume skips an EXEC/SOURCE rule once at its stopped address.

Enable/disable named rules and reset their hit counts in the manager. **Add ordinary breakpoint** adds an unconditional
execution breakpoint to the CPU. These share the main debugger's address breakpoint checkboxes and remain available
on CPUs without advanced hooks. Named rules add separate conditions, watchpoints, and source locations; they do not set
the ordinary address checkboxes. Select a named rule or ordinary breakpoint and choose **Remove** to delete it.
**Save settings** persists named rules, expressions and ordinary execution breakpoints
beside the computer configuration in its `.debugger` companion file. Adding/removing watches or changing rules saves these
settings; closing the computer also saves ordinary breakpoints. Hit counts restart at zero when reloading.
Recording is disabled at startup, and its history is not persisted.

Watches use the inspection bank. Rule conditions use the CPU's selected logical bank, including when the
instruction itself is in common ROM.
The bank on an execution rule identifies the instruction's physical bank; shared-region instructions belong to bank zero.
An access rule uses the accessed address's physical bank. A rule counts a qualifying instruction once, even if that instruction
accesses the watched address more than once; it stops from the selected qualifying hit onwards.

## References, flow and history

Analyze from a selected address to show at most 256 reachable decoded instructions. Select an instruction in the reference
list or graph to navigate to its address; the list provides keyboard navigation.
Branch and call edges have different colors. Incoming-reference search scans sequential candidate instructions; code/data
classification can be incomplete. Indirect jump targets remain unresolved. These are static views, not execution coverage.

Enable **Record last 1024 instructions** while paused, then run or step. The history shows executed addresses, before/after
register values and guest memory accesses. Recording can reduce throughput. Historical state is read-only and leaves the live
machine unchanged. **Move PC Back** only changes the PC; it does not undo instructions or restore registers, memory or devices.

## Repeatable debugger operations

Use `auto --debug-script FILE` to run operations after optional compilation and CPU reset:

```text
# Addresses and counts accept decimal or 0x prefixes.
RUN 0x0100 10000
ASSERT PC == 0x0100
STEP 2
ASSERT mem[0x8000] == 0x42
CAPTURE result.bin
```

RUN requires an instruction limit; STEP allows at most one million instructions. CAPTURE writes the selected logical bank,
with paths relative to the script directory. A failed assertion, operation, unexpected CPU stop or step timeout returns a
nonzero automation exit status. This runner executes steps rather than starting an unbounded real-time run.

## Export memory and metadata

In **Annotations**, choose **Export memory and metadata**. This writes the selected annotation-image bank to
`memory-bank-N.bin` and user metadata to `memory-bank-N.properties`. The binary contains captured bytes; later live
memory changes and comparison-baseline captures do not change it. The properties file records the processor identifier,
bank, base address, memory size, common-memory boundary, image identity, labels, comments, bookmarks and code/data kinds.
Common addresses retain physical bank zero.

The export uses ordinary binary and UTF-8 Java properties files. Annotation **Import** accepts metadata for the same
image and layout, preserving the binding between user labels and the captured program. Compiler source maps, runtime
traces, live device state, patched binaries and bank-switch behavior are outside this format.
