---
layout: default
title: Utility classes
nav_order: 3
parent: Plugin basics
permalink: /plugin_basics/utility_classes
---

{% include analytics.html category="developer" %}

# Utility classes

emuLib offers a lot of utility classes which can be helpful to emuStudio plugin developers. This page brings some overview
of some of them. Please refer to [emuLib javadoc][emulib]{:target="_blank"} for more detailed information.

## Intel HEX file generator

Class name
: [net.emustudio.emulib.runtime.io.IntelHEX][emulib_intelhex]{:target="_blank"}

Usage
: Generates binary output in ASCII form in famous [Intel HEX format][intelhex]{:target="_blank"}. Usually it is useful 
when writing compiler plugin. 

Upon code generation, the binary code is "added" to the IntelHEX object instance and then either a file is generated,
or the content could be loaded into memory:

```java
byte[] program = ...;  // program doesn't necessarily be in this form, especially if program is spread non-continuously

IntelHEX hex = new IntelHEX();
for (byte b : program) {
    hex.add(b);
} 

hex.generate("output-file.bin");

// alternative:
// hex.generate(writer);
        
// Loads content into memory
// the function `b->b` is a conversion of bytes to the memory cell type. Here it is assumed memory has Byte cells
hex.loadIntoMemory(memory, b -> b);
```

## Bits utilities

Class name
: [net.emustudio.emulib.runtime.helpers.Bits][emulib_bits]{:target="_blank"}

Usage
: Wraps `int` number and allows various bit-like operations on it (`int` has 4 bytes)

Few useful operations:

- `Bits absolute()`: Make the absolute value from the number stored in two's complement.
- `Bits reverseBits()`: Reverses bits in each byte (max 4 bytes).
- `Bits reverseBytes()`: Reverses the bytes.
- `Bits shiftLeft()`: Shift the value to the left.
- `Bits shiftRight()`: Shift the value to the right.
- `byte[] toBytes()`: Converts wrapped `int` into array of 4 bytes

This class is heavily used by [edigen][edigen]{:target="_blank"} dissasembler generator.

## Number utilities

Class name
: [net.emustudio.emulib.runtime.helpers][emulib_numberutils]{:target="_blank"}

Usage
: Lot of useful conversions between various number types.

Few useful operations:

- `static int bcd2bin(int bcd)`: Converts packed BCD code (1 byte, 2 BCD digits) to binary It is assumed the BCD has little endian.
- `static int bin2bcd(int bin)`: Converts a binary number into packed BCD (1 byte, 2 BCD digits)
- `static int[]	listToNativeInts(java.util.List<java.lang.Integer> list)`: Converts list of Integers into array of native ints.
- `static java.lang.Byte[] nativeBytesToBytes(byte[] array)`: Converts native `byte[]` array to boxed `Byte[]` array.
- `static java.lang.Integer[] nativeBytesToIntegers(byte[] array)`: Converts native `byte[]` array to boxed `Integer[]` array.
- ...
- `static int readBits(byte[] bytes, int start, int length, int bytesStrategy)`: Reads an arbitrary number of bits from bytes.
- `static int readInt(byte[] word, int strategy)`: Reads an integer from the array of numbers.
- ...
- `static int reverseBits(int value, int numberOfBits)`: Reverse bits in integer (max 32-bit) value.
- ...
- `static void writeInt(int value, byte[] output, int strategy)`: Split the value into 4 bytes.
- ...

## Radix utilities

Class name
: [net.emustudio.emulib.runtime.helpers.RadixUtils][emulib_radixutils]{:target="_blank"}

Usage
: Utility functions for various radix conversions. 

At first, an instance of `RadixUtils` must be created, because of some pattern regex pre-compilation and possibility
to add new radixes dynamically. Usually, a singleton instance is used throughout the application (it's not thread-safe!). 

Few useful operations:

- `void addNumberPattern(RadixUtils.NumberPattern pattern)`: Add `NumberPattern` for new radix recognition
- `static byte[] convertToNumber(java.lang.String number, int fromRadix)`: Convert an integer number in any radix (stored in String) to binary components (bytes) in little endian.
- ...
- `static java.lang.String convertToRadix(byte[] number, int toRadix, boolean littleEndian)`: Converts number in any length to a number with specified radix.
- ...
- `static java.lang.String formatBinaryString(int number, int length)`: Get formatted binary string of given number.
- ...
- `static RadixUtils getInstance()`: returns a singleton instance 
- `int parseRadix(java.lang.String number)`: Parses a number in known radix into integer.
- ...

## Sleep utilities

Class name
: [net.emustudio.emulib.runtime.helpers.SleepUtils][emulib_sleeputils]{:target="_blank"}

Usage
: Provides a function for accurate sleeping of the active thread in all host platforms (Windows, Linux).

The function `SleepUtils.preciseSleepNanos` is more precise than `LockSupport::sleepNanos`.


## Timed event processing

Class name
: [net.emustudio.emulib.plugins.cpu.TimedEventsProcessor][emulib_timedeventprocessor]{:target="_blank"}

Usage
: soft real-time system based on a logical system clock, interpreted as number of passed CPU cycles. Events 
are scheduled to be run every given cycles.

This class is asynchronous, and thread safe event queue based on logical time. It means time is not advanced regularly,
but it is advanced on external calls of `TimedEventsProcessor.advanceClock()` method, and by given number of "CPU cycles". 

Events are scheduled to be executed every given "cycles" regularly. When the clock is advanced enough to pass over
scheduled time of some events, those events are triggered. 

This class is part of `plugins.cpu` package, because advancing system clock is performed by CPU if the instance is
obtained through `CPUContext.getTimedEventsProcessor()` method. Thus, it is part of CPU public API.
It is still possible to use this class independently too, but then use must make new instance and make sure of advancing
the clock for events to be triggered.

Timed event processing can be used for accurate emulation of multiple devices which speed or actions depend on the number
of executed CPU cycles.


[emulib]: {{ site.baseurl }}/emulib_javadoc/
[emulib_intelhex]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/runtime/io/IntelHEX.html
[intelhex]: https://en.wikipedia.org/wiki/Intel_HEX

[emulib_bits]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/runtime/helpers/Bits.html
[edigen]: https://github.com/emustudio/edigen

[emulib_numberutils]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/runtime/helpers/NumberUtils.html
[emulib_radixutils]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/runtime/helpers/RadixUtils.html

[emulib_sleeputils]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/runtime/helpers/SleepUtils.html
[emulib_timedeventprocessor]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/TimedEventsProcessor.html
