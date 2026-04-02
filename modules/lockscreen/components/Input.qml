import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtQuick.Effects

Rectangle {
    id: input

    signal accepted

    property string placeholder: ""
    property alias input: textField
    property bool isPassword: false
    property alias text: textField.text
    property string icon: ""
    property string eyeIconCl: ""
    property string eyeIconO: ""
    property bool enabled: true

    width: Config.lockscreen.input.width * Config.lockscreen.general.scale
    height: Config.lockscreen.input.height * Config.lockscreen.general.scale

    color: Config.lockscreen.input.backgroundColor
    opacity: Config.lockscreen.input.backgroundOpacity
    topLeftRadius: Config.lockscreen.input.borderRadiusLeft * Config.lockscreen.general.scale
    bottomLeftRadius: Config.lockscreen.input.borderRadiusLeft * Config.lockscreen.general.scale
    topRightRadius: Config.lockscreen.input.borderRadiusRight * Config.lockscreen.general.scale
    bottomRightRadius: Config.lockscreen.input.borderRadiusRight * Config.lockscreen.general.scale

    Rectangle {
        anchors.fill: parent
        border.width: Config.lockscreen.input.passwordInputBorderSize * Config.lockscreen.general.generalScale
        border.color: Config.lockscreen.input.passwordInputBorderColor
        color: "transparent"
        topLeftRadius: Config.lockscreen.input.passwordInputBorderRadiusLeft * Config.lockscreen.general.generalScale
        bottomLeftRadius: Config.lockscreen.input.passwordInputBorderRadiusLeft * Config.lockscreen.general.generalScale
        topRightRadius: input.splitBorderRadius ? Config.lockscreen.input.passwordInputBorderRadiusRight * Config.lockscreen.general.generalScale : Config.lockscreen.input.passwordInputBorderRadiusLeft * Config.lockscreen.general.generalScale
        bottomRightRadius: input.splitBorderRadius ? Config.lockscreen.input.passwordInputBorderRadiusRight * Config.lockscreen.general.generalScale : Config.lockscreen.input.passwordInputBorderRadiusLeft * Config.lockscreen.generalScale
    }

    RowLayout {
        spacing: 5
        anchors.fill: parent

        Rectangle {
            id: iconContainer
            color: "transparent"
            visible: Config.lockscreen.input.passwordInputDisplayIcon
            Layout.fillHeight: true
            Layout.preferredWidth: height

            Image {
                id: icon
                source: input.icon
                anchors.centerIn: parent
                width: Math.max(1, Config.lockscreen.input.passwordInputIconSize * Config.lockscreen.general.generalScale)
                height: width
                sourceSize: Qt.size(width, height)
                fillMode: Image.PreserveAspectFit
                opacity: input.enabled ? 1.0 : 0.3
                Behavior on opacity {
                    enabled: Config.lockscreen.general.enableAnimations
                    NumberAnimation {
                        duration: 250
                    }
                }

                MultiEffect {
                    source: parent
                    anchors.fill: parent
                    colorization: 1
                    colorizationColor: textField.color
                }
            }
        }

        TextField {
            id: textField
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Config.lockscreen.input.passwordInputContentColor
            enabled: input.enabled
            echoMode: input.isPassword ? TextInput.Password : TextInput.Normal
            passwordCharacter: Config.lockscreen.input.passwordInputMaskedCharacter
            activeFocusOnTab: true
            selectByMouse: true
            placeholderText: input.placeholder
            placeholderTextColor: Config.lockscreen.input.passwordInputContentColor
            verticalAlignment: TextField.AlignVCenter
            font.family: Config.lockscreen.input.passwordInputFontFamily
            font.pixelSize: Math.max(8, Config.lockscreen.input.passwordInputFontSize * Config.lockscreen.general.generalScale)
            background: Item{}
            onAccepted: input.accepted()

        }

        Rectangle {
            id: eyeIconContainer
            color: "transparent"
            visible: Config.lockscreen.input.passwordInputDisplayIcon
            Layout.fillHeight: true
            Layout.preferredWidth: height

            Image {
                id: eyeIcon
                source: input.isPassword? eyeIconCl: eyeIconO
                anchors.centerIn: parent
                width: Math.max(1, Config.lockscreen.input.passwordInputIconSize * Config.lockscreen.input.generalScale)
                height: width
                sourceSize: Qt.size(width, height)
                fillMode: Image.PreserveAspectFit
                opacity: input.enabled ? 1.0 : 0.3
                Behavior on opacity {
                    enabled: Config.lockscreen.general.enableAnimations
                    NumberAnimation {
                        duration: 250
                    }
                }

                layer.enabled: true
                layer.effect: ColorOverlay {
                    color: textField.color
                }
            }

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    isPassword = !isPassword
                }
            }
        }
    }
}