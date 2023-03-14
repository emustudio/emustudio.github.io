---
layout: default
title: Abstract tape
nav_order: 5
parent: RAM
permalink: /ram/abstract-tape
---

{% include analytics.html category="RAM" %}

# Abstract tape

Abstract tapes, in general, are used in various abstract machines. Probably the best known are Turing machine, RAM
machine, and RASP machine. The plugin of the abstract tape for emuStudio is called `abstract-tape`.

There are several properties which an abstract tape might have:

- Bounded, one-side bounded or unbounded
- Random access (allowing to move the head in both directions) or linear access (allowing to move head only in one
  direction)
- Specific or any cell content type (e.g. cells are integers, or strings, or can be any value?)
- Read-only, or read-write cells
- Purpose of the tape (title)

This plugin allows us to set up such properties, but those are set up by the virtual computer which uses it, not by
the user. For more information, please see the programming section.

Currently, there are just two virtual computers utilizing this plugin:

- RAM machine
- RASP machine

After emuStudio is run, RAM CPU (or RASP CPU) sets up properties for all used tapes. So the tape "purpose" and behavior
is set in run time.

## Graphical user interface (GUI)

The graphical user interface of the abstract tape is very simple. To open it, select the tape in the peripheral devices
list in the Emulator panel. Then, click on the "Show" button.

![Abstract tape window (Input tape of the RAM machine)]({{ site.baseurl }}/assets/ram/ram-input.png)

The symbol, highlighted with the red color is the current head position, in this case. To manipulate with particular
symbols, one must click on the symbol, which appears _selected_ (blue background in this case), as in the following image:

![Selected symbol in the abstract tape]({{ site.baseurl }}/assets/ram/ram-input-selection.png)

{: .list}
| <span class="circle">1</span> | If the tape allows it, one can add a new symbol before the selected one in the tape. In the image, the tape does not allow it.
| <span class="circle">2</span> | The tape content area. Usually, each row consists of the symbol "index" or position within the tape, followed by the symbol itself.
| <span class="circle">3</span> | If the tape allows it, one can add a new symbol after the last one in the tape. In the image, the tape allows it.
| <span class="circle">4</span> | Removes the selected symbol from the tape.
| <span class="circle">5</span> | Edits the tape symbol. The symbol must be selected.
| <span class="circle">6</span> | Clears the tape content

## Settings

The tape allows us to edit some settings from the graphical mode; to open the settings window click on the "Settings"
button below the peripheral devices list in the Emulator panel. The window can be seen in the following image:

![Abstract tape settings]({{ site.baseurl }}/assets/ram/ram-input-settings.png)

{: .list}
| <span class="circle">1</span> | Do not allow the tape to fall behind another window
| <span class="circle">2</span> | Show the tape right after emuStudio start

## Configuration file

The following table shows all the possible settings of Abstract tape plugin:

|---
|Name | Default value | Valid values | Description
|-|-|-|-
|`showAtStartup`   | false | true, false | If the tape should be shown automatically after emuStudio is started
|`alwaysOnTop`     | false | true, false | Whether the tape GUI should not allow to fall behind other windows
|---

## Automatic emulation

The abstract tape supports automatic emulation. It means, that every change to it is being written to a file. The file
name is devised from the title of the tape, by the following algorithm:

- At first, all spaces in the title are replaced with an underscore (`_`)
- Then, all invalid characters are replaced with an underscore
- Every character is converted to lower-case
- Finally, the `.out` extension is added at the end.

Invalid characters are the following: `*`, `.`, `#`, `%`, `&`, `+`, `!`, `~`, `/`, `?`, `<`, `>`, `,`, `|`, `{`, `}`
, `[`, `]`, `"`, ```, `=`

## Using abstract tapes in your emulator

NOTE: This section is for developers of emulators.

The Abstract tape plugin can be used in various computers. Besides standard operations which are provided
by `net.emustudio.emulib.plugins.device.DeviceContext` interface, it provides custom context API.

Usually, the tapes are used by CPU plugins, but it is of course possible to use it in any other plugin. You can obtain
the context during the [Plugin.initialize()][pluginInitialize]{:target="_blank"} method of the plugin root class. The
context is named `net.emustudio.plugins.device.abstracttape.api.AbstractTapeContext`:

{:.code-example}
```java
@PluginRoot(...)
public class YourPlugin {

    ...

    public void initialize() throws PluginInitializationException {
        AbstractTapeContext tape = applicationApi.getContextPool().getDeviceContext(pluginID, AbstractTapeContext.class);
        ...
    }

    ...
}
```

The tape context interface has the following content:

{:.code-example}
```java
package net.emustudio.plugins.device.abstracttape.api;

