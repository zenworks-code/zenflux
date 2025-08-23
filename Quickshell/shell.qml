import Quickshell
import qs.Services
import qs.Main.Wallpaper

ShellRoot {

    LazyLoader {
        active: Settings.options.enable.background
        component: WallpaperW {}
    }
}
