---
layout: default
title: Download
description: "Download emuStudio — free, cross-platform vintage computer emulation platform. Available for Windows and Linux."
permalink: /download/
---

{% include analytics.html category="root" %}

<div class="jumbotron">
  <h1>Download</h1>
  <p>
    All versions of emuStudio are available at
     <a href="https://github.com/emustudio/emuStudio/releases" target="_blank">GitHub</a>.
    The distributed launchers support Linux and Windows.
  </p>
  {% include download.html %}
</div>

# Installation & run

Unpack <code>emuStudio-[version].tar</code> (or <code>emuStudio-[version].zip</code>) file into location where you want
to have emuStudio installed. The archive file contains the whole emuStudio with all official computer emulators and
examples.

Install Java 11 or later, then run the launcher from the unpacked directory:

- On Linux
  <code>./emuStudio</code>

- On Windows:
  <code>emuStudio.bat</code>

For more information, please see the [documentation]({{ site.baseurl }}/documentation/user/application/).

# Software for emulated computers

Software is essential for emulators as it is for computers. For emulators, software is usually preserved in disk images,
ROM images, magnetic tapes in a digitalized form, and there are probably even more options. It then depends solely on
the specific emulator, how it loads the software in.

The computer guides explain how to obtain and load software, or provide examples for the abstract machines.
Features documented for the current development version may be newer than the latest published release.

- [MITS Altair8800]({{ site.baseurl }}/documentation/user/altair8800/software)
- [ZX Spectrum 48K]({{ site.baseurl }}/documentation/user/zxspectrum48k/software)
- [Space Invaders]({{ site.baseurl }}/documentation/user/spaceinvaders/)
- [BrainDuck]({{ site.baseurl }}/documentation/user/brainduck/examples)
- [SSEM]({{ site.baseurl }}/documentation/user/ssem/software)
