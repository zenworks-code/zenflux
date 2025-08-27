import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.Services
import qs.Utils

Variants {
    model: Quickshell.screens

    delegate: Component {
        PanelWindow {
            id: root

            required property var modelData

            WlrLayershell.layer: WlrLayer.Background
            aboveWindows: false
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore

            // we can then set the window's screen to the injected property
            screen: modelData

            CachingImages {
                id: img

                height: parent.height
                path: Paths.wallpaperDir + "/macintosh.jpg"
                width: parent.width
            }

            anchors {
                bottom: true
                left: true
                right: true
                top: true
            }
        }
    }
}
