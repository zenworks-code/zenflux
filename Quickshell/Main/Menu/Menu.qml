import Quickshell
import QtQuick
import qs.Generics.Tabs
import qs.Generics.Fixed
import qs.Generics.Styled
import qs.Generics.Flickables

Item {

    HorizontalFlickable {
        items: [
            Component {
                StyledRect {}
            },
            Component {
                Rectangle {
                    color: "blue"
                    Text {
                        text: "Page 2"
                        anchors.centerIn: parent
                    }
                }
            },
            Component {
                Rectangle {
                    color: "green"
                    Text {
                        text: "Page 3"
                        anchors.centerIn: parent
                    }
                }
            }
        ]
    }
}
