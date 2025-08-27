import qs.Services
import qs.Utils.Themes
import QtQuick

Text {
    verticalAlignment: Text.AlignVCenter
    font {
        family: Settings.data.ui.fontDefault
        pointSize: 12
    }
    color: Settings.data.colorSchemes.darkMode ? Theme.textPrimary : Theme.backgroundPrimary
}
