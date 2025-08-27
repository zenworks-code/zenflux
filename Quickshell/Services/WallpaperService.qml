pragma Singleton

import QtQuick
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io
import qs.Utils

Singleton {
    id: root

    Component.onCompleted: {
        Logger.log("Wallpapers", "Service started");
        listWallpapers();
    }

    property var wallpaperList: []
    property string currentWallpaper: Settings.data.wallpaper.path
    property bool scanning: false

    function listWallpapers() {
        Logger.log("Wallpapers", "Listing wallpapers");
        scanning = true;
        wallpaperList = [];
        // Unsetting, then setting the folder will re-trigger the parsing!
        folderModel.folder = "";
        folderModel.folder = "file://" + (Settings.data.wallpaper.directory !== undefined ? Settings.data.wallpaper.directory : "");
    }

    function changeWallpaper(path) {
        Logger.log("Wallpapers", "Changing to:", path);
        setCurrentWallpaper(path, false);
    }

    function setCurrentWallpaper(path, isInitial) {
        // Only regenerate colors if the wallpaper actually changed
        var wallpaperChanged = currentWallpaper !== path;

        changeWallpaperProcess.running = true;
        currentWallpaper = path;
        Settings.data.wallpaper.path = path;
        if (Settings.data.wallpaper.swww.enabled) {
            if (Settings.data.wallpaper.swww.transitionType === "random") {
                transitionType = randomChoices[Math.floor(Math.random() * randomChoices.length)];
            } else {
                transitionType = Settings.data.wallpaper.swww.transitionType;
            }
        } else

        // Fallback: update the settings directly for non-SWWW mode
        //Logger.log("Wallpapers", "Not using Swww, setting wallpaper directly");
        {}

        if (randomWallpaperTimer.running) {
            randomWallpaperTimer.restart();
        }
    }

    function setRandomWallpaper() {
        var randomIndex = Math.floor(Math.random() * wallpaperList.length);
        var randomPath = wallpaperList[randomIndex];
        if (!randomPath) {
            return;
        }
        setCurrentWallpaper(randomPath, false);
    }

    function toggleRandomWallpaper() {
        if (Settings.data.wallpaper.isRandom && !randomWallpaperTimer.running) {
            randomWallpaperTimer.start();
            setRandomWallpaper();
        } else if (!Settings.data.randomWallpaper && randomWallpaperTimer.running) {
            randomWallpaperTimer.stop();
        }
    }

    function restartRandomWallpaperTimer() {
        if (Settings.data.wallpaper.isRandom) {
            randomWallpaperTimer.stop();
            randomWallpaperTimer.start();
        }
    }

    Timer {
        id: randomWallpaperTimer
        interval: Settings.data.wallpaper.randomInterval * 1000
        running: false
        repeat: true
        onTriggered: setRandomWallpaper()
        triggeredOnStart: false
    }

    FolderListModel {
        id: folderModel
        // Swww supports many images format but Quickshell only support a subset of those.
        nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.gif", "*.pnm", "*.bmp"]
        showDirs: false
        sortField: FolderListModel.Name
        onStatusChanged: {
            if (status === FolderListModel.Ready) {
                var files = [];
                for (var i = 0; i < count; i++) {
                    var directory = (Settings.data.wallpaper.directory !== undefined ? Settings.data.wallpaper.directory : "");
                    var filepath = directory + "/" + get(i, "fileName");
                    files.push(filepath);
                }
                wallpaperList = files;
                scanning = false;
                Logger.log("Wallpapers", "List refreshed, count:", wallpaperList.length);
            }
        }
    }

    Process {
        id: changeWallpaperProcess
        command: ["wallust", "run", currentWallpaper, "-u", "-k", "-d", "/home/zen/zenflux/Quickshell/Utils/Themes"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: console.log(`WallP is ${currentWallpaper}`)
        }
    }
}
