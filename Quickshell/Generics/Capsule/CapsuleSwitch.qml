import QtQuick
import QtQuick.Controls
import Quickshell
import qs.Services
import qs.Utils.Themes
import QtQuick.Controls.Basic

Switch {
    id: control

    // Expose a friendly alias, still the same 'checked' underneath
    property alias option: control.checked
    signal switched(bool checked)
    onCheckedChanged: switched(checked)

    indicator: Rectangle {
        implicitWidth: 64
        implicitHeight: 28
        x: control.leftPadding
        radius: Settings.data.general.showRadius ? height / 2 : 0
        color: control.checked && Theme ? Theme.palette[3] : "#8E8E93"
        Behavior on color {
            ColorAnimation {
                duration: Settings.data.animation.duration || 200
                easing.type: Easing.OutBack
                easing.overshoot: 1.1
            }
        }

        Behavior on radius {
            NumberAnimation {
                duration: Settings?.data?.animation?.duration
                easing.type: Easing.OutBack
                easing.overshoot: Settings?.data?.animation?.overshoot
            }
        }
        Rectangle {
            id: thumb
            width: 40
            height: 24
            radius: Settings.data.general.showRadius ? height / 2 : 0
            anchors.margins: 2
            anchors.verticalCenter: parent.verticalCenter
            color: "#ffffff"
            x: control.checked ? parent.width - 2 - width : 2
            Behavior on x {
                NumberAnimation {
                    duration: Settings.data.animation.duration
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.1
                }
            }

            Behavior on radius {
                NumberAnimation {
                    duration: Settings?.data?.animation?.duration
                    easing.type: Easing.OutBack
                    easing.overshoot: Settings?.data?.animation?.overshoot
                }
            }
        }
    }
}
