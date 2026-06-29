pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Sitykha.Backend

Rectangle {
    id: input

    signal accepted

    property string placeholder: ""
    property alias input: textField
    property bool isPassword: false
    property bool splitBorderRadius: false
    property alias text: textField.text
    property string icon: Config.pathes.getIcon("password.svg", "lock")
    property string eyeIconCl: Config.pathes.getIcon("eye-cl.svg", "lock")
    property string eyeIconO: Config.pathes.getIcon("eye-o.svg", "lock")
    property bool enabled: true

    width: Config.lock.loginScreen.loginArea.passwordInput.width * Config.lock.generalScale
    height: Config.lock.loginScreen.loginArea.passwordInput.height * Config.lock.generalScale

    color: Config.lock.loginScreen.loginArea.passwordInput.backgroundColor
    opacity: Config.lock.loginScreen.loginArea.passwordInput.backgroundOpacity

    // Border Radius Setup
    topLeftRadius: Config.lock.loginScreen.loginArea.passwordInput.borderRadiusLeft * Config.lock.generalScale
    bottomLeftRadius: Config.lock.loginScreen.loginArea.passwordInput.borderRadiusLeft * Config.lock.generalScale
    topRightRadius: input.splitBorderRadius ? Config.lock.loginScreen.loginArea.passwordInput.borderRadiusRight * Config.lock.generalScale : Config.lock.loginScreen.loginArea.passwordInput.borderRadiusLeft * Config.lock.generalScale
    bottomRightRadius: input.splitBorderRadius ? Config.lock.loginScreen.loginArea.passwordInput.borderRadiusRight * Config.lock.generalScale : Config.lock.loginScreen.loginArea.passwordInput.borderRadiusLeft * Config.lock.generalScale

    // The Border
    Rectangle {
        anchors.fill: parent
        border.width: Config.lock.loginScreen.loginArea.passwordInput.borderSize * Config.lock.generalScale
        border.color: Config.lock.loginScreen.loginArea.passwordInput.borderColor
        color: "transparent"

        topLeftRadius: input.topLeftRadius
        bottomLeftRadius: input.bottomLeftRadius
        topRightRadius: input.topRightRadius
        bottomRightRadius: input.bottomRightRadius
    }

    RowLayout {
        spacing: 5
        anchors.fill: parent

        // 1. LEFT ICON (The Lock/Password Icon)
        Rectangle {
            id: iconContainer
            color: "transparent"
            visible: Config.lock.loginScreen.loginArea.passwordInput.displayIcon
            Layout.fillHeight: true
            Layout.preferredWidth: height

            Image {
                id: iconImage
                source: input.icon
                anchors.centerIn: parent
                width: Math.max(1, Config.lock.loginScreen.loginArea.passwordInput.iconSize * Config.lock.generalScale)
                height: width
                sourceSize: Qt.size(width, height)
                fillMode: Image.PreserveAspectFit
                visible: false
            }

            MultiEffect {
                source: iconImage
                anchors.fill: iconImage
                colorization: 1
                colorizationColor: textField.color
                opacity: input.enabled ? 1.0 : 0.3

                Behavior on opacity {
                    enabled: Config.lock.enableAnimations
                    NumberAnimation {
                        duration: 250
                    }
                }
            }
        }

        TextField {
            id: textField
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Config.lock.loginScreen.loginArea.passwordInput.contentColor
            enabled: input.enabled
            echoMode: input.isPassword ? TextInput.Password : TextInput.Normal
            passwordCharacter: Config.lock.loginScreen.loginArea.passwordInput.maskedCharacter
            activeFocusOnTab: true
            selectByMouse: true
            placeholderText: input.placeholder
            placeholderTextColor: Config.lock.loginScreen.loginArea.passwordInput.contentColor
            verticalAlignment: TextField.AlignVCenter
            font.family: Config.lock.loginScreen.loginArea.passwordInput.fontFamily
            font.pixelSize: Math.max(8, Config.lock.loginScreen.loginArea.passwordInput.fontSize * Config.lock.generalScale)

            background: Item {}

            onAccepted: input.accepted()
        }

        Rectangle {
            id: eyeIconContainer
            color: "transparent"
            visible: Config.lock.loginScreen.loginArea.passwordInput.displayIcon
            Layout.fillHeight: true
            Layout.preferredWidth: height

            Image {
                id: eyeIcon
                source: input.isPassword ? input.eyeIconCl : input.eyeIconO
                anchors.centerIn: parent
                width: Math.max(1, Config.lock.loginScreen.loginArea.passwordInput.iconSize * Config.lock.generalScale)
                height: width
                sourceSize: Qt.size(width, height)
                fillMode: Image.PreserveAspectFit

                visible: false
            }

            MultiEffect {
                source: eyeIcon
                anchors.fill: eyeIcon
                colorization: 1
                colorizationColor: textField.color
                opacity: input.enabled ? 1.0 : 0.3

                Behavior on opacity {
                    enabled: Config.lock.enableAnimations
                    NumberAnimation {
                        duration: 250
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    //input.isPassword = !input.isPassword;
                    Config.resetThemeOverrides();
                }
            }
        }
    }
}
