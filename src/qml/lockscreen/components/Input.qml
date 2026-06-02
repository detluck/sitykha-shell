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
    property bool splitBorderRadius: false
    property alias text: textField.text
    property string icon: ""
    property string eyeIconCl: ""
    property string eyeIconO: ""
    property bool enabled: true

    width: Config.passwordInputWidth * Config.generalScale
    height: Config.passwordInputHeight * Config.generalScale

    color: Config.passwordInputBackgroundColor
    opacity: Config.passwordInputBackgroundOpacity
    topLeftRadius: Config.passwordInputBorderRadiusLeft * Config.generalScale
    bottomLeftRadius: Config.passwordInputBorderRadiusLeft * Config.generalScale
    topRightRadius: input.splitBorderRadius ? Config.passwordInputBorderRadiusRight * Config.generalScale : Config.passwordInputBorderRadiusLeft * Config.generalScale
    bottomRightRadius: input.splitBorderRadius ? Config.passwordInputBorderRadiusRight * Config.generalScale : Config.passwordInputBorderRadiusLeft * Config.generalScale

    Rectangle {
        anchors.fill: parent
        border.width: Config.passwordInputBorderSize * Config.generalScale
        border.color: Config.passwordInputBorderColor
        color: "transparent"
        topLeftRadius: Config.passwordInputBorderRadiusLeft * Config.generalScale
        bottomLeftRadius: Config.passwordInputBorderRadiusLeft * Config.generalScale
        topRightRadius: input.splitBorderRadius ? Config.passwordInputBorderRadiusRight * Config.generalScale : Config.passwordInputBorderRadiusLeft * Config.generalScale
        bottomRightRadius: input.splitBorderRadius ? Config.passwordInputBorderRadiusRight * Config.generalScale : Config.passwordInputBorderRadiusLeft * Config.generalScale
    }

    RowLayout {
        spacing: 5
        anchors.fill: parent

        Rectangle {
            id: iconContainer
            color: "transparent"
            visible: Config.passwordInputDisplayIcon
            Layout.fillHeight: true
            Layout.preferredWidth: height

            Image {
                id: icon
                source: input.icon
                anchors.centerIn: parent
                width: Math.max(1, Config.passwordInputIconSize * Config.generalScale)
                height: width
                sourceSize: Qt.size(width, height)
                fillMode: Image.PreserveAspectFit
                opacity: input.enabled ? 1.0 : 0.3
                Behavior on opacity {
                    enabled: Config.enableAnimations
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
            color: Config.passwordInputContentColor
            enabled: input.enabled
            echoMode: input.isPassword ? TextInput.Password : TextInput.Normal
            passwordCharacter: Config.passwordInputMaskedCharacter
            activeFocusOnTab: true
            selectByMouse: true
            placeholderText: input.placeholder
            placeholderTextColor: Config.passwordInputContentColor
            verticalAlignment: TextField.AlignVCenter
            font.family: Config.passwordInputFontFamily
            font.pixelSize: Math.max(8, Config.passwordInputFontSize * Config.generalScale)
            background: Item{}
            onAccepted: input.accepted()

        }

        Rectangle {
            id: eyeIconContainer
            color: "transparent"
            visible: Config.passwordInputDisplayIcon
            Layout.fillHeight: true
            Layout.preferredWidth: height

            Image {
                id: eyeIcon
                source: input.isPassword? eyeIconCl: eyeIconO
                anchors.centerIn: parent
                width: Math.max(1, Config.passwordInputIconSize * Config.generalScale)
                height: width
                sourceSize: Qt.size(width, height)
                fillMode: Image.PreserveAspectFit
                opacity: input.enabled ? 1.0 : 0.3
                Behavior on opacity {
                    enabled: Config.enableAnimations
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