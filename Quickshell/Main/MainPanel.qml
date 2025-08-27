import Quickshell
import QtQuick
import qs.Generics.Panels
import qs.Services
import qs.Main.Notch
import qs.Main.Menu
import qs.Main.Wallpaper
import Quickshell.Wayland

Variants {

    model: Quickshell.screens

    Scope {

        required property ShellScreen modelData
        PanelWindow {
            anchors {
                left: true
                right: true
                bottom: true
                top: true
            }

            color: "transparent"

            mask: Region {
                item: menu
            }
            LazyLoader {
                active: Settings.data.enable.menu
                component: Menu {}
            }

            LazyLoader {
                active: Settings.data.enable.notch
                component: Notch {}
            }
        }
    }
}
