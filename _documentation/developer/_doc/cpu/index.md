---
layout: default
title: Writing a CPU
nav_order: 5
has_children: true
permalink: /cpu/
---

{% include analytics.html category="developer_cpu" %}

# Writing a CPU

CPU plugins implement emulation and expose the controls and state needed by emuStudio's debugger.

A CPU plugin must implement:

Emulation "engine"
: It is the CPU emulator itself, and it should be implemented using some emulation technique. In Java there are not many
options, so usually either interpretation or threaded dispatch are used, both described e.g.
[here][interpretation]{:target="_blank"} or [here][bario]{:target="_blank"}.

Disassembler
: It will be used by emuStudio for creating the list of instructions in the debugger panel.

Java Swing GUI panel
: It should implement the visualization of CPU registers, possibly current frequency and CPU run state.

Create one disassembler during plugin [instantiation][instantiation] or [initialization][initialization]. Create and
cache the status panel in [CPU.getStatusPanel()][getStatusPanel]{:target="_blank"}; the application calls it from
Swing's [event-dispatch thread][swingthread]{:target="_blank"} when constructing the debugger.

You can generate the disassembler from a specification with [Edigen][edigen]{:target="_blank"}, short for
_Emulator DIsassembler GENerator_. The [Edigen Gradle plugin][edigen-gradle]{:target="_blank"} integrates generation
with Java compilation; see [Gradle integration]({{ site.baseurl }}/cpu/disassembler#gradle-integration).

## Testing instructions

The optional [CPU testing suite][cpu-testsuite]{:target="_blank"} executes instruction tests with generated operands.
Use the artifact matching your emuLib major version. The current emuStudio checkout uses:

{:.code-example}
```groovy
dependencies {
    testImplementation 'net.emustudio:cpu-testsuite_12:1.2.1-SNAPSHOT'
}
```

The suite needs JUnit 4 and a linearly addressed `Byte` or `Short` memory context. Supply a `CpuRunner` adapter for
registers, flags, PC and SP, a `CpuVerifier` adapter for assertions, and a concrete generic `TestBuilder`. Names such
as `ByteTestBuilder` are CPU-specific consumer helpers, not library classes. The [consumer setup][cpu-testsuite]{:target="_blank"}
shows how to build those adapters and generate test cases.

For each operand pair, the runner resets the CPU, restores retained flags, applies injectors, captures pre-execution
state, steps one instruction, and runs verifiers. Word injection and verification use the memory stub's word-reading
strategy; configure it to match the CPU. Program memory grows to cover `CPU.getAddressSpaceSize()`, so implement that
contract accurately rather than assuming every CPU has a 64 KiB address space.


[bario]: http://www.xsim.com/papers/Bario.2001.emubook.pdf
[interpretation]: http://cse.unl.edu/~witty/class/embedded/material/note/emulation.pdf
[instantiation]: {{ site.baseurl }}/plugin_basics/loading.html#plugin-instantiation
[initialization]: {{ site.baseurl }}/plugin_basics/loading.html#plugin-initialization
[getStatusPanel]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/CPU.html#getStatusPanel()
[swingthread]: https://docs.oracle.com/javase/tutorial/uiswing/concurrency/dispatch.html
[edigen]: https://github.com/emustudio/edigen
[edigen-gradle]: https://github.com/emustudio/edigen-gradle-plugin
[cpu-testsuite]: https://github.com/emustudio/cpu-testsuite#consumer-setup
