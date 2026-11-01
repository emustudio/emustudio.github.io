---
layout: default
title: Writing a device
nav_order: 7
permalink: /device/
---

{% include analytics.html category="developer_device" %}

# Writing a device

A device plugin root implements [Device][device]{:target="_blank"}, usually by extending
[AbstractDevice][abstractDevice]{:target="_blank"}.

A device in emuStudio has three components:

- a device "engine" (device functionality)
- optional main GUI window
- optional settings GUI window

Devices communicate through contexts. Register any provided contexts in the plugin root's constructor. Device contexts
implement [DeviceContext][deviceContext]{:target="_blank"} or a derived interface.

The following partial example shows context registration and window creation. A complete device also implements
`getDescription()`, `isGuiSupported()` and `destroy()`. Honor `PluginSettings.EMUSTUDIO_NO_GUI` before creating windows,
and dispose windows and close device resources during destruction:

{:.code-example}
```java

@PluginRoot(
        type = PLUGIN_TYPE.DEVICE,
        title = "Sample device"
)
public class DeviceImpl extends AbstractDevice {
    private final DeviceContext deviceEngine = new DeviceEngine();

    private MainWindow mainWindow;
    private SettingsWindow settingsWindow;

    public DeviceImpl(long pluginID, ApplicationApi applicationApi, PluginSettings settings) {
        super(pluginID, applicationApi, settings);

        try {
            applicationApi.getContextPool().register(pluginID, deviceEngine, DeviceContext.class);
        } catch (InvalidContextException | ContextAlreadyRegisteredException e) {
            applicationApi.getDialogs().showError(
                    "Could not register Sample Device.", getTitle()
            );
        }
    }

    @Override
    public void showGUI(JFrame parent) {
        if (mainWindow == null) {
            mainWindow = new MainWindow(parent);
        }
        mainWindow.setVisible(true);
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
[abstractDevice]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/device/AbstractDevice.html
