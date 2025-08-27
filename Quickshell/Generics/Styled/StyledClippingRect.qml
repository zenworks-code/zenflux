import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Services

ClippingRectangle {
    radius: Settings.data.general.hasRadius ? height / 2 : 0
    width: 100
    height: 100
    color: Settings.data.colorSchemes.darkMode ? Theme.backgroundPrimary : Theme.textPrimary
}
