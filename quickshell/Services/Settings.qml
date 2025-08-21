pragma Singleton
import qs.Utils
import Quickshell
import Quickshell.Io

Singleton {
    id: settingsSingleton

    property alias settings: settingAdapter
    property string shellName: "zenflux"

    FileView {
        path: Paths.settingsFile
        watchChanges: true
        onAdapterUpdated: writeAdapter()
        onFileChanged: reload()
        onLoadFailed: function (error) {
            writeAdapter();
        }
        onLoaded: function () {
            writeAdapter();
        }

        JsonAdapter {
            id: settingAdapter

            property JsonObject animations: JsonObject {
                property int duration: 300
                property real overshoot: 1.1
                property real transitionDuration: 1.1
            }
            property JsonObject content: JsonObject {
                property bool enableAppLauncher: false
                property bool enableBackground: true
                property bool enableBackgroundSwitcher: false
                property bool enableCalculator: false
                property bool enableCheatsheet: false
                property bool enableLock: false
                property bool enableMenu: false
                property bool enableNotch: true
                property bool expandContent: false
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
            }
            property JsonObject notch: JsonObject {
                property bool expandContent: false
                property bool overViewExpanded: false
                property bool pagesExpanded: false
                property string position: "left"
                property bool quickViewExpanded: false
            }
            property JsonObject theme: JsonObject {
                property bool enableDark: false
                property bool enableRadius: false
            }
            property JsonObject wallpaper: JsonObject {
                property string currentWallpaper: ""
                property string wallpaperFolder: Paths.wallpaperDir
            }
        }
    }
}
