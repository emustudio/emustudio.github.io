---
layout: default
title: Screenshots
permalink: /screenshots/
---

# Screenshots

What you can do with emuStudio? Is it interesting for you? This section shows some answers.  

### Open a computer

<div class="container mb-4">
<div class="row">
    <div class="col-md-4">
        <a href="/files/images/open-computer.png" class="thumbnail">
            <img src="/files/images/open-computer.png" alt="Open a computer" style="width:300px">
        </a>
    </div>
    <div class="col">
        <p>
        Right after emuStudio is executed, the "Open computer" dialog shows up. In the dialog, users can select
        a predefined computer. The dialog also enables creating new computers, editing, renaming, or removing existing ones.
        The default installation already contains all available computers.
        </p>
    </div>
</div>
</div>


### Building a computer

<div class="container mb-4">
<div class="row">
    <div class="col-md-4">
        <a href="/files/images/edit-computer.png" class="thumbnail">
            <img src="/files/images/edit-computer.png" alt="Edit a computer" style="width:300px">
        </a>
    </div>
    <div class="col">
        <p>
        Sometimes either the default computer configuration is not suitable, or you might want to try to plug in your
        new computer component or build a completely new computer. This is enabled with a computer configuration editor,
        accessible from the "Open computer" dialog.
        </p>
    </div>
</div>
</div>

### Programming in emuStudio

<div class="container mb-4">
<div class="row">
    <div class="col-md-4">
        <a href="/files/images/source-code.png" class="thumbnail">
            <img src="/files/images/source-code.png" alt="Source code editor" style="width:300px">
        </a>
    </div>
    <div class="col">
        <p>
        When a computer is opened, emuStudio becomes an IDE for developing and running programs.
        The source code editor supports syntax highlighting and other tools that provide some writing comfort.
        A compiler, if provided by the computer, will translate the source code into a binary form which is
        automatically loaded in the operating memory of the computer.
        </p>
    </div>
</div>
</div>

### Debugger

<div class="container mb-4">
<div class="row">
    <div class="col-md-4">
        <a href="/files/images/emulator.png" class="thumbnail">
            <img src="/files/images/emulator.png" alt="Emulator panel" style="width:300px">
        </a>
    </div>
    <div class="col">
        <p>
        When the program is compiled, it can be emulated. Debugger, in the emulator panel, is to help with
        controlling the emulation life-cycle. It shows the internals of emulated components. CPU emulation can be
        run, paused, or stopped. Users can execute just a single step or run the emulation in timed-steps.
        All provided computers support breakpoints capability.
        </p>
    </div>
</div>
</div>

### Computer-user interaction

<div class="container mb-4">
<div class="row">
    <div class="col-md-4">
        <a href="/files/images/cpm22.png" class="thumbnail">
            <img src="/files/images/cpm22.png" alt="Terminal" style="width:300px;height:253px">
        </a>
    </div>
    <div class="col">
        <p>
            Users can interact with the emulated computer using virtual devices. For example, a terminal. Devices
            have custom capabilities, for trying to mimic the behavior of real-world devices. 
        </p>
        <p>
            For example, a disk device in MITS Altair8800 can be used for loading already prepared software images,
            without needing the source code.
        </p>
    </div>
</div>
</div>

### Emulation automation

<div class="container">
<div class="row">
    <div class="col-md-4">
        <a href="/files/images/automation.gif" class="thumbnail">
            <img src="/files/images/automation.gif" alt="Terminal" style="width:300px">
        </a>
    </div>
    <div class="col">
        <p>
            emuStudio can be run without GUI from command line. It can be useful when we want to see output of
            the emulated program instead of having to interact with emuStudio. Compiled source code will
            be automatically loaded into memory, then run by CPU. Input and output from/to devices is redirected
            to files.
        </p>
        <p>
            The emulation output is also a log file containing the progress of the emulation;
            it can be used for debugging.
        </p>
    </div>
</div>
</div>