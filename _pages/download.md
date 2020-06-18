---
layout: default
title: Download & Install
permalink: /download/
---

<div class="jumbotron">
  <div class="dropdown">
    <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
      Select version
      <span class="caret"></span>
    </button>
    <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
      <li><a href="#">0.40 (new)</a></li>
      <li><a href="#">0.39</a></li>
      <li role="separator" class="divider"></li>
      <li><a href="#">Very first</a></li>
    </ul>
  </div>
  
  <div class="dropdown">
    <button id="dLabel" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
      Dropdown trigger
    </button>
    <div class="dropdown-menu" aria-labelledby="dLabel">
      ...
    </div>
  </div>
  
  <div class="table-responsive">
    <table class="table borderless">
      <tr><th>Version:</th><td>0.40</td></tr>
      <tr><th>Java requirements:</th><td><a href="https://jdk.java.net/archive/" target="_blank">Java 11</a></td></tr>
      <tr><th>Release date:</th><td>TBD 2020</td></tr>
      <tr><th>Release notes:</th><td><a href="">Release notes</a></td></tr>
      <tr><th>Download:</th><td>
      <span class="glyphicon glyphicon-download-alt" aria-hidden="true"></span>
                <a href="https://github.com/emustudio/emuStudio/releases/download/RELEASE-0.40/emuStudio-0.40.zip" 
                   class="button btn-link btn-lg"
                   role="button"
                   target="_blank">emuStudio-0.40.zip</a>
                <a href="https://github.com/emustudio/emuStudio/releases/download/RELEASE-0.40/emuStudio-0.40.tar" 
                   class="button btn-link btn-lg"
                   role="button"
                   target="_blank">emuStudio-0.40.tar</a>
      </td></tr>
    </table>
  </div>
  
  
  <div class="table-responsive">
    <table class="table borderless">
      <tr>
        <th>Version</th>
        <th>Released</th>
        <th>Java Requirements</th>
        <th>Download</th>
      </tr>
      <tr class="active">
        <td>0.40</td>
        <td>
          <div>TBD 2020</div>
          <div><a href="">Release notes</a></div>
        </td>
        <td><a href="https://jdk.java.net/archive/" target="_blank">Java 11</a></td>
        <td>
          <span class="glyphicon glyphicon-download-alt" aria-hidden="true"></span>
          <a href="https://github.com/emustudio/emuStudio/releases/download/RELEASE-0.40/emuStudio-0.40.zip" 
             class="button btn-link btn-lg"
             role="button"
             target="_blank">emuStudio-0.40.zip</a>
          <a href="https://github.com/emustudio/emuStudio/releases/download/RELEASE-0.40/emuStudio-0.40.tar" 
             class="button btn-link btn-lg"
             role="button"
             target="_blank">emuStudio-0.40.tar</a>
        </td>
      </tr>
      <tr>
        <td>0.39</td>
        <td>
          <div>20.3.2017</div>
          <div><a href="https://github.com/emustudio/emuStudio/releases/download/RELEASE-0.39/changelog-0.39.md" target="_blank">Release notes</a></div>
        </td>
        <td><a href="http://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html" target="_blank">Java 8</a></td>
        <td>
          <span class="glyphicon glyphicon-download-alt" aria-hidden="true"></span>
          <a href="https://github.com/emustudio/emuStudio/releases/download/RELEASE-0.39/emuStudio-0.39.zip" 
             class="button btn-link btn-lg"
             role="button"
             target="_blank">emuStudio-0.39.zip</a>
        </td>
      </tr>
      <tr>
        <td>Very first</td>
        <td>
          <div>2007</div>
        </td>
        <td>Java 6</td>
        <td>
          <span class="glyphicon glyphicon-download-alt" aria-hidden="true"></span>
          <a href="{{ site.baseurl }}/files/emu8-very-first.zip" 
             class="button btn-link btn-lg"
             role="button"
             target="_blank">emu8-very-first.zip</a>
        </td>
      </tr>
    </table>
  </div>
  <p>
    Other versions of emuStudio are available at
     <a href="https://github.com/emustudio/emuStudio/releases" target="_blank">GitHub</a>.     
  </p>
</div>

# Supported platforms

Currently, supported platforms are Linux and Windows. However, emuStudio might work (to some extent) on any platform
(including Mac) which supports Java.

# Installation & run

Unpack <code>emuStudio-[version].tar</code> (or <code>emuStudio-[version].zip</code>) file into location where you want to have emuStudio
installed. The archive file contains the whole emuStudio with all official computer emulators and examples.
 
In order to run emuStudio, run the following command from console:

- On Linux / Mac
<code>./emuStudio</code>

- On Windows:
<code>emuStudio.bat</code>

For more information, please see the [documentation]({{ site.baseurl }}/documentation/user/application/).


# Disk images, ROMs, etc.

There is possibility to run some original software for emulated computers on emuStudio (e.g. CP/M operating system on
MITS Altair8800). In order to keep being "legal-safe", it is better to not share the images here or within the emuStudio
release. More information (e.g. links where the images can be downloaded, etc.) can be found in the virtual computers' documentation.
