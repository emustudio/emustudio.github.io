# emuStudio Website

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

- Primary: students learning assembly language and computer architecture, and teachers preparing demonstrations, exercises, and programming assignments.
- Secondary: retro-computing enthusiasts writing and running vintage software, and developers building or extending emulators and plugins.

## Product Purpose

Help visitors understand emuStudio, obtain the desktop application, and learn to use or extend it. Success means a visitor can find the appropriate download or guide and proceed with a concrete programming, teaching, or emulator-development task.

The desktop product is a computer-emulation platform and framework. It supports writing and compiling programs, loading them into an emulated computer, running them, and debugging their behavior.

## Positioning

emuStudio emphasizes learning and experimentation through a complete write–compile–load–run–debug workflow. It combines real vintage computers and abstract teaching machines with APIs for creating and reusing emulator components. Historical accuracy matters, while comfortable programming and experimentation are the stated focus.

## Operating Context

- Visitors can inspect screenshots, download the application, read user guides, or follow developer documentation.
- Students and enthusiasts use the desktop application to edit source, compile programs, inspect execution, and experiment with virtual hardware. Teachers can use demonstrations and automated emulation for assignments.
- Developers use the plugin API and related projects: emuLib for shared runtime services, Edigen for optional decoder/disassembler generation, and cpu-testsuite for optional CPU testing support.
- Downloads and issue reporting use GitHub. Installation and runtime requirements belong to the download page and user documentation.

## Capabilities and Constraints

- This repository owns the public website, user and developer documentation, screenshots, and release-facing content. The emulator runs as a desktop application; this website does not provide a browser-based emulator.
- The existing stack is Jekyll on GitHub Pages. The root website and the user and developer documentation are three separate Jekyll sites combined at build time. Documentation uses the just-the-docs theme.
- Documented computers include MITS Altair 8800, ZX Spectrum 48K, Space Invaders, SSEM, RAM, RASP, and BrainDuck. Keep capability claims aligned with the owning implementation and current documentation.
- User documentation may describe development features newer than the latest published release. Preserve this distinction when describing downloads or feature availability.
- Documentation and product behavior must agree. Changes to application behavior or shared API contracts belong in their owning sibling repositories as well as the documentation when applicable.
- Every repository change requires an existing GitHub ticket. Commit subjects use the `[#123] Short summary` format; related changes across emuStudio repositories share the ticket prefix.
- Keep the website's Apache 2.0 license distinct from the desktop application's GPL licensing; do not generalize one license across all project assets or dependencies.
- No additional product-specific accessibility standard or binding brand constraints were established during initialization; those decisions remain open.

## Brand Commitments

Use the existing emuStudio name and project identity. Preserve factual terminology for computers, hardware, plugins, and programming workflows. Existing copy addresses learners and enthusiasts directly; use clear explanations that make technical experimentation approachable.

## Evidence on Hand

- `index.html`: platform and framework explanation, supported-computer links, and entry points to screenshots, downloads, and documentation.
- `_pages/about.md`: educational origins, teaching and enthusiast use cases, contribution paths, and application licensing notice.
- `_pages/download.md`: distribution links, installation instructions, and the distinction between development documentation and published releases.
- `_pages/screenshots.md` and `files/images/`: existing screenshots and logo assets. `artwork/` contains asset sources and production notes.
- `_documentation/user/`: application workflows, virtual-computer guides, software examples, and automation documentation.
- `_documentation/developer/`: plugin and API guides, related-project references, and publication references.
- `README.md`, `Rakefile`, and the three Jekyll configurations: build, validation, and site-boundary evidence.
- `AGENTS.md`: repository ownership and ticket/commit requirements.

These materials support descriptions of the product. Do not turn them into invented testimonials, adoption statistics, performance benchmarks, or unsupported compatibility claims.

## Product Principles

1. Put learning and teaching tasks first, while keeping useful paths for enthusiasts and emulator developers.
2. Connect explanations to practical programming and experimentation workflows.
3. Help visitors distinguish installing and using the application from extending the framework.
4. Keep documentation, screenshots, implementation, and release availability consistent.
5. Ground claims in the project's actual capabilities and inspectable evidence.
