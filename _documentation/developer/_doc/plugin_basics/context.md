---
layout: default
title: Plugin contexts
nav_order: 2
parent: Plugin basics
permalink: /plugin_basics/context
---

{% include analytics.html category="developer" %}

# Plugin contexts

Plugins communicate through contexts rather than plugin root classes. Register context objects in the shared
[ContextPool][contextPool]{:target="_blank"} during plugin [instantiation][instantiation] (in the constructor).
Obtain connected plugins' contexts during [initialization][initialization], then call their Java methods.

[ContextPool][contextPool]{:target="_blank"} is not thread-safe, so all operations on it should be performed in the same
thread which called method [Plugin.initialize()][pluginInitialize]{:target="_blank"}.

A context is a plain Java interface extending [Context][context]{:target="_blank"}; no annotation is needed.
There are prepared some standard context interfaces in the API
([MemoryContext][memoryContext]{:target="_blank"}, [CPUContext][cpuContext]{:target="_blank"}
and [DeviceContext][deviceContext]{:target="_blank"}), and those can be used when implementing plugin context class - or
they can be further extended to provide customized versions of contexts.

Registration pairs a context interface with an object that implements it. A plugin can register any number of contexts,
and the same object can be registered under different interfaces. Multiple distinct objects can share an interface;
their indices follow registration order, across all plugins registered under that interface. A connection permits
lookup; it does not change those indices or renumber contexts that the caller cannot access.

Lookup uses the exact registered Java interface class. Share that interface between plugins;
redeclaring identical methods does not make two interfaces interchangeable. Register each
supported interface explicitly, including base interfaces and empty subinterfaces.

`register` throws `IllegalArgumentException` if the class is not an interface or the object does not implement it,
and `IllegalStateException` if the context is already registered. Both are unchecked: they signal programming errors.
`unregister(pluginID, interface)` removes all of the plugin's contexts registered under the interface.

Sample custom context might be created like this:

{:.code-example}
```java
public interface SampleContext extends CPUContext {

    // custom methods...
}
```

And the context class might look as follows:

{:.code-example}
```java
public class SampleContextImpl implements SampleContext {

    // implementation ...
}
``` 

Registration of this context might look as follows:

{:.code-example}
```java
@PluginRoot(type = PLUGIN_TYPE.CPU, title = "Sample CPU emulator")
public class SamplePlugin extends AbstractCPU {

    public SamplePlugin(long pluginID, ApplicationApi emustudio, PluginSettings settings) {
        super(pluginID, emustudio, settings);
        ContextPool contextPool = emustudio.getContextPool();

        SampleContext context = new SampleContextImpl();

        // We will register the same context two times, but by different context interfaces
        contextPool.register(pluginID, context, CPUContext.class);
        contextPool.register(pluginID, context, SampleContext.class);
    }

    ...
}
```

If another plugin wants to obtain the context, it should do it in the 
[Plugin.initialize()][pluginInitialize]{:target="_blank"} method:

{:.code-example}
```java
@PluginRoot(type = PLUGIN_TYPE.DEVICE, title = "Sample device")
public class SampleDevice extends AbstractPlugin implements Device {

    ...

    @Override
    public void initialize() throws PluginInitializationException {
        ContextPool contextPool = applicationApi.getContextPool();

        // This device requires the contexts; initialization failures propagate
        SampleContext cpuContext = contextPool.get(pluginID, SampleContext.class);
        MemoryContext<Byte> memory = contextPool.getMemory(pluginID, Byte.class);

        ...
    }

    ...
}
```

`get(pluginID, interface)` returns the first accessible context; `get(pluginID, interface, index)` selects one by index.
`getMemory(pluginID, cellType)` and `getDevice(pluginID, dataType)` look up a `MemoryContext` or `DeviceContext` and
also check its cell or data type, so the result is correctly typed. Memory and device plugins should therefore register
their contexts under `MemoryContext` or `DeviceContext` as well as any custom interface.

Lookup throws `ContextNotFoundException` if the context is unavailable, has an unexpected type, or the plugins are not
connected. The exception extends `PluginInitializationException`, so let initialization fail when the context is
required. For an optional context, catch the exception and disable the corresponding functionality.

[instantiation]: {{ site.baseurl }}/plugin_basics/loading#plugin-instantiation
[initialization]: {{ site.baseurl }}/plugin_basics/loading#plugin-initialization
[contextPool]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/runtime/ContextPool.html
[pluginInitialize]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/Plugin.html#initialize()
[context]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/Context.html
[deviceContext]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/device/DeviceContext.html
[cpuContext]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/CPUContext.html
[memoryContext]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/memory/MemoryContext.html
