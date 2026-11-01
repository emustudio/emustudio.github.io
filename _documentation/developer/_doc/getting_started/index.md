---
layout: default
title: Getting started
nav_order: 2
has_children: true
permalink: /getting_started/
---

{% include analytics.html category="developer_getting_started" %}

# Getting started

emuStudio is a Java Swing application with a virtual computer editor, source code editor, and debugger. At startup,
the user selects a computer configuration. The application loads and connects plugin instances according to that
configuration, then controls their execution through the debugger.

Each plugin is a JAR file. Bundle its dependencies except for the libraries supplied by emuStudio on the classpath:

- [emuLib][emulib-github]{:target="_blank"} (Maven [here][emulib-maven]{:target="_blank"})
- [ANTLR4 runtime][antlr-runtime]{:target="_blank"}
- [SLF4J logging][slf4j]{:target="_blank"}
- [Picocli][picoli]{:target="_blank"} for command-line parsing

The application also provides:

- plugin configuration management through [PluginSettings][pluginSettings]{:target="_blank"}
- context registration and lookup through `ApplicationApi.getContextPool()`
- runtime API for the communication between plugins and emuStudio application - implementation
  of [ApplicationApi][applicationApi]{:target="_blank"}

Plugins receive these objects through their constructor. There are four plugin types: a **compiler** that produces
code for emulated memory, a **CPU** emulator, **memory**, and **devices**. A computer can have at most one compiler,
CPU, and memory plugin, and any number of devices. Its basic model is inspired by the
[von Neumann model][vonNeumann]{:target="_blank"}.

Each plugin implements the emuLib API and is installed in the corresponding emuStudio subdirectory.

## Building the application and plugins

Use each repository's wrapper. emuStudio uses Gradle 8.14.4 and requires an installed **JDK 11 compilation toolchain**.
emuLib uses Gradle 9.0, which needs **JDK 17 or later to run**; JDK 21 is a suitable build JDK. emuLib still targets
Java 11 bytecode. Installing only JDK 21 does not supply emuStudio's requested JDK 11 compiler.

For emuStudio alone, set `JAVA_HOME` to JDK 11. To run both wrappers with JDK 21, install JDK 11 as well and make it
discoverable by Gradle. For example, after replacing these paths with your installed JDK locations:

{:.code-example}
```sh
export JAVA_HOME=/path/to/jdk-21
./gradlew -Porg.gradle.java.installations.paths=/path/to/jdk-11 build
```

In the emuStudio checkout, `./gradlew build` builds and tests the application and bundled plugins;
`./gradlew :application:distZip :application:distTar` creates distributions. `./gradlew doc` renders the repository's
architecture documentation.

If Gradle reports that no Java 11 toolchain matches, check that the configured path points to a JDK containing `bin/javac`.
Run `./gradlew -q javaToolchains` to inspect discovered installations. This build does not configure automatic toolchain
downloads.

emuStudio uses `net.emustudio:emulib:12.1.0-SNAPSHOT`. For local development against a sibling emuLib checkout, run
the following from emuStudio with JDK 21 and the Java 11 toolchain available:

{:.code-example}
```sh
./gradlew -PemuLibPath=../emuLib build
```

This composite build substitutes the local emuLib project for the Maven dependency. Alternatively, run
`./gradlew publishToMavenLocal` in emuLib before building emuStudio; emuStudio checks Maven Local first.
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
