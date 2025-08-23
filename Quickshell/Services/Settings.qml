pragma Singleton
import qs.Utils
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: settingsSingleton

    property alias options: options
    property string shellName: "zenflux"

    FileView {
        id: optionView
        path: Paths.settingsFile
        watchChanges: true

        Component.onCompleted: function () {
            reload();
        }
        onAdapterChanged: writeAdapter()
        onFileChanged: reload()
        onLoadFailed: function (error) {
            if (error.toString().includes("No such file") || error === 2)
                ;
        }

        onLoaded: function () {
            Qt.callLater(function () {
                writeAdapter();
            });
        }

        JsonAdapter {
            id: options

            property JsonObject animations: JsonObject {

                property int duration: 300
                property real overshoot: 1.1
                property real transitionDuration: 1.1
            }

            property JsonObject enable: JsonObject {
                property bool appLauncher: false
                property bool background: true
                property bool backgroundSwitcher: false
                property bool calculator: false
                property bool cheatsheet: false
                property bool lock: false
                property bool menu: false
                property bool notch: true
                property bool expandContent: false
                property bool enableDark: false
                property bool enableRadius: false
            }

            property JsonObject general: JsonObject {
                property string defaultLocation: location[0]
                property string fontFamily: "Figtree"
                property real fontSizeMultiplier: 1.0
                property var location: ["left", "bottom", "top", "right"]
                property bool reverseDayMonth: false
                property bool use12HourClock: false
                property bool useFahrenheit: false
                property string weatherCity: "Rome"
                property string position: "left"
                property bool quickViewExpanded: false
            }

            property JsonObject wallpaper: JsonObject {
                property string path: ""
                property string dir: Paths.wallpaperDir
            }
        }
    }
}
