---
layout: default
title: Debugger inspection
nav_order: 8
parent: emuStudio Application
permalink: /application/debugger-analysis
---

# Debugger inspection

![8080 program paused at 0100, with instruction labels, CPU registers and memory watches]({{ site.baseurl }}/assets/application/debugger-demo-instructions.png)

Open **Debugger** after compiling or loading a program. Pause to inspect or edit state. Selecting an instruction changes
the inspected address; the PC stays put. Drag dividers to resize the workspace.
All bundled CPUs support instruction recording. Register sets and guest memory-access detail depend on the CPU: RAM
records typed instructions and its instruction pointer, while device/tape state is outside instruction history.

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

Pause the CPU, open **Memory**, enter `0x8000` in **Address** and choose **Bank**. Click **Inspect address** or press
Enter in the address field. Addresses accept decimal or hexadecimal notation. Browsing changes neither the program
counter nor the CPU's selected bank, and creates no breakpoint; common memory uses physical bank zero.

Choose **Set breakpoint...** to configure a breakpoint. **Set** adds an execution breakpoint at the CPU-visible address,
regardless of which bank supplies the instruction;
**Unset** removes it. Setting or unsetting a breakpoint does not change the inspection view. Hitting a breakpoint opens
**Memory** at its address; later steps follow the CPU normally unless the view was manually pinned. Instruction-table
breakpoint controls toggle enabled/disabled.

## Memory and annotations

### Find bytes, integers or text

