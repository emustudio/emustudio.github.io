---
layout: default
title: Documenting
nav_order: 3
parent: Getting started
permalink: /getting_started/documenting
---

{% include analytics.html category="developer" %}

# Documenting

The website repository contains separate Jekyll sites for user and developer documentation. Both describe the current
application and plugin APIs. Their source pages are under:

{:.code-example}
```
_documentation
  |
  + developer
  |  + _doc/ ... developer pages ...
  + user
     + _doc/ ... user pages ...
```

Edit the site that matches your audience. Document the current workflow and API directly, with working examples and
exact configuration keys. Keep user instructions about controls and results; put implementation contracts in the
developer guide.

From the website repository root, run:

{:.code-example}
```
bundle exec rake lint
bundle exec rake build
```

The build renders both documentation sites into `documentation/`, builds the root website, and checks the generated
output. Commit the source pages; generated site output is ignored by Git.

The emuLib API reference is under `_documentation/developer/emulib_javadoc/`. Generate it with `./gradlew javadoc` in
the emuLib checkout, then replace this directory with `build/docs/javadoc/`. Include the regenerated reference in the
documentation change when public APIs change.

## User documentation

Plugins are usually part of virtual computers. Therefore, virtual computers are "chapters" in the documentation in a
separate directory (e.g. `_documentation/user/_doc/altair8800`), and plugins are described there, in a separate file
(e.g. `byte-mem.md`). The documentation of virtual computer should document all possible configurations, and all possible
plugins, even if their use is optional (which should be documented as well).

User documentation should focus on the interaction part with the user of emuStudio, and should not go in details
of what's going under the hood. Keep the information useful. Do not bloat text with obvious.

### Structure

Virtual computer documentation should start with a short introduction:

- How the computer is related to computer history?
- Is it abstract or real?
- The purpose of the computer
- Possible computer configurations
- Comparison of features which are supported vs. features of real computer

Order each computer's pages as follows, omitting categories that do not apply:

- introduction (the computer's parent page)
- software and examples
- automation
- assemblers and compilers
- CPU
- memory
- devices, alphabetically

Use `nav_order` in front matter to control this order. Keep troubleshooting guidance beside the workflow it explains.

## Developer's documentation

Developer documentation (as you read this one) focuses on introducing new contributors to emuStudio internals and plugin
development. You can contribute by fixing or extending the existing plugin.

Developer documentation of a particular plugin is optional. The reason is that plugin documentation will not be
published separately, just as part of the documentation of the whole computer.

In the developer documentation, only technical details should be explained, not the structure of the plugin code.
Majority of things which the documentation should include are the "why"s instead of "how"s.
