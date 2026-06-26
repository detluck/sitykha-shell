pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import qs.services

Item {
    id: root

    //general
    property var menuModel: []
    property string mainIcon: ""
    property string iconModule: ""
    signal actionTriggered(var actionId)

    // button
    property int btnMarginTop: 3
    property int btnMarginRight: 3
    property int btnMarginBottom: 3
    property int btnMarginLeft: 3
    property int btnSize: 32
    property int btnBorderRadius: 5
    property int btnSpacing: 6
    property string btnFontFamily: "RedHatDisplay"
    property color btnBackgroundColor: "transparent"
    property real btnBackgroundOpacity: 0.0
    property color btnActiveBackgroundColor: activeOptionBackgroundColor
    property real btnActiveBackgroundOpacity: 0.2
    property color btnContentHoveredColor: activeContentColor

    //popup
    property int maxHeight: 250
    property int itemHeight: 34
    property int spacing: 3
    property int padding: 6
    property bool displayScrollbar: true
    property int margin: 5
    property color backgroundColor: "#2E2E2E"
    property real backgroundOpacity: 0.9
    property color activeOptionBackgroundColor: "#444444"
    property real activeOptionBackgroundOpacity: 0.8
    property color contentColor: "#D0D0D0"
    property color activeContentColor: "#FFFFFF"
    property string fontFamily: "RedHatDisplay"
    property int borderSize: 1
    property color borderColor: "#555555"
    property int fontSize: 12
    property int iconSize: 18

    property string popUpDirection: "up"
    property int popUpwidth: 160

    width: btnSize
    height: btnSize

    function hasIcon(itemData) {
        return itemData && typeof itemData === "object" && itemData.icon !== undefined;
    }

    Button {
        id: button
        anchors.fill: parent

        background: Rectangle {
            color: button.hovered ? root.btnActiveBackgroundColor : root.btnBackgroundColor
            opacity: button.hovered ? root.btnActiveBackgroundOpacity : root.btnBackgroundOpacity
            radius: root.btnBorderRadius
        }

        contentItem: Item {
            CustomIcon {
                anchors.centerIn: parent
                source: Pathes.getIcon(root.mainIcon, root.iconModule)
                size: root.iconSize
                color: button.hovered ? root.btnContentHoveredColor : root.contentColor
            }
        }

        onClicked: popupMenu.open()
    }

    Popup {
        id: popupMenu
        y: root.popUpDirection === "up" ? -(popupMenu.height + root.margin) : button.height + root.margin
        x: -(width - button.width)
        width: root.popUpwidth
        padding: root.padding
        height: Math.min(listView.implicitHeight + (root.padding * 2), root.maxHeight)
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            color: root.backgroundColor
            opacity: root.backgroundOpacity
            border.color: root.borderColor
            border.width: root.borderSize
            radius: root.btnBorderRadius
        }

        contentItem: ListView {
            id: listView
            implicitHeight: contentHeight
            model: root.menuModel
            spacing: root.spacing
            clip: true

            ScrollBar.vertical: ScrollBar {
                policy: root.displayScrollbar ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
            }

            delegate: ItemDelegate {
                id: item
                width: listView.width
                height: root.itemHeight

                required property var modelData

                background: Rectangle {
                    color: item.hovered ? root.activeOptionBackgroundColor : "transparent"
                    opacity: item.hovered ? root.activeOptionBackgroundOpacity : 0.0
                    radius: root.btnBorderRadius
                }

                contentItem: Row {
                    spacing: 10
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 8

                    CustomIcon {
                        anchors.verticalCenter: parent.verticalCenter
                        source: root.hasIcon(item.modelData) ? Pathes.getIcon(item.modelData.icon, root.iconModule) : ""
                        visible: root.hasIcon(item.modelData)
                        size: root.iconSize
                        color: item.hovered ? root.activeContentColor : root.contentColor
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: item.modelData.label
                        color: item.hovered ? root.activeContentColor : root.contentColor
                        font.pixelSize: root.fontSize
                        font.family: root.fontFamily
                    }
                }

                onClicked: {
                    popupMenu.close();
                    let action = "";
                    if (item.modelData.actionStr !== undefined) {
                        action = item.modelData.actionStr;
                    } else if (item.modelData.actionData !== undefined) {
                        action = item.modelData.actionData.toString();
                    }
                    root.actionTriggered(action);
                }
            }
        }

        // Animations
        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 100
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                property: "scale"
                from: 0.95
                to: 1.0
                duration: 100
                easing.type: Easing.OutQuad
            }
        }
        transformOrigin: root.popUpDirection === "up" ? Item.Bottom : Item.Top
    }
}
