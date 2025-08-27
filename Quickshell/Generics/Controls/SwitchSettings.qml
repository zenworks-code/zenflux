import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Generics.Styled
import qs.Generics.Capsule

StyledRect {
    id: root
    property var tabsModel: []   // [{ text, get, set }...]

    height: parent.height - 32

    Column {
        anchors.fill: parent
        spacing: 24
        anchors.margins: 16

        Repeater {
            model: root.tabsModel
            delegate: Item {
                width: root.width
                height: 28

                StyledText {
                    text: modelData.text
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: Settings.data.general.margin
                }

                CapsuleSwitch {
                    // Live read: bind to the getter function
                    option: Qt.binding(modelData.get)
                    // Write: push changes back
                    onSwitched: modelData.set(option)
                    anchors.right: parent.right
                    anchors.rightMargin: Settings.data.general.margin * 2
                }
            }
        }
    }
}
