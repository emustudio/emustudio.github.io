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

Pause, choose the inspection bank, select **Bytes**, enter `41 42`, then **Find**. Wildcards work too:
`3E ?? 32` or `A? ?F`. **Integer** supports widths of 1, 2, 4 or 8 bytes and either byte order; **Text** uses UTF-8.
Use **Previous** and **Next** to navigate matches, or **Show all addresses** to return to the full address list.

Search reads live memory while paused. Results retain matching addresses; displayed bytes come from current memory.
Execution, memory edits and metadata changes clear outdated results. Background searches check the session and memory
revisions before publishing their results.

### Find readable strings

Choose **Find strings** to find printable ASCII runs of at least four bytes, including `HELLO DEBUGGER` at `8100`
in the example. **String column** shows or hides the text found by that scan. Run the search again after changing memory.

### Label and bookmark addresses

Inspect `0x8000`, open **Annotations**, then **Annotate inspected address**. Enter `output`, choose **DATA**, enable
**Bookmark**, then **Save annotation**. Check **Editing bank N:ADDR**; browsing leaves this edit target unchanged.
Use **Filter**, **Bookmarks only** and **Go to annotation** to revisit entries. **Export annotations** and **Import**
transfer annotation metadata; **Clear annotations** removes user annotations for this configured machine and layout.

Annotations persist beside the computer configuration. Their identity combines the CPU, normalized configuration path
and memory layout, so labels survive reopening that configuration and loading another program with the same layout.
Keep labels appropriate to the program you load. Import requires the same configured-machine/layout identity.
Files from the former memory-snapshot export and annotations bound to a memory-content hash are unsupported.
Existing files remain untouched. Compiler source mappings stay separate and require their captured source revisions.

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
calls and branches. Analysis reads the chosen inspection bank without switching the CPU's bank and attempts at most 256
reachable addresses. A partial-result notice means a work bound was reached; unresolved indirect targets remain unknown.
Analysis runs on a worker against paused live memory and checks session, memory and metadata revisions before publication.
Running, editing memory, or changing source/code/data metadata invalidates analysis. Pause and analyze again to refresh it.
Other inspection banks require bank-aware decoding. Plugins without that view can analyze the CPU's currently selected
bank while the mapping stays unchanged. Static references do not prove execution coverage.

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
```

`RUN` stops before `HLT` at `010B`, within 20 instructions.
Failed assertions return a nonzero exit status. See [Debug scripts]({{ site.baseurl }}/application/automation#debug-scripts)
for the command line and operation limits.
