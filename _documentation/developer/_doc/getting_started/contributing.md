---
layout: default
title: How to contribute
nav_order: 1
parent: Getting started
permalink: /getting_started/contributing
---

{% include analytics.html category="developer" %}

# How to contribute

There are several options on how to contribute. One option is to test, fix, or enhance the application or plugins.
Another option is to implement a completely new computer which can be used with emuStudio. The latter is not considered
a contribution unless it is a [FOSS][foss]{:target="_blank"}. Last option is to support the project by spreading the
word or providing a financial support.

Each contribution topic should be tracked in a separate ticket in particular GitHub repository.

Code contributors should start with forking particular GitHub repository, and branch off the `development` branch in a
feature/bugfix
branch named:

- `feature-XXX` when it's a feature, and `XXX` is a ticket number
- `bugfix-XXX` when it's a bugfix, and `XXX` is a ticket number

When you are satisfied with your work, make a git commit in your branch. A commit message should be in the following
form:

{:.code-example}
```
[#XXX] Description of commit
``` 

where `XXX` represents a ticket number. Please make sure the description is accurate, not too short and not too long.

Next step is to make a [pull request][pull-requests]{:target="_blank"} to the upstream repository (original one), into
branch `development`. Then, someone will review the PR, test it, and can suggest some changes. When reviewers are
satisfied, they will merge the PR. If the commit message follows the formatting standard, the commit will appear in
the ticket as a comment.

## Code style

Code should be "clean", in terms of sticking to various good practices and principles (e.g. [SOLID][solid]{:target="_blank"},
[GRASP][grasp]{:target="_blank"}, [YAGNI][yagni]{:target="_blank"}, [KISS][kiss]{:target="_blank"},
[DRY][dry]{:target="_blank"}, etc.).

The repositories are supplied with [.editorconfig][editorconfig]{:target="_blank"} file which is supposed to be used in
your favourite IDE.

## Definition of DONE

Some requirements need to be fulfilled before we can say that the contribution is "done" and can be
accepted or released. The list is very simple:

- Code should work and be fully tested
- Code should be clean, conforming the code style
- Code must have proper unit tests, if applicable or possible
- Documentation should be updated

[pull-requests]: https://help.github.com/articles/using-pull-requests/
[solid]: https://en.wikipedia.org/wiki/SOLID
[grasp]: https://en.wikipedia.org/wiki/GRASP_(object-oriented_design)
[yagni]: https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it
[kiss]: https://en.wikipedia.org/wiki/KISS_principle
[dry]: https://en.wikipedia.org/wiki/Don%27t_repeat_yourself
[foss]: https://en.wikipedia.org/wiki/Free_and_open-source_software
[editorconfig]: https://editorconfig.org/
