pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import Sitykha.Core

Rectangle {
    id: avatar
    property string shape: Config.lock.loginScreen.loginArea.avatar.shape
    property string source: ""
    property bool active: false

    // Config.lock.generalScale und Config.lock.loginArea.avatar.borderRadius
    property int squareRadius: (shape == "circle") ? this.width : (Config.lock.loginScreen.loginArea.avatar.borderRadius === 0 ? 1 : Config.lock.loginArea.avatar.borderRadius * Config.lock.generalScale) // min: 1

    // Config.lock.loginArea.avatar.activeBorderSize / inactiveBorderSize
    property bool drawStroke: (active && Config.lock.loginScreen.loginArea.avatar.activeBorderSize > 0) || (!active && Config.lock.loginArea.avatar.inactiveBorderSize > 0)

    // Config.lock.loginArea.avatar.activeBorderColor / inactiveBorderColor
    property color strokeColor: active ? Config.lock.loginScreen.loginArea.avatar.activeBorderColor : Config.lock.loginArea.avatar.inactiveBorderColor

    // Stroke Size mit General Scale
    property int strokeSize: active ? (Config.lock.loginScreen.loginArea.avatar.activeBorderSize * Config.lock.generalScale) : (Config.lock.loginArea.avatar.inactiveBorderSize * Config.lock.generalScale)

    property string tooltipText: ""
    property bool showTooltip: false

    signal clicked
    signal clickedOutside

    radius: squareRadius
    color: "transparent"
    antialiasing: true

    // Background
    Rectangle {
        anchors.fill: parent
        radius: avatar.squareRadius
        color: Config.lock.loginScreen.loginArea.passwordInput.backgroundColor
        opacity: Config.lock.loginScreen.loginArea.passwordInput.backgroundOpacity
        visible: true
    }

    Image {
        id: faceImage
        source: parent.source
        anchors.fill: parent
        mipmap: true
        antialiasing: true
        visible: false
        smooth: true

        fillMode: Image.PreserveAspectCrop
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter

        onStatusChanged: {
            if (status === Image.Error) {
                source = "file:///home/detluck/Projects/sitykha-shell/assets/icons/user-default.svg";
                faceEffects.colorization = 1;
            }
        }

        // Border
        Rectangle {
            anchors.fill: parent
            radius: avatar.squareRadius
            color: "transparent"
            border.width: avatar.strokeSize
            border.color: avatar.strokeColor
            antialiasing: true
        }
    }

    MultiEffect {
        id: faceEffects
        anchors.fill: faceImage
        source: faceImage
        antialiasing: true
        maskEnabled: true
        maskSource: faceImageMask
        maskSpreadAtMin: 1.0
        maskThresholdMax: 1.0
        maskThresholdMin: 0.5
        colorization: 0

        colorizationColor: avatar.strokeColor === Config.lock.loginScreen.loginArea.passwordInput.backgroundColor && (1.0 - Config.lock.loginArea.passwordInput.backgroundOpacity < 0.3) ? Config.lock.loginArea.passwordInput.contentColor : avatar.strokeColor
    }

    Item {
        id: faceImageMask

        height: this.width
        layer.enabled: true
        layer.smooth: true
        visible: false
        width: faceImage.width

        Rectangle {
            height: this.width
            radius: avatar.squareRadius
            width: faceImage.width
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.ArrowCursor

        function isCursorInsideAvatar() {
            if (!mouseArea.containsMouse)
                return false;
            if (avatar.shape === "square")
                return true;

            // Ellipse center and radius
            var centerX = width / 2;
            var centerY = height / 2;
            var radiusX = centerX;
            var radiusY = centerY;

            // Distance from center
            var dx = (mouseArea.mouseX - centerX) / radiusX;
            var dy = (mouseArea.mouseY - centerY) / radiusY;

            // Check if pointer is inside the ellipse
            return (dx * dx + dy * dy) <= 1.0;
        }

        onReleased: function (mouse) {
            var isInside = isCursorInsideAvatar();
            if (isInside) {
                avatar.clicked();
            } else {
                avatar.clickedOutside();
            }
            mouse.accepted = isInside;
        }

        function updateHover() {
            if (isCursorInsideAvatar()) {
                cursorShape = Qt.PointingHandCursor;
            } else {
                cursorShape = Qt.ArrowCursor;
            }
        }

        onMouseXChanged: updateHover()
        onMouseYChanged: updateHover()

        ToolTip {
            id: toolTipControl
            parent: mouseArea

            // Tooltips Configs
            enabled: Config.lock.tooltips.enable && !Config.lock.tooltips.disableUser
            property bool shouldShow: enabled && avatar.showTooltip || (enabled && mouseArea.isCursorInsideAvatar() && avatar.tooltipText !== "")
            visible: shouldShow
            delay: 300
            y: -height - 10
            x: (parent.width - width) / 2

            contentItem: Text {
                id: tooltipTextElement
                font.family: Config.lock.tooltips.fontFamily
                font.pixelSize: Config.lock.tooltips.fontSize * Config.lock.generalScale
                text: avatar.tooltipText
                color: Config.lock.tooltips.contentColor
            }

            background: Rectangle {
                implicitWidth: tooltipTextElement.implicitWidth + (toolTipControl.leftPadding + toolTipControl.rightPadding)
                implicitHeight: tooltipTextElement.implicitHeight + (toolTipControl.topPadding + toolTipControl.bottomPadding)
                color: Config.lock.tooltips.backgroundColor
                opacity: Config.lock.tooltips.backgroundOpacity
                border.width: 0
                radius: Config.lock.tooltips.borderRadius * Config.lock.generalScale
            }
        }
    }
}
