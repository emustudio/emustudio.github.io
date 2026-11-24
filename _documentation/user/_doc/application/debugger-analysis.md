---
layout: default
title: Debugger inspection
nav_order: 8
parent: emuStudio Application
permalink: /application/debugger-analysis
---

# Debugger inspection

![8080 program paused at 0100, with instruction labels, CPU registers and memory watches]({{ site.baseurl }}/assets/application/debugger-demo-instructions.png)

Compile or load a program, open **Debugger**, and pause to inspect or edit state. Drag the dividers to resize panes.
Selecting an instruction changes the inspected address and leaves the program counter (PC) in place.

## Instruction listing

The debugger tracks executed instructions and transitions during **Run**, timed steps, and single steps, even with
recording off. The listing uses this history for flow arrows and folding. Resetting the CPU clears the history.

### Fold repeated instructions

Turn on **Fold identical repeats** below the listing. It groups adjacent instructions with identical text, bytes, and
length only after the debugger sees the CPU execute them in order. For each pair, the first instruction must lead
only to the second, and the second must be reached only from the first. Unexecuted instructions stay on separate rows,
even when every row shows `nop` and `00`.

For example, after the CPU executes three consecutive `nop` instructions at `0100`–`0102`, the listing can show
`0100–0102  nop × 3`. The current PC, inspected address, enabled breakpoints, labels, current symbols, and user
annotation edges split runs. Click the marker beside the address range to expand it.

During **Run**, BrainDuck reports each instruction and transition even when it groups instructions or optimizes
copy, clear, and scan loops. Breakpoints, detailed recording, and stepping retain individual instruction boundaries.

<details markdown="1">
<summary>8080 example used in these screenshots</summary>

Compile this program with **MITS Altair8800**. It writes `41 42` at `8000` and calls a subroutine.
Screenshot addresses and bytes are hexadecimal.

```text
org 100h
lxi sp,9000h
mvi a,41h
sta 8000h
call increment
hlt
increment: inr a
sta 8001h
ret
org 8000h
db 0,0
org 8100h
db 'HELLO DEBUGGER',0
```

</details>

## Inspect an address

While paused, open **Memory**, enter `0x8000` in **Address**, and press Enter or click **Inspect address**.
Use decimal or `0x`-prefixed hexadecimal addresses.

In **Set breakpoint...**, choose **Set** to add a breakpoint at the CPU-visible address or **Unset** to remove it.
When a breakpoint stops the CPU, the debugger shows `Breakpoint: XXXX` and opens **Memory** at that address.
Later steps follow the PC unless you pinned the view. Toggle breakpoints in the listing to enable or disable them.

## Memory and annotations

### Find bytes, integers or text

While paused, choose **Bytes**, enter `41 42`, and click **Find**. Use `?` as a wildcard, as in `3E ?? 32` or `A? ?F`.
**Integer** supports 1, 2, 4, or 8 bytes in either byte order. **Text** uses UTF-8.
Use **Previous** and **Next** to navigate matches. **Show all addresses** restores the full list.

Results show live bytes at matching addresses. Execution, memory edits, and metadata changes clear stale results.

### Find readable strings

**Find strings** finds printable ASCII runs of at least four bytes, such as `HELLO DEBUGGER` at `8100`.
Toggle **String column** to show or hide those strings. Search again after changing memory.

### Label and comment on addresses

Inspect `0x8000` and choose **Annotations → Annotate inspected address**. Enter `output`, choose **Data**, and click
**Save annotation**. Annotations mark CPU-visible addresses or ranges as **Code** (default) or **Data**.
Use **Search annotations** to jump to an entry. Use **Manage…** to import, export, or clear annotations for this computer.

emuStudio saves user annotations, watches, breakpoints, and memory watches together. For `/path/computer.toml`, it
writes `/path/computer.toml.debugger` atomically and reloads it when you open the computer, regardless of the program.
Computers without a saved configuration keep settings in memory. Compiler annotations use captured source revisions.

emuStudio warns when it skips invalid entries or deletes an unreadable settings file. On migration,
execution rules become breakpoints, and read/write rules become memory watches. emuStudio drops legacy hit counts
and warns when it removes unsupported breakpoint conditions.

Annotation files use `annotation.N.address`, `annotation.N.end`, `annotation.N.label`, and `annotation.N.kind`.
Import skips duplicates with the same range, kind, and label, and warns about invalid entries. Colors come from the
range and stay consistent across sessions.

## Watches and breakpoints

