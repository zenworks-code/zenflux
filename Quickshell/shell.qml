import Quickshell
import qs.Services
import qs.Main.Wallpaper
import qs.Main.Notch
import qs.Main.Menu

ShellRoot {

    LazyLoader {
        active: Settings.data.enable.wallpaper
        component: WallpaperW {}
    }

    LazyLoader {
        active: Settings.data.enable.notch
        component: Notch {}
    }
    Menu {}
}
