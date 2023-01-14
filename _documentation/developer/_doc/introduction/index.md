---
layout: default
title: Introduction
nav_order: 1
has_children: false
has_toc: false
permalink: /introduction/
---

{% include analytics.html category="developer_introduction" %}

# Introduction

This guide shall help you, the developer, to write your virtual computer for emuStudio. API is designed for simplicity
and tries to save the developer from solving the most common problems. Created emulators can mimic either real or
abstract computers. I hope you will have fun!

## Project references

emuStudio is a collection of repositories. Plugins and the application share a runtime library, CPU disassembler might
be generated using a sister project edigen, and instructions tested using cpu-testsuite framework. Here you can find
documentation references for these sister projects.

|---
|Project reference | Purpose
|-|-
| [emuLib][emulib]{:target="_blank"} | Shared runtime library. Mandatory use.
|---
| [Edigen][edigen]{:target="_blank"} | CPU instruction decoder and disassembler generator. Optional use for CPU plugins.
|---
| [CPU testing suite][cputestsuite]{:target="_blank"} | General unit-testing framework for testing CPU plug-ins. Optional use for CPU plugins.
|===

## Publications

There have been a few published papers about emuStudio, which could be helpful in getting additional context and some
philosophical aspects for developers. 

|---
| emuStudio version | Year | Reference
|-|-|-
| 0.40 | 2020 | [Development of ATmega 328P micro-controller emulator for educational purposes][atmega-2020]{:target="_blank"}
|---
| 0.39 | 2017 | [RASP Abstract Machine Emulator — Extending the emuStudio Platform][rasp-2017]{:target="_blank"}
|---
| 0.38 | 2012 | [An instruction decoder and disassembler generator for EmuStudio platform][edigen-2012]{:target="_blank"} - Proceeding of the Faculty of Electrical Engineering and Informatics of the Technical University of Košice. Page 660-663. ISBN 978-80-553-0890-6
|---
| 0.36-rc1 | 2010 | [Preserving host independent emulation speed][cse-2010]{:target="_blank"}
|---
| 0.36-rc1 | 2010 | [Standardization of computer emulation][standard-2010]{:target="_blank"}
|---
| 0.36-rc1 | 2010 | [Communication model of emuStudio emulation platform][model-2010]{:target="_blank"}
|---
| 3.6b1 | 2008 | [Software-based CPU emulation][emulation-2008]{:target="_blank"}
|===


[emulib]: {{ site.baseurl }}/emulib_javadoc/
[edigen]: https://github.com/emustudio/edigen
[cputestsuite]: https://github.com/emustudio/cpu-testsuite
[atmega-2020]: https://www.researchgate.net/publication/349929732_Development_of_ATmega_328P_micro-controller_emulator_for_educational_purposes
[rasp-2017]: https://www.researchgate.net/publication/320277321_RASP_ABSTRACT_MACHINE_EMULATOR_-_EXTENDING_THE_EMUSTUDIO_PLATFORM
[edigen-2012]: https://dusan.medved.website.tuke.sk/APVV/APVV-0385-07/clanky/Bena4.pdf
[standard-2010]: https://ieeexplore.ieee.org/document/5423733
[model-2010]: https://www.researchgate.net/publication/220482121_Communication_model_of_emuStudio_emulation_platform
[emulation-2008]: http://www.aei.tuke.sk/papers/2008/4/08_Simonak.pdf
[cse-2010]: {{ site.baseurl }}/assets/published/preserving-speed.pdf
