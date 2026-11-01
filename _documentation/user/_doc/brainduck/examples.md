---
layout: default
title: Example code
nav_order: 1
parent: BrainDuck
permalink: /brainduck/examples
---

{% include analytics.html category="BrainDuck" %}

# Example code

The installation includes examples in `examples/brainc-brainduck/`. Start with `hello1.b`, which prints a greeting
without requesting input. [First experiment]({{ site.baseurl }}/first-experiment) walks through compiling and running
it in the GUI.

To run the same example without windows, execute this command from the installation directory:

```
./emuStudio -cn "BrainDuck" -i examples/brainc-brainduck/hello1.b auto --no-gui --waitmax 5000
```

Read the greeting in `vt100-terminal.out`. This program needs no input file; a warning about a missing
`vt100-terminal.in` does not prevent it from finishing. See [automation]({{ site.baseurl }}/brainduck/automation)
for file redirection and input timing.

For more programs, see:

- [https://github.com/fabianishere/brainfuck/tree/master/examples](https://github.com/fabianishere/brainfuck/tree/master/examples){:target="_blank"}
- [http://www.hevanet.com/cristofd/brainfuck/](http://www.hevanet.com/cristofd/brainfuck/){:target="_blank"}
- [http://www.xappsoftware.com/wordpress/2011/03/19/brainfuck-sample-code/](http://www.xappsoftware.com/wordpress/2011/03/19/brainfuck-sample-code/){:target="_blank"}
