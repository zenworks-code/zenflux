import qs.Generics.Fixed
import Quickshell
import QtQuick
import QtQuick.Controls

FixedRect {
    width: parent.width - 32
    height: parent.height - 32
    anchors.margins: 16
    anchors.centerIn: parent

    color: "transparent"
    Flickable {
        id: flickey
        anchors.fill: parent
        clip: true

        // Enable horizontal scrolling for swipe functionality
        contentWidth: parent.width
        contentHeight: parent.height * 5
        onMovingChanged: {
            if (!moving) {
                // When moving becomes false
                tabbie.show = true;
                showTimer.restart();
            }
        }

        // Snap properties
        property int currentIndex: 0
        property real pageHeight: height
        property bool snapping: false

        // Sync with tab selection
        onCurrentIndexChanged: {
            if (!snapping) {
                snapToPage(currentIndex);
            }
        }

        // Function to snap to a specific page
        function snapToPage(index) {
            snapping = true;
            contentY = index * pageHeight;
            settingsTabs.currentIndex = index;
            snapping = false;
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

        Behavior on contentY {
            enabled: flickey.snapping
            NumberAnimation {
                duration: Settings.settings.animationDuration
                easing.type: Easing.OutBack
            }
        }

        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: collie
            anchors.fill: parent
            GridLayout {
                Layout.preferredWidth: flickey.width
                Layout.preferredHeight: flickey.height
                Layout.minimumWidth: flickey.width
                Layout.minimumHeight: flickey.height

                columns: 4
                columnSpacing: 16
                rowSpacing: 16

                BrightnessSlider {
                    Layout.rowSpan: 2
                    Layout.columnSpan: 1
                    monitor: Brightness.getMonitorForScreen(root.screen)
                }
                VolumeSlider {
                    Layout.rowSpan: 2
                    Layout.columnSpan: 1
                    monitor: Brightness.getMonitorForScreen(root.screen)
                }
                BatteryWidget {
                    Layout.columnSpan: 2  // Explicitly span 2 columns
                    monitor: Brightness.getMonitorForScreen(root.screen)
                    Layout.alignment: Qt.AlignTop
                }
                LockModule {
                    Layout.columnSpan: 1  // Prevent it from expanding
                }
                CoolClock {

                    Layout.columnSpan: 2  // Explicitly span 2 columns
                }
            }

            Item {
                width: flickey.width
                height: flickey.pageHeight
                StyledText {
                    text: "Page 2"
                    anchors.centerIn: parent
                    font.pixelSize: 24
                }
            }

            Item {
                width: flickey.width
                height: flickey.pageHeight
                StyledText {
                    text: "Page 3"
                    anchors.centerIn: parent
                    font.pixelSize: 24
                }
            }
            Item {
                width: flickey.width
                height: flickey.pageHeight
                NotchWifi {}
            }
        }
    }
}
