---
layout: default
title: Git workflow
nav_order: 2
parent: Getting started
permalink: /getting_started/gitflow
---

{% include analytics.html category="developer" %}

# Git workflow

emuStudio uses Git and GitHub for version control and review.

The application repository follows a simplified [Git Flow model][gitflow]{:target="_blank"}:

- Development targets the current version on `develop`.
- Releases use the stable `develop` branch directly, without separate release branches.

These branch names and release steps describe the emuStudio application repository. Sibling repositories have their
own branches and publishing workflows; in particular, Edigen and its Gradle plugin have `development` rather than
`develop`. Follow the owning repository's instructions and the [contribution guidance]({{ site.baseurl }}/getting_started/contributing).

## Releases

Release the application as follows:

0. Pre-check everything. Build, documentation, etc.
1. Merge `develop` branch into `master` branch
2. The last commit in the `master` branch is tagged with tag `RELEASE-XXX`, where `XXX` is the released version
3. The release is edited in GitHub to add release notes and binary artifacts

[gitflow]: https://nvie.com/posts/a-successful-git-branching-model/
