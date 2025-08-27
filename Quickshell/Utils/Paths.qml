pragma Singleton

import Quickshell
import qs.Services
import Qt.labs.platform

Singleton {
    id: root

    property string shellName: Settings.shellName

    readonly property url home: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
    readonly property url pictures: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]

    readonly property url data: `${StandardPaths.standardLocations(StandardPaths.GenericDataLocation)[0]}/${shellName}`
    readonly property url state: `${StandardPaths.standardLocations(StandardPaths.GenericStateLocation)[0]}/${shellName}`
    readonly property url cache: `${StandardPaths.standardLocations(StandardPaths.GenericCacheLocation)[0]}/${shellName}`
    readonly property url config: `${StandardPaths.standardLocations(StandardPaths.GenericConfigLocation)[0]}/${shellName}`
    readonly property url shellLocation: `${home}/${shellName}`

    readonly property url imagecache: `${cache}/imagecache`

    readonly property string settingsFile: `${config}/Settings.json`
    readonly property string themeFile: `${shellLocation}/Utils/Theme.json`

    readonly property string videoPath: `${home}/Videos`
    readonly property string profileImage: `${home}/.face`
    readonly property string wallpaperDir: `${home}/Wallpapers`
    readonly property string wallustDir: `${shellLocation}/Utils/Themes`

    property string wallpaperPath: ""
    function stringify(path: url): string {
        return path.toString().replace(/%20/g, " ");
    }

    function expandTilde(path: string): string {
        return strip(path.replace("~", stringify(root.home)));
    }

    function shortenHome(path: string): string {
        return path.replace(strip(root.home), "~");
    }

    function strip(path: url): string {
        return stringify(path).replace("file://", "");
    }

    function mkdir(path: url): void {
        Quickshell.execDetached(["mkdir", "-p", strip(path)]);
    }

    function copy(from: url, to: url): void {
        Quickshell.execDetached(["cp", strip(from), strip(to)]);
    }
}
