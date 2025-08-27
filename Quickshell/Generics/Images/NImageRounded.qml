import QtQuick
import QtQuick.Effects
import qs.Generics.Icons

Rectangle {
  id: root

  property color borderColor: Color.transparent
  property real borderWidth: 0
  property string fallbackIcon: ""
  property string imagePath: ""
  property real imageRadius: width * 0.5

  anchors.margins: Style.marginTiniest * scaling
  color: Color.transparent
  radius: imageRadius

  // Border
  Rectangle {
    anchors.fill: parent
    border.color: parent.borderColor
    border.width: parent.borderWidth
    color: Color.transparent
    radius: parent.radius
    z: 10
  }

  Image {
    id: img

    anchors.fill: parent
    asynchronous: true
    fillMode: Image.PreserveAspectCrop
    mipmap: true
    smooth: true
    source: imagePath
    visible: false
  }

  MultiEffect {
    anchors.fill: parent
    maskEnabled: true
    maskSource: mask
    source: img
    visible: imagePath !== ""
  }

  Item {
    id: mask

    anchors.fill: parent
    layer.enabled: true
    visible: false

    Rectangle {
      anchors.fill: parent
      radius: root.imageRadius
    }
  }

  // Fallback icon
  TextIcon {
    anchors.centerIn: parent
    text: fallbackIcon
    visible: fallbackIcon !== undefined && fallbackIcon !== "" && (source === undefined || source === "")
    z: 0
  }
}
