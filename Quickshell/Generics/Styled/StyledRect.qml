import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Services
import qs.Utils.Themes

Rectangle {
    radius: Settings?.data?.general?.showRadius ? 50 : 0

    width: 100
    height: 100
    color: Settings?.data?.colorSchemes?.darkMode ? Theme?.backgroundPrimary : Theme?.textPrimary

    Behavior on radius {
        NumberAnimation {
            duration: Settings?.data?.animation?.duration
            easing.type: Easing.OutBack
            easing.overshoot: Settings?.data?.animation?.overshoot
        }
    }
    Behavior on color {
        ColorAnimation {
            duration: Settings?.data?.animation?.duration
            easing.type: Easing.OutBack
            easing.overshoot: Settings?.data?.animation?.overshoot
        }
    }
}
