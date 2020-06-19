---
layout: default
title: RASP
nav_order: 5
has_children: true
permalink: /rasp/
---

# Random-Access Stored Program (RASP)

Random Access Stored Program machine (RASP) is an abstract von-Neumann computer. It means it does not represent a physical device, but rather it is intended to work as a model to study von-Neumann architecture, without the need to care about specific manufacturer's hardware details. 

Firstly, it is useful to present Random Access Stored Program (RASP) machine's architecture -- it is schematically depicted in the following figure.

![RASP architecture]({{ site.baseurl }}/assets/rasp/RASP.png)

As we can see, the control unit, i.e. processor, reads data from the input tape and writes results of executed operations onto the output tape. The tapes serve as a form of I/O devices. The two heads -- reading (R) and writing (W), are pointers to the current reading/writing position. 

As already stated, the RASP machine represents a von Neumann computer. This implies that the operating memory exists as a single unit in which both program and data can reside. The segment containing the program is organized in the way that two adjacent cells contain instruction/operand alternately. 
The memory can be read as well as written to by the control unit.  

## RASP for emuStudio

Each virtual computer in emuStudio is defined by the so-called "abstract schema". It defines all the parts of its architecture (what it consists of) and inner communication (how architecture components are interconnected). The following figure presents the RASP abstract schema:

![RASP abstract schema]({{ site.baseurl }}/assets/rasp/abstract_scheme.png)
