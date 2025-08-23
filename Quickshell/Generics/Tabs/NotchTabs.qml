import QtQuick
import QtQuick.Layouts
import qs.Settings
import qs.Components.Icons

Item {
    id: root
    property var tabsModel: []
    property int currentIndex: 0
    signal tabChanged(int index)
    ColumnLayout {
        id: tabBar
        anchors.verticalCenter: parent.verticalCenter
        spacing: 48

        Repeater {
            id: repetah
            model: root.tabsModel
            delegate: Rectangle {
                id: tabWrapper
                implicitHeight: tab.height
                implicitWidth: 56
                color: "transparent"

                property bool hovered: false

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (currentIndex !== index) {
                            currentIndex = index;
                            tabChanged(index);
                        }
                    }
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false
                }

                ColumnLayout {
                    id: tab
                    spacing: 2
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    // Icon
                    TextIcon {
                        text: modelData.icon
                        opacity: index === root.currentIndex ? 1 : tabWrapper.hovered ? 1 : 0.5
                        Layout.alignment: Qt.AlignCenter
                        x: index === root.currentIndex ? -20 : index === root.currentIndex - 1 ? -10 : index === root.currentIndex + 1 ? -10 : 0

                        Behavior on x {
                            XAnimator {
                                duration: Settings.settings.animationDuration
                                easing.overshoot: 0.1
                                easing.type: Easing.OutBack
                            }
                        }
                        Behavior on color {
                            ColorAnimation {
                                duration: Settings.settings.animationDuration
                                easing.overshoot: 0.1
                                easing.type: Easing.OutBack
                            }
                        }
                        Behavior on opacity {
                            OpacityAnimator {
                                duration: Settings.settings.animationDuration
                                easing.overshoot: 0.1
                                easing.type: Easing.OutBack
                            }
                        }
                    }
                }
            }
        }
    }
}
