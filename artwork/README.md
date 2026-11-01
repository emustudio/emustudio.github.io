# Artwork

## Logo

The logo is a MetaPost source. From `artwork/`, run:

```
cd logo
mpost logo.mp
```

There is a [blogpost](http://www.mojkod.sk/logo-v-metaposte/) about how emuStudio logo was created, however it's just in
Slovak language.

## Animated gif of terminal

The files in `gif-automation/` record an emuStudio **0.41** session. Keep their original commands, version output,
and computer indexes as historical evidence. To render the YAML recording:

1. Open `gif-automation/reverse.yml` and set `watermark.imagePath` to the absolute path of `gif-automation/watermark.svg`.
   Its recorded `cwd` is from the original machine; replace it if your renderer needs a local working directory.
2. Use [terminalizer](https://github.com/faressoft/terminalizer).
3. From `gif-automation/`, run `terminalizer render -s 3 -o reverse.gif -q 100 reverse.yml`.

Alternatively, render the existing asciinema recording with `agg --theme asciinema reverse.cast reverse.gif`.

## Thumbnails of screenshots

Thumbnails have width 300px. Using `ImageMagick`:

```
mogrify -resize 300 -filter catrom -quality 100 -normalize -unsharp 10x1+1 *.png
```

## Animated gif of any GUI

Install [peek](https://github.com/phw/peek).
