---
layout: default
title: Logging
nav_order: 7
parent: emuStudio Application
permalink: /application/logging
---

{% include analytics.html category="Application" %}

# Logging

No software is bug-free in these days, and not a person is perfect. Sometimes it might happen that emuStudio is not
working as expected, either it does not start (with a weird message on screen), or it fails while running.

For that purpose, everything important is being logged. If you encounter some problem and either want to fix it or
report it, the logs, except steps to reproduce are the most important thing.
By default, logging is written to the standard output (console). In case of a problem, it is a good practice to enable
file logging.

To enable file logging, open `logback.xml` file located in the root directory of emuStudio. Find a section
named `<root ..>`, and change `appender-ref` from `STDOUT` to `FILE` as follows:

```xml
<root level="info">
    <appender-ref ref="FILE"/>
</root>
```

The log file is named `logs/emuStudio.log`. Every new run of emuStudio will append log messages into that file until
emuStudio is terminated.

The supplied rolling policy keeps up to 10 days of archived logs, rolls each file at 5 MB, and limits archived logs
to 100 MB in total.
It is of course configurable. For more information about how to configure loggers, please look at
the [logback site][logback]{:target="_blank"}.

## Automation logger

An important part of the analysis of the result of the automatic emulation is the log saying what happened. By default,
each emuStudio process creates (overwrites) `logs/automation.log`. Automation progress is written to this file.

The log file is in plaintext format and contains messages which appeared in the log during the emulation.
The log file format can be customized, see the previous section for more details.

[logback]: http://logback.qos.ch/manual/configuration.html
