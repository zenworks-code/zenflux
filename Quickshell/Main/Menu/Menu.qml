import Quickshell
import QtQuick
import QtQml
import qs.Main.Wallpaper
import qs.Services
import qs.Utils.Themes
import qs.Generics.Tabs
import qs.Generics.Styled
import qs.Generics.Controls
import qs.Generics.Flickables
import qs.Generics.Concentric

StyledRect {
    id: root

    height: parent.height / 2
    width: parent.width / 2

    property bool expandTabs: true

    color: Settings.data.colorSchemes.darkMode ? Theme.backgroundPrimary : Theme.textPrimary

    ConcentricRect {
        id: tabs
        height: parent.height
        width: 70
        anchors.left: parent.left
        anchors.margins: 16

        color: "transparent"

        NotchTabs {
            id: tabsChild
            anchors.verticalCenter: parent.verticalCenter
            tabsModel: [
                {
                    icon: "\uf69e"
                },
                {
                    icon: "\ufb27"
                },
                {
                    icon: "\uf673"
                },
                {
                    icon: "\ufe1b"
                }
            ]
        }
    }

    HorizontalFlickable {
        height: parent.height - 32
        width: parent.width - tabs.width - tabs.anchors.margins
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        items: [
            Component {
                SwitchSettings {
                    height: parent.height
                    width: parent.width
                    tabsModel: [
                        {
                            text: "Enable Dark Mode",
                            get: function () {
                                return Settings.data && Settings.data.colorSchemes ? Settings.data.colorSchemes.darkMode : false;
                            },
                            set: function (v) {
                                if (Settings.data && Settings.data.colorSchemes)
                                    Settings.data.colorSchemes.darkMode = v;
                            }
                        },
                        {
                            text: "Show Radius",
                            get: function () {
                                return Settings.data && Settings.data.general ? Settings.data.general.showRadius : false;
                            },
                            set: function (v) {
                                if (Settings.data && Settings.data.general)
                                    Settings.data.general.showRadius = v;
                            }
                        }
                    ]
                }
            },
            Component {
                SwitchSettings {
                    height: parent.height
                    width: parent.width
                    tabsModel: [
                        {
                            text: "Enable Background",
                            get: function () {
                                return Settings.data && Settings.data.enable ? Settings.data.enable.wallpaper : false;
                            },
                            set: function (v) {
                                if (Settings.data && Settings.data.enable)
                                    Settings.data.enable.wallpaper = v;
                            }
                        },
                        {
                            text: "Enable AppLauncher",
                            get: function () {
                                return Settings.data && Settings.data.enable ? Settings.data.enable.applauncher : false;
                            },
                            set: function (v) {
                                if (Settings.data && Settings.data.enable)
                                    Settings.data.enable.applauncher = v;
                            }
                        },
                        {
                            text: "Enable Wallpaper Switcher",
                            get: function () {
                                return Settings.data && Settings.data.enable ? Settings.data.enable.wallpaperswitcher : false;
                            },
                            set: function (v) {
                                if (Settings.data && Settings.data.enable)
                                    Settings.data.enable.wallpaperswitcher = v;
                            }
                        },
                        {
                            text: "Enable Lock",
                            get: function () {
                                return Settings.data && Settings.data.enable ? Settings.data.enable.lock : false;
                            },
                            set: function (v) {
                                if (Settings.data && Settings.data.enable)
                                    Settings.data.enable.lock = v;
                            }
                        },
                        {
                            text: "Enable Notch",
                            get: function () {
                                return Settings.data && Settings.data.enable ? Settings.data.enable.notch : false;
                            },
                            set: function (v) {
                                if (Settings.data && Settings.data.enable)
                                    Settings.data.enable.notch = v;
                            }
                        },
                        {
                            text: "Enable Calculator",
                            get: function () {
                                return Settings.data && Settings.data.enable ? Settings.data.enable.calculator : false;
                            },
                            set: function (v) {
                                if (Settings.data && Settings.data.enable)
                                    Settings.data.enable.calculator = v;
                            }
                        },
                    ]
                }
            },
            Component {

                WallpaperPanel {}
            }
        ]
    }
}
