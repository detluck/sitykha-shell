pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Sitykha.Backend

Item {
    id: lockScreen
    signal loginRequested
    required property bool capsLockOn

    ColumnLayout {
        id: timePositioner
        spacing: Config.lock.lockScreen.date.marginTop

        Text {
            id: time
            visible: Config.lock.lockScreen.clock.display
            font.pixelSize: Config.lock.lockScreen.clock.fontSize * Config.lock.generalScale
            font.weight: Config.lock.lockScreen.clock.fontWeight
            font.family: Config.lock.lockScreen.clock.fontFamily
            color: Config.lock.lockScreen.clock.color
            Layout.alignment: Config.lock.lockScreen.clock.align === "left" ? Qt.AlignLeft : (Config.lock.lockScreen.clock.align === "right" ? Qt.AlignRight : Qt.AlignHCenter)

            function updateTime() {
                text = new Date().toLocaleString(Qt.locale(Config.lock.lockScreen.date.locale), Config.lock.lockScreen.clock.format);
            }
        }

        Text {
            id: date
            Layout.alignment: Config.lock.lockScreen.clock.align === "left" ? Qt.AlignLeft : (Config.lock.lockScreen.clock.align === "right" ? Qt.AlignRight : Qt.AlignHCenter)
            visible: Config.lock.lockScreen.date.display
            font.pixelSize: Config.lock.lockScreen.date.fontSize * Config.lock.generalScale
            font.family: Config.lock.lockScreen.date.fontFamily
            font.weight: Config.lock.lockScreen.date.fontWeight
            color: Config.lock.lockScreen.date.color

            function updateDate() {
                text = new Date().toLocaleString(Qt.locale(Config.lock.lockScreen.date.locale), Config.lock.lockScreen.date.format);
            }
        }

        Timer {
            id: clockTimer
            interval: 1000
            repeat: true
            running: true
            onTriggered: {
                time.updateTime();
                date.updateDate();
            }
        }

        Component.onDestruction: {
            if (clockTimer) {
                clockTimer.stop();
            }
        }

        anchors {
            // Fallbacks trigger if padding is exactly 0
            topMargin: Config.lock.lockScreen.paddingTop || (lockScreen.height > 0 ? lockScreen.height / 10 : 50)
            rightMargin: Config.lock.lockScreen.paddingRight || (lockScreen.height > 0 ? lockScreen.height / 10 : 50)
            bottomMargin: Config.lock.lockScreen.paddingBottom || (lockScreen.height > 0 ? lockScreen.height / 10 : 50)
            leftMargin: Config.lock.lockScreen.paddingLeft || (lockScreen.height > 0 ? lockScreen.height / 10 : 50)
        }

        Component.onCompleted: {
            lockScreen.alignItem(timePositioner, Config.lock.lockScreen.clock.position);
            time.updateTime();
            date.updateDate();
        }
    }

    ColumnLayout {
        id: messagePositioner
        visible: Config.lock.lockScreen.message.display
        spacing: Config.lock.lockScreen.message.spacing

        Item {
            Layout.alignment: Config.lock.lockScreen.message.align === "left" ? Qt.AlignLeft : (Config.lock.lockScreen.message.align === "right" ? Qt.AlignRight : Qt.AlignHCenter)
            Layout.preferredWidth: Config.lock.lockScreen.message.iconSize
            Layout.preferredHeight: Config.lock.lockScreen.message.iconSize

            Image {
                id: lockIcon
                source: "file:///home/detluck/Projects/sitykha-shell/assets/icons/" + (Config.lock.lockScreen.message.icon || "enter.svg")
                width: Config.lock.lockScreen.message.iconSize * Config.lock.generalScale
                height: width
                sourceSize: Qt.size(width, height)
                fillMode: Image.PreserveAspectFit
                visible: false
            }

            MultiEffect {
                source: lockIcon
                anchors.fill: lockIcon
                colorization: Config.lock.lockScreen.message.paintIcon ? 1 : 0
                colorizationColor: Config.lock.lockScreen.message.color
                visible: Config.lock.lockScreen.message.displayIcon
                antialiasing: true
            }
        }

        Text {
            id: lockMessage
            Layout.alignment: Config.lock.lockScreen.message.align === "left" ? Qt.AlignLeft : (Config.lock.lockScreen.message.align === "right" ? Qt.AlignRight : Qt.AlignHCenter)
            font.pixelSize: Config.lock.lockScreen.message.fontSize * Config.lock.generalScale
            font.family: Config.lock.lockScreen.message.fontFamily
            font.weight: Config.lock.lockScreen.message.fontWeight
            color: Config.lock.lockScreen.message.color
            text: Config.lock.lockScreen.message.text
        }

        anchors {
            topMargin: Config.lock.lockScreen.paddingTop || (lockScreen.height > 0 ? lockScreen.height / 10 : 50)
            rightMargin: Config.lock.lockScreen.paddingRight || (lockScreen.height > 0 ? lockScreen.height / 10 : 50)
            bottomMargin: Config.lock.lockScreen.paddingBottom || (lockScreen.height > 0 ? lockScreen.height / 10 : 50)
            leftMargin: Config.lock.lockScreen.paddingLeft || (lockScreen.height > 0 ? lockScreen.height / 10 : 50)
        }

        Component.onCompleted: lockScreen.alignItem(messagePositioner, Config.lock.lockScreen.message.position)
    }

    function alignItem(item, pos) {
        switch (pos) {
        case "top-left":
            item.anchors.top = lockScreen.top;
            item.anchors.left = lockScreen.left;
            break;
        case "top-center":
            item.anchors.top = lockScreen.top;
            item.anchors.horizontalCenter = lockScreen.horizontalCenter;
            break;
        case "top-right":
            item.anchors.top = lockScreen.top;
            item.anchors.right = lockScreen.right;
            break;
        case "center-left":
            item.anchors.verticalCenter = lockScreen.verticalCenter;
            item.anchors.left = lockScreen.left;
            break;
        case "center":
            item.anchors.verticalCenter = lockScreen.verticalCenter;
            item.anchors.horizontalCenter = lockScreen.horizontalCenter;
            break;
        case "center-right":
            item.anchors.verticalCenter = lockScreen.verticalCenter;
            item.anchors.right = lockScreen.right;
            break;
        case "bottom-left":
            item.anchors.bottom = lockScreen.bottom;
            item.anchors.left = lockScreen.left;
            break;
        case "bottom-center":
            item.anchors.bottom = lockScreen.bottom;
            item.anchors.horizontalCenter = lockScreen.horizontalCenter;
            break;
        default:
            item.anchors.bottom = lockScreen.bottom;
            item.anchors.right = lockScreen.right;
        }
    }

    MouseArea {
        id: lockScreenMouseArea
        hoverEnabled: true
        z: -1
        anchors.fill: lockScreen
        onClicked: lockScreen.loginRequested()
    }

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_CapsLock) {
            // Note: Make sure capsLockOn is defined in the root of the file containing this Item,
            // or redefine root.capsLockOn to target the correct parent.
            lockScreen.capsLockOn = !lockScreen.capsLockOn;
        }

        if (event.key === Qt.Key_Escape) {
            event.accepted = false;
            return;
        } else {
            lockScreen.loginRequested();
        }
        event.accepted = true;
    }
}
