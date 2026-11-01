---
layout: default
title: Introduction
description: "Introduction to emuStudio — a free, cross-platform toy-computer emulation platform and framework for students and retro computing enthusiasts."
nav_order: 1
has_children: false
has_toc: false
permalink: /introduction/
---

{% include analytics.html category="Introduction" %}

# Introduction

New to emuStudio? [Run your first program]({{ site.baseurl }}/first-experiment/) for a guided path from installation
to running and inspecting a bundled example.

emuStudio is a toy-computer emulation platform and framework for teaching, programming, and experimentation.
It supports the full workflow: write a program, compile it, load it into an emulated computer, then run and debug it.
Its plugin API lets developers implement real or abstract computers.

Emulators such as [MAME][mame]{:target="_blank"} and [simh][simh]{:target="_blank"} preserve computing history.
emuStudio also aims to reproduce technical details and historical behavior, with a focus on programming and
experimenting with emulated devices. It provides a source editor, debugger, and virtual computer designer.

The user guide explains how to use and program each computer. The
[developer guide](/documentation/developer/) explains plugin APIs and implementation contracts.

## References

The following lists a few references on emuStudio online.

|---
| Year | Reference
|-|-
| 2022 | [emuStudio on Reddit][reddit]{:target="_blank"}
|---
| 2022 | [Twirling bar animation][twirl]{:target="_blank"}
|---
| 2022 | [emuStudio on 8bitnews][8bitnews]{:target="_blank"}
|---
| 2022 | [emuStudio on Gametech wiki][gametechwiki]{:target="_blank"}
|===

[gametechwiki]: https://emulation.gametechwiki.com/index.php/Altair_8800
[8bitnews]: https://8bitnews.io/archive/2022-02-25/basic-in-js
[twirl]: https://www.youtube.com/watch?v=uxn-sF07_xY
[reddit]: https://www.reddit.com/r/asm/comments/t7e5ug/emustudio_8080z80_emulator_ide_and_framework/

[mame]: https://www.mamedev.org/
[simh]: https://github.com/simh/simh
[peterj]: https://github.com/vbmacher
[slavos]: https://kpi.fei.tuke.sk/sk/person/slavomir-simonak
[tuke]: https://www.tuke.sk
[tukesk]: https://goo.gl/maps/9hoGFpr5q17GxF9M6
