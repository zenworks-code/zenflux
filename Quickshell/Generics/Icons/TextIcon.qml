import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Services

Text {
    id: iconText

    text: ""
    font.family: "tabler-icons"
    font.pixelSize: 24
    color: (Settings.settings.darkMode ? Theme.textPrimary : Theme.backgroundPrimary)
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    Behavior on color {
        ColorAnimation {
            duration: Settings.settings.animationDuration
            easing.type: Easing.OutBack
            easing.overshoot: 1.1
        }
    }
}
