---
layout: default
title: How to contribute
nav_order: 1
parent: Getting started
permalink: /getting_started/contributing
---

{% include analytics.html category="developer" %}

# How to contribute

You can contribute by testing, fixing, or extending the application or plugins. New virtual computers must be
[free and open-source software][foss]{:target="_blank"} to qualify as contributions. You can also support the project
by spreading the word or providing financial support.

Track each contribution in a separate ticket in the owning GitHub repository.

Fork the owning repository and check its contribution instructions and development branch before branching. The
emuStudio application uses `develop`; the Edigen repositories have a `development` branch rather than `develop`.
Confirm the intended
pull-request base in the owning ticket if the repository does not specify it.

Name your feature or bugfix branch:

- `feature-XXX` when it's a feature, and `XXX` is a ticket number
- `bugfix-XXX` when it's a bugfix, and `XXX` is a ticket number

Commit your work with a subject in this form:

{:.code-example}
```
[#XXX] Description of commit
``` 

where `XXX` is the ticket number. Describe the change accurately and concisely.

Open a [pull request][pull-requests]{:target="_blank"} against the upstream repository's agreed development branch
(`develop` for the emuStudio application). Reviewers will check and test the change, request revisions when needed,
and merge it when ready. The ticket prefix links the commit to its issue.

## Code style

Code should be "clean", in terms of sticking to various good practices and principles (e.g. [SOLID][solid]{:target="_blank"},
[GRASP][grasp]{:target="_blank"}, [YAGNI][yagni]{:target="_blank"}, [KISS][kiss]{:target="_blank"},
[DRY][dry]{:target="_blank"}, etc.).

Use the repository's [.editorconfig][editorconfig]{:target="_blank"} settings in your IDE.

## Definition of DONE

Before a contribution can be accepted or released:

- Verify that the code works.
- Follow the repository's code style.
- Add appropriate unit tests where applicable.
- Update affected documentation.

[pull-requests]: https://help.github.com/articles/using-pull-requests/
[solid]: https://en.wikipedia.org/wiki/SOLID
[grasp]: https://en.wikipedia.org/wiki/GRASP_(object-oriented_design)
[yagni]: https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it
[kiss]: https://en.wikipedia.org/wiki/KISS_principle
[dry]: https://en.wikipedia.org/wiki/Don%27t_repeat_yourself
[foss]: https://en.wikipedia.org/wiki/Free_and_open-source_software
[editorconfig]: https://editorconfig.org/
