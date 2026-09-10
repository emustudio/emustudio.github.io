# Welcome to emuStudio website!

[![](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/vbmacher)
[![License: Apache 2.0](https://img.shields.io/badge/license-Apache%20License%202.0-blue)](https://www.apache.org/licenses/LICENSE-2.0)

The website is built using GitHub Pages with the [Jekyll](https://jekyllrb.com/) static-site generator.
The project is organized as **three separate Jekyll sites** that are combined at build time:

| Site | Source | Jekyll version | Theme |
|---|---|---|---|
| Root website | `/` (this repo root) | 3.x (`github-pages` gem) | custom (scotch-io) |
| User documentation | `_documentation/user/` | 4.3.1 | [just-the-docs](https://github.com/pmarsceill/just-the-docs) |
| Developer documentation | `_documentation/developer/` | 4.3.1 | [just-the-docs](https://github.com/pmarsceill/just-the-docs) |

Documentation sub-sites are pre-built into the `documentation/` directory and served as static files by the root site.

## License

The website is released under [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0). The website uses Jekyll
templates which might be released under different licenses:

- [just-the-docs](https://github.com/pmarsceill/just-the-docs)
- [scotch-io](https://github.com/scotch-io/scotch-io.github.io)

## Prerequisites

- **Ruby** ≥ 2.7
- **Bundler** (`gem install bundler`)

Install dependencies for each Jekyll site:

```bash
# Root site
bundle install

# Documentation sub-sites
cd _documentation/user    && bundle install && cd ../..
cd _documentation/developer && bundle install && cd ../..
```

## Rake tasks

The project uses a `Rakefile` as the single entry-point for all build and quality-assurance tasks.
List every available task with:

```bash
bundle exec rake -T
```

| Task | Description |
|---|---|
| `rake build` | **Full production build** — lint → clean → build docs → build site → post-build lint |
| `rake build:docs` | Build the user & developer documentation sub-sites |
| `rake build:site` | Build the root Jekyll site |
| `rake lint` | Run all **pre-build** lint checks |
| `rake lint:post_build` | Run all **post-build** lint checks |
| `rake lint:target_blank` | Verify reference-style links have `{:target="_blank"}` |
| `rake lint:link_spaces` | Detect accidental spaces before `{:target="_blank"}` |
| `rake lint:baseurl_slash` | Ensure `site.baseurl` usage is followed by `/` |
| `rake lint:imagepath` | Detect unreplaced `{imagepath}` in generated HTML |
| `rake lint:broken_links` | Detect broken internal markdown links (files that don't exist) |
| `rake clean` | Delete generated sites and Jekyll caches |
| `rake serve` | Start a local dev server with live-reload at http://localhost:4000/ |

### Quick start

```bash
# Full production build (lint + build + validate)
bundle exec rake build


# Development: start local server
bundle exec rake serve

# Run just the lint checks (no build)
bundle exec rake lint
```

## Lint checks

The following automated checks are run during `rake build` to catch common authoring mistakes:

| Check | Phase | What it verifies |
|---|---|---|
| `target_blank` | pre-build | Every reference-style markdown link in `_documentation/**/*.md` is followed by `{:target="_blank"}` (with a configurable exclusion list for internal references). |
| `link_spaces` | pre-build | No accidental whitespace between a link and `{:target="_blank"}`. |
| `baseurl_slash` | pre-build | Every `{{ site.baseurl }}` in templates/pages is followed by `/`. |
| `broken_links` | pre-build | Relative markdown links point to files that actually exist. |
| `imagepath` | post-build | No unreplaced `{imagepath}` placeholders remain in the generated HTML. |

## Tools

- Logo: MetaPost
- Screenshot editing (markup): [Shutter][shutter]
- Animated gif:
    - [peek][peek]: for bitmap gifs
    - [asciinema][asciinema], [agg][agg]: for terminal gifs
      - `./agg --theme asciinema reverse.cast reverse.gif`
- Thumbnails: imagemagick

[peek]: https://github.com/phw/peek 
[asciinema]: https://github.com/asciinema/asciinema
[agg]: https://github.com/asciinema/agg
[shutter]: https://shutter-project.org/