### Watch registers and memory

![Watches show A as 0x42, SP as 0x9000, bytes 0x41 and 0x42, and their little-endian word 0x4241]({{ site.baseurl }}/assets/application/debugger-demo-watches.png){: style="max-width: 355px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Expression**. Enter a register or memory expression. |
| <span class="circle">2</span> | **Add watch**. Add the expression to the watch list. |
| <span class="circle">3</span> | **Format**. Choose how watch values are displayed. |
| <span class="circle">4</span> | **Watch list**. Read values through CPU memory mappings. Change markers last until the next stop. |

Watches use CPU-visible addresses. Choose **Hex + decimal**, **Binary**, or **ASCII**. **Follow value** opens the
evaluated address. **Edit register** reveals **Write register**.

Watches refresh when execution stops or when you edit one while paused.

| Expression | Meaning |
|---|---|
| `A` or `reg(A)` | Accumulator. |
| `mem[0x8000]` | Byte: `0x41` after execution. |
| `mem16[0x8000]` | Little-endian word: `0x4241`. |
| `mem16be[0x8000]` | Big-endian word: `0x4142`; `mem32`/`mem32be` read four bytes. |
| `(mem[0x8000] & 1) != 0` | Test bit 0. Arithmetic, shifts, comparisons and short-circuit `&&`/`||` are supported. |

### Monitor memory access

In **Watches → Memory access**, enter `0x8001` in **Memory watch address** and choose **Add**. Each row shows the
current value plus the PC and value of the last read and write. Memory watches let execution continue.
A new watch shows **Pending** until its first evaluation, or **Unavailable** if the CPU lacks debugger support.
Select a row and choose **Remove** to delete it.

### Breakpoints

An enabled breakpoint stops the CPU before it executes the instruction at that address. Resume to pass that breakpoint once.

Running or editing memory makes source mappings historical. Recompile to restore source following. Source navigation uses
explicitly mapped cells. Check the source-mapping status for unsupported compiler coordinates.

In **Breakpoints**, use **Enable / disable** or **Remove**. Use **Save settings** to write the computer's `.debugger` file.

## Execution history

### Instruction recording

Open **History** while paused. Enable **Record recent instructions**, then run or step. **Recent limit** defaults to
1,024 and accepts up to 1,000,000 events. **Record to file** can outlast the recent buffer. Use `.emutrace` files and
choose **Stop file recording** to flush and finish them.

All bundled CPUs support recording. Register and memory-access details vary by CPU. RAM records typed instructions
and its instruction pointer. Device and tape state lie outside instruction history. Pausing or stopping recent recording,
or filling a **Keep first** buffer, ends detailed capture unless file recording is active.

| Control | Behavior |
|---|---|
| **Record recent instructions** / **Recent limit** | Enable bounded recent capture and set how many instructions to retain. |
| **Record to file** / **Stop file recording** | Start or finish continuous recording independently of recent history. |
| **Save recent recording** | Save the retained recent events as a structured recording. |
| **Export displayed history as text** | Export the displayed recent history or recording page in readable form. |
| **Export entire recording as text** | Stream the opened recording to readable text, including its completeness status, with bounded memory. |
| **Open recording** | Inspect a saved recording without changing the live machine. |
| **First page** / **Next page** | Read a recording in pages of up to 1,024 events. |
| **Live history** | Return to the current computer's recent history. |
| **Show unchanged registers** | Include unchanged values in the selected instruction's detail view. |

Each row shows the sequence number, CPU-visible address, captured bytes and disassembly, changed registers, and writes.
Select a row for before and after register values, raw flags, memory accesses, and completion status. For example,
`010D` records `WRITE 8001 = 42`. Saved recordings use their captured instruction text and values.

Filter by **PC from** / **PC through**, **Changed register**, or **Memory address** with **Any access**, **Read**, or
**Write**. Use decimal or `0x`-prefixed hexadecimal addresses. Filters cover the current page or recent buffer.
Sequence gaps show omitted events. **Previous recorded write** searches backward from the selected row in that same
page or buffer for a write to **Memory address**.

In **History**, **Fold identical repeats** groups matching recorded events. Turn it off to inspect each execution.
Saving a recording keeps every event.

Recording starts disabled and can slow execution, including when file output waits on storage. emuStudio checks the
completion marker when it reads the end of a file and flags interrupted or truncated recordings as incomplete.
Browsing history leaves the live machine as it was. **Move PC Back** sets the PC to the selected instruction address.
