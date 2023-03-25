---
layout: default
title: Download
permalink: /download/
---

{% include analytics.html category="root" %}

<div class="jumbotron">
  <h1>Download</h1>
  <p>
    All versions of emuStudio are available at
     <a href="https://github.com/emustudio/emuStudio/releases" target="_blank">GitHub</a>.
    Supported platform for all versions is only PC.     
  </p>
  {% include download.html %}
</div>

# Installation & run

Unpack <code>emuStudio-[version].tar</code> (or <code>emuStudio-[version].zip</code>) file into location where you want
to have emuStudio installed. The archive file contains the whole emuStudio with all official computer emulators and
examples.

To run emuStudio, run the following command from the console:

- On Linux / Mac
  <code>./emuStudio</code>

- On Windows:
  <code>emuStudio.bat</code>

For more information, please see the [documentation]({{ site.baseurl }}/documentation/user/application/).

# Software for emulated computers

Software is essential for emulators as it is for computers. For emulators, software is usually preserved in disk images,
ROM images, magnetic tapes in a digitalized form, and there are probably even more options. It then depends solely on
the specific emulator, how it loads the software in.

In emuStudio, each virtual computer has a section in documentation called "Original software". This section provide
links to various sites with software for emulators.

- [MITS Altair8800]({{ site.baseurl }}/documentation/user/altair8800/software)
- [Brainduck]({{ site.baseurl }}/documentation/user/brainduck/examples)
- [SSEM]({{ site.baseurl }}/documentation/user/ssem/software)
