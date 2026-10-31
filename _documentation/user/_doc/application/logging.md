---
layout: default
title: Logging
nav_order: 7
parent: emuStudio Application
permalink: /application/logging
---

{% include analytics.html category="Application" %}

# Logging

emuStudio logs startup, plugin, and execution messages. When reporting a problem, include the relevant log messages,
the computer configuration, and the steps needed to reproduce it. The supplied configuration writes general messages
to the console; enable file logging to retain them.

Open the distribution's `logback.xml` and replace the `STDOUT` reference in the `<root>` section with `FILE`:

```xml
<root level="info">
    <appender-ref ref="FILE"/>
</root>
```

General messages are then appended to `logs/emuStudio.log`, relative to the current working directory. Keep both
appender references if you also want console output.

The supplied rolling policy keeps up to 10 days of archived logs, rolls each file at 5 MB, and limits archived logs
to 100 MB in total.
For other logging options, see the [Logback configuration manual][logback]{:target="_blank"}.

## Automation logger

The supplied configuration also creates `logs/automation.log`. This plain-text file records automation progress,
compiler messages, the CPU's final state, and instruction address. It is overwritten when a new emuStudio process starts,
so copy it before another run if you need to retain a result.

Check this file and the devices' output when evaluating [automatic emulation]({{ site.baseurl }}/application/automation).
An automation failure is not always reflected in the process exit status.

[logback]: http://logback.qos.ch/manual/configuration.html
