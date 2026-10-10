---
layout: default
title: Getting started
nav_order: 2
has_children: true
permalink: /getting_started/
---

{% include analytics.html category="developer_getting_started" %}

# Getting started

emuStudio is a Java Swing application that implements editor of virtual computer, source code editor,
and emulation "controller" (sometimes known as "debugger"). The emulation controller is used for controlling the
emulation, and also supports interaction in application GUI. Under the hood, it operates with an instance
of the so-called "virtual computer". The virtual computer - or a computer emulator - is loaded from the computer
configuration, selected by the user on the application startup.

Virtual computer is assembled from plugin object instances, possibly interconnected, according to the definition of
given computer configuration. Each plugin is a single, almost a self-contained JAR file. It means almost all
dependencies the plugin uses are present in the JAR file, except the following, which are bundled with emuStudio and
will always be available in the class-path:

- [emuLib][emulib-github]{:target="_blank"} (Maven [here][emulib-maven]{:target="_blank"})
- [ANTLR4 runtime][antlr-runtime]{:target="_blank"}
- [SLF4J logging][slf4j]{:target="_blank"}
- [Picocli][picoli]{:target="_blank"} for command-line parsing

The application provides also:

- plugin configuration management through [PluginSettings][pluginSettings]{:target="_blank"}
- context registration and lookup through `ApplicationApi.getContextPool()`
- runtime API for the communication between plugins and emuStudio application - implementation
  of [ApplicationApi][applicationApi]{:target="_blank"}

Plugins get those objects in the constructor. Details are provided in further chapters, but here can be revealed just
this: there are four types of plugins: a **compiler** (which can produce code loadable in the
emulated memory), one **CPU** emulator, one operating **memory**, and none, one or more virtual **devices**. The core
concept of
a virtual computer is inspired by the [von Neumann model][vonNeumann]{:target="_blank"}.

Each plugin implements API from emuLib, following some predefined rules. Plugin physically is compiled into a JAR file
and copied into particular subdirectory in emuStudio installation.

## Building the application and plugins

Use the wrapper supplied by each repository: emuStudio uses Gradle 8.14.4, while emuLib uses Gradle 9.0.
JDK 21 can run both wrappers. emuStudio requests a Java 11 compilation toolchain; emuLib targets Java 11 bytecode.
In the emuStudio checkout, `./gradlew build` builds and tests the application and
bundled plugins; `./gradlew :application:distZip :application:distTar` creates distributions. `./gradlew doc` renders
the repository's architecture documentation.

emuStudio uses `net.emustudio:emulib:12.1.0-SNAPSHOT`. When developing both repositories locally, run
`./gradlew publishToMavenLocal` in emuLib before building emuStudio; its dependency lookup checks Maven Local first.
For public API details, use the [emuLib reference][emulib-javadoc]{:target="_blank"}.

## GitHub repositories

From architecture perspective, emuStudio is a family of [GitHub repositories][emustudio-github-all]{:target="_blank"}, a
combination of multiple sister projects:

- [emuStudio][emustudio-github]{:target="_blank"} - application and plugins
- [emuLib][emulib-github]{:target="_blank"} - a shared run-time library used by emuStudio and plugins. Javadoc is [here][emulib-javadoc]{:target="_blank"}.
- [Edigen][edigen-github]{:target="_blank"} - CPU instruction decoder and disassembler generator based on a specification file.
- [Edigen Gradle plugin][edigen-github-gradle]{:target="_blank"}
- [CPU testing suite][cpu-testsuite-github]{:target="_blank"} - a general unit-testing framework for testing CPU plug-ins. Tests are
  specified in a declarative way.
- [emuStudio website][website-github]{:target="_blank"}


[antlr-runtime]: https://www.antlr.org/
[slf4j]: https://www.slf4j.org/
[picoli]: https://picocli.info/
[pluginSettings]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/runtime/settings/PluginSettings.html
[applicationApi]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/runtime/ApplicationApi.html
[vonNeumann]: https://en.wikipedia.org/wiki/Von_Neumann_architecture

[emulib-maven]: https://central.sonatype.com/artifact/net.emustudio/emulib
[emulib-github]: https://github.com/emustudio/emuLib
[emulib-javadoc]: {{ site.baseurl }}/emulib_javadoc/
[emustudio-github-all]: https://github.com/orgs/emustudio/repositories
[emustudio-github]: https://github.com/emustudio/emuStudio
[edigen-github]: https://github.com/emustudio/edigen
[edigen-github-gradle]: https://github.com/emustudio/edigen-gradle-plugin
[cpu-testsuite-github]: https://github.com/emustudio/cpu-testsuite
[website-github]: https://github.com/emustudio/emustudio.github.io
