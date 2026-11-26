---
layout: default
title: Logging
nav_order: 7
parent: emuStudio Application
permalink: /application/logging
---

{% include analytics.html category="Application" %}

# Logging

Check emuStudio's logs for startup, plugin, and execution messages. Save the relevant lines alongside the computer configuration and steps when reporting a problem.

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

The supplied configuration also creates `logs/automation.log`. It records progress, compiler messages, the final
instruction address when available, and a `Run result:` entry with the stop reason. Copy the file before starting
another emuStudio process to retain the result.

Check this file and the devices' output when evaluating [automatic emulation]({{ site.baseurl }}/application/automation).
Check the stop reason as well as the exit status. A clean timeout can return exit status `0`.

[logback]: http://logback.qos.ch/manual/configuration.html
