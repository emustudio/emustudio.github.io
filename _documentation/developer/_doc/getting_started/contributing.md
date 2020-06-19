---
layout: default
title: How to contribute
nav_order: 1
parent: Getting started
permalink: /getting_started/contributing
---

# How to contribute

There are two options on how to contribute. Either you fix or enhance the application or plugins, or
you implement a completely new computer which can be used with emuStudio. The latter is not a contribution
unless it is included in the original emuStudio repository.

Each contribution topic should have a separate issue on GitHub, where discussions can be held. Contributors
should fork the repository, and derive their feature branches from the `development` branch. 

When you are satisfied with your work, make a [pull request][pull-requests]{:target="_blank"} to
the main repository, into branch `development`. Then, some reviewers will take a look at the PR, and can suggest some
changes, or will merge it.

Commit messages should be in the form of:

```
[#XXX] Description of commit
``` 

where `#XXX` represents the issue number. Then, the commit will appear as a comment in the issue, so it can be
properly tracked.

## Code style

Code should be "clean", in terms of sticking to various good practices and principles (e.g. [SOLID][solid]{:target="_blank"},
[GRASP][grasp]{:target="_blank"}, [YAGNI][yagni]{:target="_blank"}, [KISS][kiss]{:target="_blank"},
[DRY][dry]{:target="_blank"}, etc.).

Code use 4 spaces.

## Definition of DONE

Some requirements need to be fulfilled before we can say that the contribution is "done" and can be
accepted or released. The list is very simple:

- Code should be clean, conforming to the code style
- Code must have proper unit tests, if applicable or possible
- Documentation should be updated



[pull-requests]: https://help.github.com/articles/using-pull-requests/
[solid]: https://en.wikipedia.org/wiki/SOLID
[grasp]: https://en.wikipedia.org/wiki/GRASP_(object-oriented_design)
[yagni]: https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it
[kiss]: https://en.wikipedia.org/wiki/KISS_principle
[dry]: https://en.wikipedia.org/wiki/Don%27t_repeat_yourself
