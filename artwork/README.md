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

Capture emuStudio windows at their normal size with the application's default IntelliJ theme. Include only the window
or panel being explained. On Wayland, capture the window region with `grim`; Java Robot can return a black image for
XWayland windows. Move the mouse pointer outside the capture area before taking each screenshot. Keep terminal text
and display canvases in the capture.

For dialogs, burn numbered marks directly into the PNG beside the controls. Each mark is a white circle with a black
number and border. Open the image file on its own to check that the marks are present. Follow the screenshot immediately
with a two-column table containing one explanation per mark. For short toolbars, add space below the buttons inside
the image for the marks.

Thumbnails have width 300px. Using `ImageMagick`:

```
mogrify -resize 300 -filter catrom -quality 100 -normalize -unsharp 10x1+1 *.png
```

## Animated gif of any GUI

Install [peek](https://github.com/phw/peek).
