pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Utils

Singleton {
    id: root

    property string shellName: "zenflux"

    // Used to access via Settings.data.xxx.yyy
    property alias data: adapter

    // Flag to prevent unnecessary wallpaper calls during reloads
    property bool isInitialLoad: true

    // Function to validate monitor configurations
    function validateMonitorConfigurations() {
        var availableScreenNames = [];
        for (var i = 0; i < Quickshell.screens.length; i++) {
            availableScreenNames.push(Quickshell.screens[i].name);
        }
        Logger.log("Settings", "Available monitors: [" + availableScreenNames.join(", ") + "]");
        Logger.log("Settings", "Configured bar monitors: [" + adapter.bar.monitors.join(", ") + "]");
    }

    FileView {
        path: Paths.settingsFile
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        Component.onCompleted: function () {
            reload();
        }
        onLoaded: function () {
            Qt.callLater(function () {
                if (isInitialLoad) {
                    Logger.log("Settings", "OnLoaded");
                    // Only set wallpaper on initial load, not on reloads
                    if (adapter.wallpaper.current !== "") {
                        Logger.log("Settings", "Set current wallpaper", adapter.wallpaper.current);
                        WallpaperService.setCurrentWallpaper(adapter.wallpaper.current, true);
                    }

                    // Validate monitor configurations, only once
                    // if none of the configured monitors exist, clear the lists
                    validateMonitorConfigurations();
                }

                isInitialLoad = false;
            });
        }
        onLoadFailed: function (error) {
            if (error.toString().includes("No such file") || error === 2)
                // File doesn't exist, create it with default values
                writeAdapter();
        }

        JsonAdapter {
            id: adapter

            // general
            property JsonObject general: JsonObject {
                property string avatarImage: Paths.profileImage
                property bool dimDesktop: false
                property bool showRadius: false
                property real margin: 16
            }

            property JsonObject animation: JsonObject {
                property int duration: 300
                property string type: "OutBack"
                property double overshoot: 1.1
            }

            property JsonObject enable: JsonObject {
                property bool wallpaper: true
                property bool applauncher: false
                property bool wallpaperswitcher: false
                property bool lock: false
                property bool notch: false
                property bool calculator: false
                property bool menu: false
            }

            property JsonObject notch: JsonObject {

                property string position: "top" // Possible values: "top", "bottom", "left", "right"
                property real backgroundOpacity: 1.0
                property list<string> monitors: []
                property bool pages: false
                property bool content: false
            }

            // location
            property JsonObject location: JsonObject {
                property string name: "Tokyo"
                property bool useFahrenheit: false
                property bool reverseDayMonth: false
                property bool use12HourClock: false
                property bool showDateWithClock: false
            }

            // screen recorder
            property JsonObject screenRecorder: JsonObject {
                property string directory: Paths.videoPath
                property int frameRate: 90
                property string audioCodec: "opus"
                property string videoCodec: "h264"
                property string quality: "very_high"
                property string colorRange: "limited"
                property bool showCursor: true
                property string audioSource: "default_output"
                property string videoSource: "portal"
            }

            // wallpaper
            property JsonObject wallpaper: JsonObject {
                property string directory: "/home/zen/Wallpapers"
                property string path: ""
                property bool isRandom: true
                property int randomInterval: 300
                onDirectoryChanged: WallpaperService.listWallpapers()
                onIsRandomChanged: WallpaperService.toggleRandomWallpaper()
                onRandomIntervalChanged: WallpaperService.restartRandomWallpaperTimer()

                property JsonObject swww: JsonObject {
                    property bool enabled: false
                    property string resizeMethod: "crop"
                    property int transitionFps: 60
                    property string transitionType: "random"
                    property real transitionDuration: 1.1
                }
            }

            // applauncher
            property JsonObject appLauncher: JsonObject {
                // When disabled, Launcher hides clipboard command and ignores cliphist
                property bool enableClipboardHistory: true
                // Position: center, top_left, top_right, bottom_left, bottom_right
                property string position: "center"
                property list<string> pinnedExecs: []
            }

            // dock
            property JsonObject dock: JsonObject {
                property bool autoHide: false
                property bool exclusive: false
                property list<string> monitors: []
            }

            // network
            property JsonObject network: JsonObject {
                property bool wifiEnabled: true
                property bool bluetoothEnabled: true
            }

            // notifications
            property JsonObject notifications: JsonObject {
                property list<string> monitors: []
            }

            // audio
            property JsonObject audio: JsonObject {
                property bool showMiniplayerAlbumArt: false
                property bool showMiniplayerCava: false
                property string visualizerType: "linear"
                property int volumeStep: 5
                property int cavaFrameRate: 60
            }

            // ui
            property JsonObject ui: JsonObject {
                property string fontDefault: "Figtree" // Default font for all text
                property string fontFixed: "ZedMono Nerd Font" // Fixed width font for terminal

                // Legacy compatibility
                property string fontFamily: fontDefault // Keep for backward compatibility

                // Idle inhibitor state
                property bool idleInhibitorEnabled: false
            }

            // Scaling (not stored inside JsonObject, or it crashes)
            property var monitorsScaling: {}

            // brightness
            property JsonObject brightness: JsonObject {
                property int brightnessStep: 5
            }

            property JsonObject colorSchemes: JsonObject {
                property bool useWallpaperColors: false
                property string predefinedScheme: ""
                property bool darkMode: true
                property bool themeApps: false
            }
        }
    }
}
