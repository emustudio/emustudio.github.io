# Artwork

## Logo

Logo was developed using MetaPost. In order to "compile" the logo, run:

```
mpost logo.mp
```

There is a [blogpost](http://www.mojkod.sk/logo-v-metaposte/) about how emuStudio logo was created, however it's just in Slovak language.

## Animated gif of terminal

1. Edit `automation.yml` and update watermark path to ABSOLUTE PATH of `watermark.svg` file

2. Install [terminalizer](https://github.com/faressoft/terminalizer)

3. Run: `terminalizer render -s 3 -o automation.gif -q 100 automation.yml`


## Thumbnails of screenshots

Thumbnails have width 300px. Using `ImageMagick`:

```
mogrify -resize 300 -filter catrom -quality 100 -normalize -unsharp 10x1+1 *.png
```

## Animated gif of any GUI

Install [peek](https://github.com/phw/peek).
