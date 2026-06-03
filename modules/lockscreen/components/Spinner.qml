import QtQuick
import QtQuick.Effects
import Sitykha.Backend
import qs.services

Item {
    id: spinnerContainer
    width: (spinner.width + Config.lock.loginScreen.loginArea.spinner.spacing + spinnerText.width) * Config.lock.generalScale
    height: childrenRect.height * Config.lock.generalScale

    Behavior on opacity {
        enabled: Config.lock.enableAnimations
        NumberAnimation {
            duration: 150
        }
    }
    Behavior on visible {
        enabled: Config.lock.enableAnimations && Config.lock.loginScreen.loginArea.spinner.displayText
        ParallelAnimation {
            running: spinnerContainer.visible && Config.lock.loginScreen.loginArea.spinner.displayText
            NumberAnimation {
                target: spinnerText
                property: Config.lock.loginScreen.loginArea.position === "left" ? "anchors.leftMargin" : (Config.lock.loginScreen.loginArea.position === "right" ? "anchors.rightMargin" : "anchors.topMargin")
                from: -spinner.height
                to: Config.lock.loginScreen.loginArea.spinner.spacing
                duration: 300
                easing.type: Easing.OutQuart
            }
            NumberAnimation {
                target: spinnerEffect
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 200
            }
        }
    }

    Image {
        id: spinner
        source: Pathes.getIcon(Config.lock.loginScreen.loginArea.spinner.icon || "spinner.svg", "lock")
        width: Config.lock.loginScreen.loginArea.spinner.iconSize * Config.lock.generalScale
        height: width
        sourceSize.width: width
        sourceSize.height: height
        visible: false

        Component.onCompleted: {
            if (Config.lock.loginScreen.loginArea.position === "left") {
                anchors.left = parent.left;
                anchors.verticalCenter = parent.verticalCenter;
            } else if (Config.lock.loginScreen.loginArea.position === "right") {
                anchors.right = parent.right;
                anchors.verticalCenter = parent.verticalCenter;
            } else {
                anchors.top = parent.top;
                anchors.horizontalCenter = parent.horizontalCenter;
            }
        }
    }
    MultiEffect {
        id: spinnerEffect
        source: spinner
        anchors.fill: spinner
        colorization: 1
        colorizationColor: Config.lock.loginScreen.loginArea.spinner.color
        opacity: Config.lock.loginScreen.loginArea.spinner.displayText ? 0.0 : 1.0
        antialiasing: true
    }
    RotationAnimation {
        target: spinnerEffect
        running: spinnerContainer.visible && Config.lock.enableAnimations
        from: 0
        to: 360
        loops: Animation.Infinite
        duration: 1200
    }

    Text {
        id: spinnerText
        visible: Config.lock.loginScreen.loginArea.spinner.displayText
        text: Config.lock.loginScreen.loginArea.spinner.text
        color: Config.lock.loginScreen.loginArea.spinner.color
        font.pixelSize: Config.lock.loginScreen.loginArea.spinner.fontSize * Config.lock.generalScale
        font.weight: Config.lock.loginScreen.loginArea.spinner.fontWeight
        font.family: Config.lock.loginScreen.loginArea.spinner.fontFamily

        Component.onCompleted: {
            if (Config.lock.loginScreen.loginArea.position === "left") {
                anchors.left = spinner.right;
                anchors.leftMargin = Config.lock.loginScreen.loginArea.spinner.spacing;
                anchors.verticalCenter = parent.verticalCenter;
            } else if (Config.lock.loginScreen.loginArea.position === "right") {
                anchors.right = spinner.left;
                anchors.rightMargin = Config.lock.loginScreen.loginArea.spinner.spacing;
                anchors.verticalCenter = parent.verticalCenter;
            } else {
                anchors.top = spinner.bottom;
                anchors.topMargin = Config.lock.loginScreen.loginArea.spinner.spacing;
                anchors.horizontalCenter = parent.horizontalCenter;
            }
        }

        onVisibleChanged: {
            if (visible && Config.lock.enableAnimations && Config.lock.loginScreen.loginArea.spinner.displayText) {
                spinnerTextInterval.running = true;
            } else {
                spinnerTextAnimation.running = false;
                spinnerTextInterval.running = false;
            }
        }

        SequentialAnimation on scale {
            id: spinnerTextAnimation
            running: false
            loops: Animation.Infinite
            NumberAnimation {
                from: 1.0
                to: 1.05
                duration: 900
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                from: 1.05
                to: 1.0
                duration: 900
                easing.type: Easing.InOutQuad
            }
        }
    }

    Timer {
        id: spinnerTextInterval
        interval: 3500
        repeat: false
        running: false
        onTriggered: {
            spinnerTextAnimation.running = true;
        }
    }

    Component.onDestruction: {
        if (spinnerTextInterval) {
            spinnerTextInterval.running = false;
            spinnerTextInterval.stop();
        }
        if (spinnerTextAnimation) {
            spinnerTextAnimation.running = false;
            spinnerTextAnimation.stop();
        }
    }
}
