---
layout: default
title: Introduction
nav_order: 1
has_children: true
permalink: /introduction/
---

{% include analytics.html category="developer_introduction" %}

# Introduction

This guide shall help you, the developer, to write your virtual computer for emuStudio. API is designed for simplicity and tries to save the developer from solving the most common problems. Created emulators can mimic either real or abstract computers. I hope you will have fun!

## Sister projects

There exist some sister projects, which will be used by the developer during your programming journey. This
section will provide more information.

### emuLib

emuLib is a run-time library used by emuStudio and plugins; it represents the core communication bridge between the
application and virtual computer. Thus, it is mandatory to use it while developing any plugin for
emuStudio. 

Javadoc can be opened [here][emulib]{:target="_blank"}.

### edigen

Edigen is CPU instruction decoder and disassembler generator using a binary specification file. It removes the burden of writing a boilerplate
disassembling code from the developer. It is however optional for using.

Project website with documentation is located [here][edigen]{:target="_blank"}.

### cpu-testsuite

General unit-testing framework intended for testing emuStudio CPU plug-ins. More specifically,
it allows to test correctness of the implementation of CPU instructions one by one. Tests are
specified in a declarative way; specific test cases are generated based on the declarative specification.

Project website with documentation is located [here][edigen]{:target="_blank"}.

## Publications

For reference, here are provided some published papers, mostly for some older emuStudio versions.

|---
| Version | Year | Document or paper
|-|-|-
|  | 2020 | [Development of ATmega 328P micro-controller emulator for educational purposes][atmega-2020]{:target="_blank"}
|---
|  | 2017 | [RASP Abstract Machine Emulator — Extending the emuStudio Platform][rasp-2017]{:target="_blank"}
|---
|  | 2012 | [An instruction decoder and disassembler generator for EmuStudio platform][edigen-2012]{:target="_blank"} - Proceeding of the Faculty of Electrical Engineering and Informatics of the Technical University of Košice. Page 660-663. ISBN 978-80-553-0890-6
|---
|  | 2010 | [Preserving host independent emulation speed][cse-2010]{:target="_blank"}
|---
|  | 2010 | [Standardization of computer emulation][standard-2010]{:target="_blank"}
|---
|  | 2010 | [Communication model of emuStudio emulation platform][model-2010]{:target="_blank"}
|---
|  | 2008 | [Software-based CPU emulation][emulation-2008]{:target="_blank"}
|===


[emulib]: {{ site.baseurl }}/emulib_javadoc/
[edigen]: https://github.com/emustudio/edigen
[edigen]: https://github.com/emustudio/cpu-testsuite
[atmega-2020]: https://www.researchgate.net/publication/349929732_Development_of_ATmega_328P_micro-controller_emulator_for_educational_purposes
[rasp-2017]: https://www.researchgate.net/publication/320277321_RASP_ABSTRACT_MACHINE_EMULATOR_-_EXTENDING_THE_EMUSTUDIO_PLATFORM
[edigen-2012]: http://people.tuke.sk/dusan.medved/APVV/clanky/Bena4.pdf
[standard-2010]: https://ieeexplore.ieee.org/document/5423733
[model-2010]: https://www.researchgate.net/publication/220482121_Communication_model_of_emuStudio_emulation_platform
[emulation-2008]: http://www.aei.tuke.sk/papers/2008/4/08_Simonak.pdf
[cse-2010]: {{ site.baseurl }}/../../../files/speed_final_en.pdf
