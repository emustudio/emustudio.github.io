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

The emuLib API reference is generated under `_documentation/developer/emulib_javadoc/`. With emuLib checked out beside
this repository, select a build JDK supported by its wrapper (JDK 21 or 25 for the current checkout), then run:

{:.code-example}
```sh
bundle exec rake build:api
# Or select another emuLib checkout:
bundle exec rake 'build:api[/path/to/emuLib]'
```

This runs `./gradlew javadoc` in emuLib, replaces the bundled reference with `build/docs/javadoc/`, and removes trailing
whitespace emitted by Javadoc during import. Include that generated tree when public APIs change; do not hand-edit its
HTML. The normal site build uses the committed reference and does not regenerate it.

## User documentation

Organize user documentation by virtual computer, with a directory such as `_documentation/user/_doc/altair8800` and
separate plugin pages such as `byte-mem.md`. Cover supported configurations and plugins, and identify optional components.

Focus on user interactions and results. Explain prerequisites, exact controls, configuration keys, and practical limits;
put implementation details in the developer guide.

### Structure

Virtual computer documentation should start with a short introduction:

- Historical context
- Whether it is an abstract model or a real computer
- Its purpose
- Supported configurations
- Supported features and differences from the original computer

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

The developer guide introduces emuStudio internals and plugin development. Explain technical contracts and design
rationale, with enough examples to help contributors implement them. Avoid inventories of the plugin's code structure.

A separate developer page for each plugin is optional; plugin documentation is published as part of the computer's
documentation rather than as a standalone manual.
