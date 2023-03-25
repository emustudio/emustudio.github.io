# Welcome to emuStudio website!

[![](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/vbmacher)

The website is built using GitHub pages, using Jekyll static site generator.

## License

The website is released under [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0). The website uses Jekyll
templates which might be released under different licenses:

- [just-the-docs](https://github.com/pmarsceill/just-the-docs)
- [scotch-io](https://github.com/scotch-io/scotch-io.github.io)

## Setting up the environment

The website, user documentation and developer documentation are separate Jekyll sites. Dependencies of all three
are maintained separately, in files:

- Root `Gemfile` for the website,
- `_documentation/user/Gemfile`
- `_documentation/developer/Gemfile`

It is good to have installed `bundle` application on your machine. Then, run the following command in each location
where `Gemfile` is present:

```bash
bundle install
```

After successful execution, the website can be served locally with command:

```bash
bundle exec jekyll s
``` 

Then, navigate the browser to http://localhost:4000/.

## Building the website

In order to build a production version of the site, run the build script:

```bash
build.sh
```

This will generate `_site` directory where you can find production version of the website along with the documentation.
If you like to generate just user/developer documentation, run separate build scripts:

- `_documentation/user/build.sh` to generate user documentation
- `_documentation/developer/build.sh` to generate developer documentation

Both documentations are generated into `documentation` directory. This directory must be committed to git, since
the documentation won't be processed by GitHub pages, just the website.

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
