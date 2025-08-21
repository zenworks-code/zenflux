pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property bool appleDisplayPresent: false
  property list<var> ddcMonitors: []
  readonly property list<Monitor> monitors: variants.instances

  function decreaseBrightness(): void {
    const focusedName = Hyprland.focusedMonitor.name;
    const monitor = monitors.find(m => focusedName === m.modelData.name);
    if (monitor)
      monitor.setBrightness(monitor.brightness - 0.1);
  }

  function getMonitorForScreen(screen: ShellScreen): var {
    return monitors.find(m => m.modelData === screen);
  }

  function increaseBrightness(): void {
    const focusedName = Hyprland.focusedMonitor.name;
    const monitor = monitors.find(m => focusedName === m.modelData.name);
    if (monitor)
      monitor.setBrightness(monitor.brightness + 0.1);
  }

  reloadableId: "brightness"

  onMonitorsChanged: {
    ddcMonitors = [];
    ddcProc.running = true;
  }

  Variants {
    id: variants

    model: Quickshell.screens

    Monitor {
    }
  }

  component Monitor: QtObject {
    id: monitor

    property real brightness
    readonly property string busNum: root.ddcMonitors.find(m => m.model === modelData.model)?.busNum ?? ""
    readonly property Process initProc: Process {
      stdout: StdioCollector {
        onStreamFinished: {
          if (monitor.isAppleDisplay) {
            const val = parseInt(text.trim());
            monitor.brightness = val / 101;
          } else {
            const [, , , cur, max] = text.split(" ");
            monitor.brightness = parseInt(cur) / parseInt(max);
          }
        }
      }
    }
    readonly property bool isAppleDisplay: root.appleDisplayPresent && modelData.model.startsWith("StudioDisplay")
    readonly property bool isDdc: root.ddcMonitors.some(m => m.model === modelData.model)
    required property ShellScreen modelData
    property real queuedBrightness: NaN
    readonly property Timer timer: Timer {
      interval: 500

      onTriggered: {
        if (!isNaN(monitor.queuedBrightness)) {
          monitor.setBrightness(monitor.queuedBrightness);
          monitor.queuedBrightness = NaN;
        }
      }
    }

    function initBrightness(): void {
      if (isAppleDisplay)
        initProc.command = ["asdbctl", "get"];
      else if (isDdc)
        initProc.command = ["ddcutil", "-b", busNum, "getvcp", "10", "--brief"];
      else
        initProc.command = ["sh", "-c", "echo a b c $(brightnessctl g) $(brightnessctl m)"];

      initProc.running = true;
    }

    function setBrightness(value: real): void {
      value = Math.max(0, Math.min(1, value));
      const rounded = Math.round(value * 100);
      if (Math.round(brightness * 100) === rounded)
        return;

      if (isDdc && timer.running) {
        queuedBrightness = value;
        return;
      }

      brightness = value;

      if (isAppleDisplay)
        Quickshell.execDetached(["asdbctl", "set", rounded]);
      else if (isDdc)
        Quickshell.execDetached(["ddcutil", "-b", busNum, "setvcp", "10", rounded]);
      else
        Quickshell.execDetached(["brightnessctl", "s", `${rounded}%`]);

      if (isDdc)
        timer.restart();
    }

    Component.onCompleted: initBrightness()
    onBusNumChanged: initBrightness()
  }
}
