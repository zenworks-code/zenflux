import Quickshell
import Quickshell.Io
import QtQuick
import qs.Generics.Panels
import qs.Generics.Styled

StyledRect {
    id: rect
    property bool expandContent: Settings.settings.expandContent
    property bool hasRadius: Settings.settings.hasRadius
    property bool isHovering: false
    property double radius: Settings.settings.radius

    color: Settings.settings.darkMode ? Theme.backgroundPrimary.alpha(0.85) : Theme.textPrimary.alpha(root.expandContent ? 0.5 : 1)
    height: root.expandContent ? parent.height / 2 : parent.height / 5.12
    width: root.expandContent ? 380 : 48
    Behavior on height {
        NumberAnimation {
            duration: Settings.settings.animationDuration
            easing.overshoot: 1.1
            easing.type: Easing.OutBack
        }
    }
    Behavior on opacity {
        OpacityAnimator {
            duration: Settings.settings.animationDuration
            easing.overshoot: 1.1
            easing.type: Easing.OutBack
        }
    }
    Behavior on width {
        NumberAnimation {
            duration: Settings.settings.animationDuration
            easing.overshoot: 1.1
            easing.type: Easing.OutBack
        }
    }

    anchors {
        margins: Settings.settings.globalMargin
        right: parent.right
        verticalCenter: parent.verticalCenter
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: root.expandContent = true
        onDoubleClicked: root.expandContent = false
    }

    Item {
        id: notchContent

        anchors.fill: parent
        opacity: root.expandContent ? 0 : 1
        scale: root.expandContent ? 0 : 1

        Behavior on opacity {
            SequentialAnimation {
                PauseAnimation {
                    duration: 150
                }

                OpacityAnimator {
                    duration: Settings.settings.animationDuration
                    easing.overshoot: 1.1
                    easing.type: Easing.OutBack
                }
            }
        }
        Behavior on scale {
            SequentialAnimation {
                PauseAnimation {
                    duration: 300
                }

                ScaleAnimator {
                    duration: Settings.settings.animationDuration
                    easing.overshoot: 1.1
                    easing.type: Easing.OutBack
                }
            }
        }

        StyledText {
            anchors.centerIn: parent
            rotation: 270
            text: `${Quickshell.env("USER")}@${hostnameCollector.text.trim()}`
        }

        Process {
            id: hostnameProcess

            command: ["hostname"]
            running: true

            stdout: StdioCollector {
                id: hostnameCollector

                waitForEnd: true
            }
        }
    }

    FixedRect {
        anchors.fill: parent
        color: "transparent"
        scale: root.expandContent ? 1 : 0

        Behavior on scale {
            SequentialAnimation {
                PauseAnimation {
                    duration: 200
                }

                ScaleAnimator {
                    duration: Settings.settings.animationDuration
                    easing.overshoot: 1.1
                    easing.type: Easing.OutBack
                }
            }
        }

        Item {
            id: tabbie

            property bool show: false

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            opacity: show ? 1 : 0
            z: 100

            Behavior on opacity {
                NumberAnimation {
                    duration: Settings.settings.animationDuration * 2
                    easing.overshoot: 1.1
                    easing.type: Easing.OutBack
                }
            }

            Timer {
                id: showTimer

                interval: 2000
                running: false

                onTriggered: tabbie.show = false
            }

            NotchTabs {
                id: settingsTabs

                anchors.right: parent.right
                anchors.rightMargin: Settings.settings.globalMargin * 2
                tabsModel: [
                    {
                        icon: "\uf69e"
                    },
                    {
                        icon: "\ufb27"
                    },
                    {
                        icon: "\uf673"
                    },
                    {
                        icon: "\ufe1b"
                    }
                ]

                // Update tab when flickable moves
                onCurrentIndexChanged: {
                    flickey.currentIndex = currentIndex;
                }
            }
        }

        FixedRect {
            anchors.centerIn: parent
            anchors.margins: 16
            color: "transparent"
            height: parent.height - 32
            width: parent.width - 32

            Flickable {
                id: flickey

                // Snap properties
                property int currentIndex: 0
                property real pageHeight: height
                property bool snapping: false

                // Calculate target index with custom threshold
                function calculateTargetIndex() {
                    var threshold = 0.05; // Only need to swipe 5% of page width to change
                    var velocityThreshold = 100; // Minimum velocity for quick swipe
                    var currentPage = currentIndex;
                    var position = contentY / pageHeight;

                    // Quick swipe detection - change page with less distance if swiping fast
                    if (Math.abs(verticalVelocity) > velocityThreshold) {
                        if (verticalVelocity > 0 && currentPage < collie.children.length) {
                            return currentPage + 1; // Swipe left (positive velocity) = next page
                        } else if (verticalVelocity < 0 && currentPage > 0) {
                            return currentPage - 1; // Swipe right (negative velocity) = previous page
                        }
                    }

                    // Normal threshold-based detection
                    if (position > currentPage + threshold) {
                        return Math.min(currentPage + 1, collie.children.length); // Move to next page

                    } else if (position < currentPage - threshold) {
                        return Math.max(currentPage - 1, 0); // Move to previous page
                    } else {
                        return currentPage; // Stay on current page
                    }
                }

                // Function to snap to a specific page
                function snapToPage(index) {
                    snapping = true;
                    contentY = index * pageHeight;
                    settingsTabs.currentIndex = index;
                    snapping = false;
                }

                anchors.fill: parent
                boundsBehavior: Flickable.StopAtBounds
                clip: true
                contentHeight: parent.height * 5

                // Enable horizontal scrolling for swipe functionality
                contentWidth: parent.width
                flickableDirection: Flickable.VerticalFlick

                Behavior on contentY {
                    enabled: flickey.snapping

                    NumberAnimation {
                        duration: Settings.settings.animationDuration
                        easing.type: Easing.OutBack
                    }
                }

                // Sync with tab selection
                onCurrentIndexChanged: {
                    if (!snapping) {
                        snapToPage(currentIndex);
                    }
                }

                // Handle snapping when flicking stops
                onFlickEnded: {
                    var targetIndex = calculateTargetIndex();

                    if (targetIndex !== currentIndex) {
                        currentIndex = targetIndex;
                        snapToPage(targetIndex);
                    }
                }

                // Handle snapping when dragging stops (without flicking)
                onMovementEnded: {
                    if (!flickingVertically) {
                        var targetIndex = calculateTargetIndex();

                        if (targetIndex !== currentIndex) {
                            currentIndex = targetIndex;
                        }
                        snapToPage(targetIndex);
                    }
                }
                onMovingChanged: {
                    if (!moving) {
                        // When moving becomes false
                        tabbie.show = true;
                        showTimer.restart();
                    }
                }

                Column {
                    id: collie

                    anchors.fill: parent

                    Item {
                        height: flickey.pageHeight
                        width: flickey.width

                        GridLayout {
                            Layout.minimumHeight: parent.width
                            Layout.minimumWidth: parent.width
                            columnSpacing: 16
                            columns: 4
                            rowSpacing: 16

                            BrightnessSlider {
                                Layout.columnSpan: 1
                                Layout.rowSpan: 2
                                monitor: Brightness.getMonitorForScreen(root.screen)
                            }

                            VolumeSlider {
                                Layout.columnSpan: 1
                                Layout.rowSpan: 2
                                monitor: Brightness.getMonitorForScreen(root.screen)
                            }

                            BatteryWidget {
                                Layout.alignment: Qt.AlignTop
                                Layout.columnSpan: 2  // Explicitly span 2 columns
                                monitor: Brightness.getMonitorForScreen(root.screen)
                            }

                            LockModule {
                                Layout.columnSpan: 1  // Prevent it from expanding
                            }

                            CoolClock {
                                Layout.columnSpan: 2  // Explicitly span 2 columns
                            }
                        }
                    }

                    Item {
                        height: flickey.pageHeight
                        width: flickey.width

                        Content1 {}
                    }
                }
            }
        }
    }
}
