# emuStudio Repo Routing

## Current Repository
- `emustudio.github.io` owns the public website, user documentation, developer documentation, release-facing pages, and download-related content.
- Main locations in this repository: site root, `_documentation/user`, and `_documentation/developer`.

## Sibling Repositories
- `/home/vbmacher/projects/emustudio/emuLib`: shared plugin API, runtime services, shared UI helpers, and reusable utilities.
- `/home/vbmacher/projects/emustudio/edigen`: decoder/disassembler generator from `.eds` specifications.
- `/home/vbmacher/projects/emustudio/emuStudio`: desktop application, bundled plugins, virtual computers, configs, and packaging.
- `/home/vbmacher/projects/emustudio/emustudio.github.io`: website, user documentation, developer documentation, and release-facing pages.
- `/home/vbmacher/projects/emustudio/edigen-gradle-plugin`: Gradle task and DSL integration for Edigen source generation.
- `/home/vbmacher/projects/emustudio/cpu-testsuite`: shared CPU instruction test framework and reusable verification helpers.

## When To Update Which Repository
- User documentation, developer documentation, website pages, screenshots, download links, or release-facing content: update `emustudio.github.io`.
- If documentation changes because product behavior changed, also update the owning code repository: `emuStudio`, `emuLib`, `edigen`, `edigen-gradle-plugin`, or `cpu-testsuite`.
- Desktop app, bundled plugin, or virtual computer behavior: update `emuStudio`.
- Shared API or runtime contract described in documentation: update `emuLib`.
- Edigen DSL, generated decoder/disassembler behavior, or Gradle integration documented on the site: update `edigen` and, if needed, `edigen-gradle-plugin`.

## Tickets And Commits
- Every change must have an existing GitHub ticket.
- Every commit subject must start with the ticket prefix: `[#123] Short summary`.
- If one task touches multiple emuStudio repositories, use the same ticket prefix in each related commit.
