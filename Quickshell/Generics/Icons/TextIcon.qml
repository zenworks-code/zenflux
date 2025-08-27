import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Services
import qs.Utils.Themes

Text {
    id: iconText

    text: ""
    font.family: "tabler-icons"
    font.pixelSize: 24
    color: (Settings.data.colorSchemes.darkMode ? Theme.textPrimary : Theme.backgroundPrimary)
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    Behavior on color {
        ColorAnimation {
            duration: Settings.data.animation.duration
            easing.type: Easing.OutBack
            easing.overshoot: 1.1
        }
    }
}