![Byte search for 41 42 finds one match at 8000, labeled output]({{ site.baseurl }}/assets/application/debugger-demo-search.png){: style="max-width: 886px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Search type**. Search for byte patterns, integers, or text. |
| <span class="circle">2</span> | **Search value**. Enter the pattern, integer, or text to find. |
| <span class="circle">3</span> | **Find**. Capture memory and search the selected bank. |
| <span class="circle">4</span> | **Previous result**. Select the preceding match. |
| <span class="circle">5</span> | **Next result**. Select the following match. |
| <span class="circle">6</span> | **Rescan**. Filter existing candidates against a new memory capture. |
| <span class="circle">7</span> | **Live memory**. Return to the current live bytes. |
| <span class="circle">8</span> | **Compare / strings**. Show string scanning and baseline tools. |
| <span class="circle">9</span> | **Find strings**. Find ASCII strings in a memory capture. |
| <span class="circle">10</span> | **Capture baseline**. Save a baseline for later comparisons. |
| <span class="circle">11</span> | **Compare baseline**. Show bytes that differ from the baseline. |
| <span class="circle">12</span> | **Results**. Inspect matching addresses, captured values, strings, or baseline differences. |

After running the example, choose **Bytes**, enter `41 42`, then **Find**. Wildcards work too: `3E ?? 32` or `A? ?F`.
**Integer** supports widths of 1, 2, 4 or 8 bytes and either byte order; **Text** uses UTF-8.

**Rescan** filters previous matches by Changed, Equal, Increased or Decreased, retaining the original bank, width and byte
order. Results show captured bytes; **Live memory** returns to current bytes.

### Compare before and after execution

![Baseline comparison shows 41 at 8000, 42 at 8001, and return-address bytes at 8FFE and 8FFF]({{ site.baseurl }}/assets/application/debugger-demo-compare.png){: style="max-width: 886px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Search type**. Search for byte patterns, integers, or text. |
| <span class="circle">2</span> | **Search value**. Enter the pattern, integer, or text to find. |
| <span class="circle">3</span> | **Find**. Capture memory and search the selected bank. |
| <span class="circle">4</span> | **Previous result**. Select the preceding match. |
| <span class="circle">5</span> | **Next result**. Select the following match. |
| <span class="circle">6</span> | **Rescan**. Filter existing candidates against a new memory capture. |
| <span class="circle">7</span> | **Live memory**. Return to the current live bytes. |
| <span class="circle">8</span> | **Compare / strings**. Show string scanning and baseline tools. |
| <span class="circle">9</span> | **Find strings**. Find ASCII strings in a memory capture. |
| <span class="circle">10</span> | **Capture baseline**. Save a baseline for later comparisons. |
| <span class="circle">11</span> | **Compare baseline**. Show bytes that differ from the baseline. |
| <span class="circle">12</span> | **Results**. Inspect matching addresses, captured values, strings, or baseline differences. |

Open **Compare / strings** and **Capture baseline** before running. Pause, then **Compare baseline**.
Here, `STA` changed `8000–8001`; `CALL` left its return address at `8FFE–8FFF` after `RET` restored SP.
**Compare binary** accepts a full-size raw image of the inspected bank. Baseline capture preserves annotations.

### Find readable strings

![String scan finds HELLO DEBUGGER at 8100 and shows its message label]({{ site.baseurl }}/assets/application/debugger-demo-strings.png){: style="max-width: 886px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Search type**. Search for byte patterns, integers, or text. |
| <span class="circle">2</span> | **Search value**. Enter the pattern, integer, or text to find. |
| <span class="circle">3</span> | **Find**. Capture memory and search the selected bank. |
| <span class="circle">4</span> | **Previous result**. Select the preceding match. |
| <span class="circle">5</span> | **Next result**. Select the following match. |
| <span class="circle">6</span> | **Rescan**. Filter existing candidates against a new memory capture. |
| <span class="circle">7</span> | **Live memory**. Return to the current live bytes. |
| <span class="circle">8</span> | **Compare / strings**. Show string scanning and baseline tools. |
| <span class="circle">9</span> | **Find strings**. Find ASCII strings in a memory capture. |
| <span class="circle">10</span> | **Capture baseline**. Save a baseline for later comparisons. |
| <span class="circle">11</span> | **Compare baseline**. Show bytes that differ from the baseline. |
| <span class="circle">12</span> | **Results**. Inspect matching addresses, captured values, strings, or baseline differences. |

Choose **Find strings** under **Compare / strings**. It finds printable ASCII runs of at least four bytes,
including `HELLO DEBUGGER` at `8100`. Displayed text comes from the scan's capture.

### Label and bookmark addresses

![Annotation editor labels bank 0 address 8000 as output, marks it DATA and bookmarks it]({{ site.baseurl }}/assets/application/debugger-demo-annotations.png){: style="max-width: 886px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Filter**. Find annotations by their text. |
| <span class="circle">2</span> | **Bookmarks only**. Show bookmarked annotations. |
| <span class="circle">3</span> | **Go to annotation**. Navigate to the selected entry. |
| <span class="circle">4</span> | **Delete**. Remove the selected annotation. |
| <span class="circle">5</span> | **Annotate inspected address**. Start an annotation at the current inspected address. |
| <span class="circle">6</span> | **Label**. Enter the address label. |
| <span class="circle">7</span> | **Comment**. Enter the address comment. |
| <span class="circle">8</span> | **Kind**. Mark the address as code, data, or unspecified. |
| <span class="circle">9</span> | **Bookmark**. Mark this annotation for quick retrieval. |
| <span class="circle">10</span> | **Save annotation**. Save edits at the displayed editing address. |
| <span class="circle">11</span> | **Export annotations**. Save the annotation metadata. |
| <span class="circle">12</span> | **Import**. Read annotations from a saved file. |
| <span class="circle">13</span> | **Clear annotations**. Remove all annotations from this image. |
| <span class="circle">14</span> | **Export memory and metadata**. Save the captured bytes and their annotation sidecar. |

Inspect `0x8000`, open **Annotations**, then **Annotate inspected address**. Enter `output`, choose **DATA**, enable
**Bookmark**, then **Save annotation**. Check **Editing bank N:ADDR**; browsing leaves this edit target unchanged.
Use **Filter**, **Bookmarks only** and **Go to annotation** to revisit entries.

Annotations persist beside the computer configuration, bound to a captured image and bank layout. After loading another
program, **Take snapshot** saves the old annotations and loads those matching the new capture. **Save**/**Import** transfer
metadata for the same image. Compiler source mappings remain separate.

## Watches and breakpoints

### Watch registers and memory

![Watches show A as 0x42, SP as 0x9000, bytes 0x41 and 0x42, and their little-endian word 0x4241]({{ site.baseurl }}/assets/application/debugger-demo-watches.png){: style="max-width: 355px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Expression**. Enter a register or memory expression. |
| <span class="circle">2</span> | **Add watch**. Add the expression to the watch list. |
| <span class="circle">3</span> | **Format**. Choose how watch values are displayed. |
| <span class="circle">4</span> | **Watch list**. Inspect values in the selected bank; changed values remain marked until the next stop. |

Enter an **Expression** and choose **Add**. Watches use the inspection bank. Choose **Hex + decimal**, **Binary** or **ASCII**;
changed values receive a marker. **Follow value** opens the evaluated address. **Edit register** reveals **Write register**.

| Expression | Meaning |
|---|---|
| `A` or `reg(A)` | Accumulator. |
| `mem[0x8000]` | Byte: `0x41` after execution. |
| `mem16[0x8000]` | Little-endian word: `0x4241`. |
| `mem16be[0x8000]` | Big-endian word: `0x4142`; `mem32`/`mem32be` read four bytes. |
| `(mem[0x8000] & 1) != 0` | Test bit 0. Arithmetic, shifts, comparisons and short-circuit `&&`/`||` are supported. |

### Stop on a conditional memory write

Before rerunning, open the memory-watch controls in **Watches**, enter a **Memory watch name** and set **Memory watch address**
to `0x8001`. Select **Pause on writes**. Under **Memory watch options**, enter condition `A == 0x42` and leave
**Memory watch stop from hit** at `1`, then click **Add memory watch**. It stops after the writing instruction.
**Memory watch bank** selects a physical access bank; `-1` matches accesses in all banks. Conditions use the CPU's selected logical bank.
Each qualifying instruction counts once, even with repeated accesses.

Execution breakpoints in **Breakpoints** stop before the CPU-visible instruction address. They have no bank selection:
the same address matches in every physical bank. Conditions and hit counts remain available through advanced options.
**SOURCE** requires a file path and a one-based line with a current compiler mapping; resolved targets are CPU addresses,
also independent of physical instruction bank.
**READ** includes instruction fetches; **WRITE** includes attempted guest writes. Debugger reads trigger no access rules.
Named rules stay separate from instruction-table breakpoints; instruction-table controls create unconditional execution breakpoints.
Resuming skips the stopped EXEC/SOURCE rule once.

SOURCE rules resolve mapped addresses before execution, including multiple generated addresses for one source line.
Running or editing memory makes source mappings historical; already resolved targets can still stop the current run.
Recompile to restore current source following or rebind a source rule. Source navigation uses explicit mapped cells;
unmapped operand cells and gaps have no source match. Unsupported compiler coordinates appear in the source-mapping status.

Use **Enable / disable**, **Remove** or **Reset hit counts** to manage rules. Watches and breakpoints persist in the computer's
`.debugger` file; **Save settings** saves them explicitly. Hit counts restart at zero when reloading.

## References, flow and history

### Follow a call

![Static reference list shows the call from 0108 to 010C beside the decoded instruction graph]({{ site.baseurl }}/assets/application/debugger-demo-references.png){: style="max-width: 886px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Analyze from address**. Decode reachable instructions from the inspected address. |
| <span class="circle">2</span> | **Find incoming references**. Search for references to the inspected address. |
| <span class="circle">3</span> | **Go to reference**. Inspect the selected reference’s address. |
| <span class="circle">4</span> | **Instruction**. Select a decoded instruction. |
| <span class="circle">5</span> | **Go to instruction**. Inspect the selected decoded instruction. |
| <span class="circle">6</span> | **References and graph**. Select a reference or graph node to inspect its address. Indirect targets may remain unresolved. |

Select `0100`, open **References**, then **Analyze from address**. The call links `0108` to `010C`.
Choose a graph node or **Go to reference**/**Go to instruction** to navigate. **Find incoming references** shows incoming
calls and branches. Analysis captures the inspection bank without switching the CPU's bank and attempts at most 256
reachable addresses. A partial-result notice means a work bound was reached; unresolved indirect targets remain unknown.
Running, editing memory, or changing source/code/data metadata invalidates analysis. Pause and analyze again to refresh it.
CPUs without immutable decoder capture report analysis as unsupported. Static references do not prove execution coverage.

### Instruction recording

Open **History** while paused. Set **Recent limit** and enable **Record recent instructions**, then run or step.
The default limit is 1,024 instructions; choose up to 1,000,000. Recent history retains only the newest events within
that limit. Choose **Record to file** for a continuous recording that can outlast the recent buffer, then
**Stop file recording** to flush and finish the file. Use `.emutrace` for structured recording files.

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

The table shows sequence numbers, physical banks, instruction addresses, captured instruction encoding and disassembly,
changed registers and memory writes. Select an event to inspect all recorded before/after register values,
raw flags, memory accesses and completion status. For the example above, the instruction at `010D` records
`WRITE bank 0:8001 = 42`. Instruction text is captured before execution, so later memory edits or bank changes
cannot change a recorded instruction. Opened recordings use their own captured values rather than the current
computer's memory or labels.

Use **PC from** / **PC through** to select an instruction-address range, **Changed register** to find changes to a
named register, or **Memory address** with **Any access**, **Read** or **Write** to find memory accesses. Address
fields accept decimal or `0x`-prefixed hexadecimal values. Filters apply to the current recording page or retained
recent buffer; sequence numbers make gaps visible. **Previous recorded write** searches before the selected row for
a write to **Memory address** within that same page or buffer. It cannot recover events outside that range.

**Fold identical repeats** shortens repeated display rows. It preserves the underlying events; turn it off to inspect
individual executions. Saving a recording keeps all events, including repeated execution.

Recording starts disabled and can reduce throughput. File output uses bounded buffering, so slow storage can slow
execution rather than silently dropping instructions. Cleanly stopped recordings include a completion marker;
interrupted or truncated files are reported as incomplete. A recording's completeness is verified when its end is read.
Historical inspection leaves the live machine unchanged. **Move PC Back** changes only the PC; recording does not
restore registers, memory, devices or external inputs.

## Repeatable debugger operations

Run the same check with `auto --debug-script FILE` after compiling the example:

```text
RUN 0x010B 20
ASSERT A == 0x42
ASSERT mem16[0x8000] == 0x4241
CAPTURE result.bin
```

`RUN` stops before `HLT` at `010B`, within 20 instructions. `CAPTURE` writes the selected logical bank beside the script.
Failed assertions return a nonzero exit status. See [Debug scripts]({{ site.baseurl }}/application/automation#debug-scripts)
for the command line and operation limits.

## Export memory and metadata

In **Annotations**, choose **Export memory and metadata** to write `memory-bank-N.bin` and `memory-bank-N.properties`.
The binary contains the annotation image's captured bytes, even after live memory changes. The UTF-8 properties file
records image identity, processor, bank layout, labels, comments, bookmarks and code/data kinds. **Import** requires
matching image/layout metadata. Source maps, execution history and device state are not included.
