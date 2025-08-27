import QtQuick
import qs.Services

Flickable {
    id: flickey
    anchors.margins: 20
    clip: true

    // Enable horizontal scrolling for swipe functionality
    contentWidth: parent.width * row.children.length
    contentHeight: parent.height

    // Snap properties
    property int currentIndex: 0
    property real pageWidth: width
    property bool snapping: false

    // Change this line - use 'list' to allow multiple values
    property list<Component> items

    // Sync with tab selection
    onCurrentIndexChanged: {
        if (!snapping) {
            snapToPage(currentIndex);
        }
    }

    // Function to snap to a specific page
    function snapToPage(index) {
        snapping = true;
        contentX = index * pageWidth;
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
        if (!flickingHorizontally) {
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
        var position = contentX / pageWidth;

        // Quick swipe detection - change page with less distance if swiping fast
        if (Math.abs(horizontalVelocity) > velocityThreshold) {
            if (horizontalVelocity > 0 && currentPage < 2) {
                return currentPage + 1; // Swipe left (positive velocity) = next page
            } else if (horizontalVelocity < 0 && currentPage > 0) {
                return currentPage - 1; // Swipe right (negative velocity) = previous page
            }
        }

        // Normal threshold-based detection
        if (position > currentPage + threshold) {
            return Math.min(currentPage + 1, 2); // Move to next page
        } else if (position < currentPage - threshold) {
            return Math.max(currentPage - 1, 0); // Move to previous page
        } else {
            return currentPage; // Stay on current page
        }
    }

    // Enable smooth transitions
    Behavior on contentX {
        enabled: flickey.snapping
        NumberAnimation {
            duration: Settings.data.animation.duration
            easing.type: Easing.OutBack
        }
    }

    // Disable vertical scrolling
    boundsBehavior: Flickable.StopAtBounds
    flickableDirection: Flickable.HorizontalFlick

    Row {
        id: row
        anchors.fill: parent
        Repeater {
            model: flickey.items
            delegate: Item {
                width: flickey.pageWidth
                height: flickey.height

                Loader {
                    anchors.fill: parent
                    sourceComponent: modelData
                }
            }
        }
    }
}
