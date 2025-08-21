import QtQuick
import QtQuick.Controls
import Quickshell
import qs.Settings

import QtQuick.Controls.Basic

Switch {
    id: control

    indicator: Rectangle {
        implicitWidth: 64
        implicitHeight: 28
        x: control.leftPadding
        radius: height / 2
        color: control.checked ? Theme.palette[3] : "#8E8E93"

        Rectangle {
            x: control.checked ? parent.width - 2 - width : 2
            width: 40
            height: 24
            radius: height / 2
            anchors.margins: 2
            anchors.verticalCenter: parent.verticalCenter
            color: "#ffffff"
            Behavior on x {
                NumberAnimation {
                    duration: Settings.settings.animationDuration
                    easing.type: Easing.OutBack
                }
            }
        }
    }
}
