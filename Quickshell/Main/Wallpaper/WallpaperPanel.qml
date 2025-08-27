import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Services
import qs.Utils.Themes
import qs.Generics.Styled

Rectangle {
    id: wallpaperPanelModal
    property var wallpapers: []

    Connections {
        target: WallpaperService
        function onWallpaperListChanged() {
            wallpapers = WallpaperService.wallpaperList;
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 32
        spacing: 0

        // Wallpaper grid area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.topMargin: 16
            anchors.bottomMargin: 16
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.margins: 0
            clip: true
            ScrollView {
                id: scrollView
                anchors.fill: parent
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                GridView {
                    id: wallpaperGrid

                    anchors.fill: parent
                    cellWidth: Math.max(120, (scrollView.width / 3) - 12)
                    cellHeight: cellWidth * 0.6
                    model: wallpapers
                    cacheBuffer: 32
                    leftMargin: 8
                    rightMargin: 8
                    topMargin: 8
                    bottomMargin: 8
                    delegate: Item {
                        width: wallpaperGrid.cellWidth - 8
                        height: wallpaperGrid.cellHeight - 8
                        StyledClippingRect {
                            id: wallpaperItem
                            anchors.fill: parent
                            anchors.margins: 4
                            color: Qt.darker(Theme.backgroundPrimary, 1.1)
                            border.color: Settings.data.wallpaper.path === modelData ? Theme.accentPrimary : Theme.outline
                            border.width: Settings.data.wallpaper.path === modelData ? 3 : 1
                            CachingImages {
                                id: wallpaperImage
                                anchors.fill: parent
                                path: modelData
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                                cache: true
                                sourceSize.width: Math.min(width, 150)
                                sourceSize.height: Math.min(height, 90)
                            }
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    WallpaperService.setCurrentWallpaper(modelData);
                                }
                                onEntered: wallpaperItem.border.color = Theme.accentPrimary
                                onExited: wallpaperItem.border.color = Theme.outline
                            }
                        }
                    }
                }
            }
        }
    }
}
