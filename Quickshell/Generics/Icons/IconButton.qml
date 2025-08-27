import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Services
import qs.Utils.Themes

MouseArea {
    id: root
    property string icon
    property bool enabled: true
    property bool hovering: false
    property real size: 32
    cursorShape: Qt.PointingHandCursor
    implicitWidth: size
    implicitHeight: size

    hoverEnabled: true
    onEntered: hovering = true
    onExited: hovering = false

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: root.hovering ? Theme.accentPrimary : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: Settings.data.animation.duration
                easing.type: Easing.OutBack
                easing.overshoot: Settings.data.animation.overshoot
            }
        }
    }
    Text {
        id: iconText
        anchors.centerIn: parent
        text: root.icon
        font.family: "tabler-icons"
        font.pixelSize: 24
        color: root.hovering ? (Theme.onAccent) : (Settings.data.colorSchemes.darkMode ? Theme.textPrimary : Theme.backgroundPrimary)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        opacity: root.enabled ? 1.0 : 0.5
        Behavior on color {
            ColorAnimation {
                duration: Settings.data.animation.duration
                easing.type: Easing.OutBack
                easing.overshoot: 1.1
            }
        }
    }
}
