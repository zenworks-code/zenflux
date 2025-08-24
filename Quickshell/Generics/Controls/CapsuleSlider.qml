import qs.Components
import qs.Services
import qs.Services
import QtQuick
import QtQuick.Effects
import QtQuick.Controls

import qs.Components.Icons
import qs.Components.Styled

Slider {
    id: root

    required property string icon
    required property string color
    required property real rotation
    property real oldValue
    function customRound(value) {
        if (value < 0.02)
            return 0;
        if (value > 0.99)
            return 1;
        return value;
    }
    orientation: Qt.Vertical
    background: StyledRect {
        anchors.fill: parent
        color: Settings.settings.darkMode ? Theme.backgroundPrimary.alpha(0.5) : Theme.textPrimary.alpha(0.5)
    }
    StyledRect {
        width: parent.width
        height: parent.height * root.customRound(root.oldValue)
        anchors.bottom: parent.bottom
        color: Settings.settings.darkMode ? Theme.backgroundTertiary : Theme.textPrimary
        radius: 0
        Behavior on height {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutBack
                easing.overshoot: 1.1
            }
        }
    }
    handle: Item {
        id: handle

        property bool moving
        z: 100
        y: root.visualPosition * (root.availableHeight - height)
        implicitWidth: root.width
        implicitHeight: root.width

        StyledClippingRect {
            id: rect

            color: "transparent"

            anchors.fill: parent

            radius: 0

            MouseArea {
                id: handleInteraction

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.NoButton
            }
        }
    }
    TextIcon {
        id: icon

        property bool moving: handle.moving

        font.pointSize: 20
        text: root.icon
        color: root.color
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: Settings.settings.globalMargin
        rotation: root.rotation
    }

    onPressedChanged: handle.moving = pressed

    onValueChanged: {
        if (Math.abs(value - oldValue) < 0.01)
            return;
        oldValue = value;
        handle.moving = true;
        stateChangeDelay.restart();
    }

    Timer {
        id: stateChangeDelay

        interval: 500
        onTriggered: {
            if (!root.pressed)
                handle.moving = false;
        }
    }
}
