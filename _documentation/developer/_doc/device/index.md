---
layout: default
title: Writing a device
nav_order: 7
permalink: /device/
---

{% include analytics.html category="developer_device" %}

# Writing a device

A device plugin root usually extends [AbstractPlugin][abstractPlugin]{:target="_blank"} and implements
[Device][device]{:target="_blank"}.

A device in emuStudio has three components:

- a device "engine" (device functionality)
- optional main GUI window
- optional settings GUI window

Devices communicate through contexts. Register any provided contexts in the plugin root's constructor. Device contexts
implement [DeviceContext][deviceContext]{:target="_blank"} or a derived interface.

The following partial example shows context registration and window creation. `showGUI()` is a no-op and
`isGuiSupported()` returns `false` by default; a device with a main window overrides both. A complete device also
overrides `destroy()`. Honor `PluginSettings.EMUSTUDIO_NO_GUI` before creating windows, and dispose windows and close
device resources during destruction:

{:.code-example}
```java

@PluginRoot(
        type = PLUGIN_TYPE.DEVICE,
        title = "Sample device",
        description = "A sample device"
)
public class DeviceImpl extends AbstractPlugin implements Device {
    private final DeviceContext<Byte> deviceEngine = new DeviceEngine();

    private MainWindow mainWindow;
    private SettingsWindow settingsWindow;

    public DeviceImpl(long pluginID, ApplicationApi applicationApi, PluginSettings settings) {
        super(pluginID, applicationApi, settings);
        applicationApi.getContextPool().register(pluginID, deviceEngine, DeviceContext.class);
    }

    @Override
    public void showGUI(JFrame parent) {
        if (mainWindow == null) {
            mainWindow = new MainWindow(parent);
        }
        mainWindow.setVisible(true);
    }

    @Override
    public boolean isGuiSupported() {
        return true;
    }

    @Override
    public void showSettings(JFrame parent) {
        if (settingsWindow == null) {
            settingsWindow = new SettingsWindow(parent);
        }
        settingsWindow.setVisible(true);
    }

    @Override
    public boolean isShowSettingsSupported() {
        return true;
    }
}
```

## Audio and recording resources

Use emuLib's `runtime.audio.AudioSink` for generated PCM and `SamplePlayer<K>` for WAV effects. Use
`runtime.recording.RecordingSession` to encode video with stereo audio. The
[utility guide]({{ site.baseurl }}/plugin_basics/utility_classes#audio-playback) describes formats, queues, and lifecycle.

The device owns hardware timing, synthesis or sample selection, volume, controls, and file dialogs. Keep playback and
encoding off the CPU thread. Use `AudioSink.NULL` for a silent headless device; decide during initialization how to handle
an unavailable host audio device. Flush pending audio on reset, remove CPU cycle listeners on destruction, and close
playback and recording resources. Saving a recording must run outside Swing's event-dispatch thread.

[device]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/device/Device.html
[deviceContext]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/device/DeviceContext.html
[abstractPlugin]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/AbstractPlugin.html