import net.emustudio.emulib.plugins.annotations.PluginContext;
import net.emustudio.emulib.plugins.device.DeviceContext;

/**
 * Public API of the abstract tape.
 * <p>
 * The tape head can move to the left, or to the right. If a tape is left-bounded, it cannot move to the left
 * beyond the first symbol.
 * <p>
 * Symbols are indexed from 0.
 * A CPU must set up the tape (set the title, etc.).
 */
@ThreadSafe
@PluginContext
public interface AbstractTapeContext extends DeviceContext<TapeSymbol> {

    /**
     * Clear content of the tape.
     */
    void clear();

    /**
     * Accept only specific tape symbol types.
     * <p>
     * If the tape encounters symbol of unsupported type, it will throw on reading. Unsupported inputs provided by user
     * will be disallowed.
     *
     * @param types accepted types
     */
    void setAcceptTypes(TapeSymbol.Type... types);

    /**
     * Gets accepted tape symbol types.
     *
     * @return accepted tape symbol types
     */
    Set<TapeSymbol.Type> getAcceptedTypes();

    /**
     * Determine if the tape is left-bounded.
     *
     * @return true - left-bounded, false - unbounded.
     */
    boolean isLeftBounded();

    /**
     * Set this tape to left-bounded or unbounded.
     *
     * @param bounded true if the tape should be left-bounded,
     *                false if unbounded.
     */
    void setLeftBounded(boolean bounded);

    /**
     * Move the tape one symbol to the left.
     * <p>
     * If the tape is left-bounded and the old position is 0, tape won't move. Otherwise the tape
     * will expand to the left - add new empty symbol to position 0 and shift the rest of the content to the right.
     *
     * @return true if the tape has been moved; false otherwise (if it is left-bounded and the position is 0).
     */
    boolean moveLeft();

    /**
     * Move tape to the right. If the tape is too short, it is expanded to the right (added new empty symbol).
     */
    void moveRight();

    /**
     * Allow or disallow to edit the tape.
     * <p>
     * If the tape is editable, the user (in GUI) can add, modify or remove symbols from the tape.
     * Otherwise, it is driven only by the CPU.
     *
     * @param editable true if yes, false if not.
     */
    void setEditable(boolean editable);

    /**
     * Get symbol at index.
     *
     * @param index 0-based index; max value = Math.max(0, getSize() - 1)
     * @return symbol at index
     */
    Map.Entry<Integer, TapeSymbol> getSymbolAtIndex(int index);

    /**
     * Get symbol at the specified position.
     *
     * @param position position in the tape, starting from 0
     * @return symbol at given position; or Optional.empty() if the position is out of bounds
     */
    Optional<TapeSymbol> getSymbolAt(int position);

    /**
     * Set symbol at the specified position.
     *
     * @param position position in the tape, starting from 0
     * @param symbol   symbol value
     * @throws IllegalArgumentException if the symbol type is not among accepted ones, or position is < 0
     */
    void setSymbolAt(int position, TapeSymbol symbol);

    /**
     * Remove symbol at given position
     * Head position is preserved.
     *
     * @param position symbol position in the tape
     * @throws IllegalArgumentException if position < 0
     */
    void removeSymbolAt(int position);

    /**
     * Sets whether the symbol at which the head is pointing should be "highlighted" in GUI.
     *
     * @param highlight true if yes; false otherwise.
     */
    void setHighlightHeadPosition(boolean highlight);

    /**
     * Seths whether the tape should be cleared at emulation reset.
     *
     * @param clear true if yes; false otherwise.
     */
    void setClearAtReset(boolean clear);

    /**
     * Set title (purpose) of the tape.
     *
     * @param title title of the tape
     */
    void setTitle(String title);

    /**
     * Determines if the symbol positions should be displayed in GUI.
     *
     * @return true if yes; false otherwise
     */
    boolean getShowPositions();

    /**
     * Set whether the symbol positions should be displayed in GUI.
     *
     * @param showPositions true if yes; false otherwise.
     */
    void setShowPositions(boolean showPositions);

    /**
     * Get the tape head position.
     *
     * @return current position in the tape; starts from 0
     */
    int getHeadPosition();

    /**
     * Get the size of the tape
     *
     * @return tape size
     */
    int getSize();

    /**
     * Determine if the tape is empty.
     *
     * @return true if the tape is empty; false otherwise.
     */
    boolean isEmpty();

    /**
     * {@inheritDoc}
     *
     * @throws IllegalArgumentException if the symbol type is not among accepted ones
     */
    void writeData(TapeSymbol value);
```

[pluginInitialize]: /documentation/developer/emulib_javadoc/net/emustudio/emulib/plugins/Plugin.html#initialize()
