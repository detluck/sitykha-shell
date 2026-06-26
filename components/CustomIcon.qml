pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects

Item {
    id: root

    property url source
    property color color: "#cba6f7"
    property int size: 24

    implicitWidth: size
    implicitHeight: size

    Image {
        id: internalImage
        anchors.fill: parent
        source: root.source
        sourceSize: Qt.size(width > 0 ? width : root.size, height > 0 ? height : root.size)
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        cache: true
        antialiasing: true

        visible: false
    }

    MultiEffect {
        anchors.fill: internalImage
        source: internalImage

        colorizationColor: root.color
        colorization: 1.0
        antialiasing: true
    }
}
