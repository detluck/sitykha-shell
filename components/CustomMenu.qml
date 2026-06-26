pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import qs.services

Item {
    id: root
    width: 200
    height: 36

    //general
    property var menuModel: []
    property real activeBackgoundOpacity: 0.0
    property real backgroundOpacity: 0.0

    //popup
    property string popUpDirection: "up"
    property int popUpwidth: 200
    property color popUpBackgroundColor: "#FFFFFF"
    property color popUpBorderColor: "#FFFFFF"
    property int popUpBorderSize: borderSize
    property int popUpBorderRadius: borderRadius
    // content
    property color contentColor: "#FFFFFF"
    property color activeContentColor: "#FFFFFF"
    property color hoveredColor: contentColor
    property color contentBackgroundColor: popUpBackgroundColor
    property color borderColor: popUpBorderColor
    property int borderSize: 2
    property int borderRadius: 3
    property string mainIcon: ""
    property string iconModule: ""
    property int iconSize: 20

    signal actionTriggered(string actionId)

    Button {
        id: button
        anchors.fill: parent

        background: Rectangle {
            color: button.hovered ? root.hoveredColor : root.contentBackgroundColor
            opacity: button.hovered ? root.activeBackgoundOpacity : root.backgroundOpacity
            border.width: root.borderSize
            radius: root.borderRadius
        }

        contentItem: CustomIcon {
            source: Pathes.getIcon(root.mainIcon, root.iconModule)
            size: root.iconSize
            color: button.hovered ? root.activeContentColor : root.contentColor
        }

        onClicked: popupMenu.open()
    }

    Popup {
        id: popupMenu
        y: root.popUpDirection === "up" ? -(popupMenu.height + 4) : button.height + 4
        x: -(width - button.width)
        width: 160
        padding: 4
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            color: root.popUpBackgroundColor
            border.color: root.popUpBorderColor
            border.width: root.popUpBorderSize
            radius: root.popUpBorderRadius
        }

        contentItem: ListView {
            id: listView
            implicitHeight: contentHeight
            model: root.menuModel

            delegate: ItemDelegate {
                id: item
                width: listView.width
                height: 36

                required property var modelData

                background: Rectangle {
                    color: item.hovered ? root.hoveredColor : "transparent"
                    radius: root.popUpBorderRadius
                }

                contentItem: Row {
                    spacing: 10
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 8

                    CustomIcon {
                        anchors.verticalCenter: parent.verticalCenter
                        source: Pathes.getIcon(item.modelData.iconName, root.iconModule)
                        size: root.iconSize
                        color: item.hovered ? root.activeContentColor : root.contentColor
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: item.modelData.label
                        color: item.hovered ? root.activeContentColor : root.contentColor
                        font.pixelSize: 13
                    }
                }

                onClicked: {
                    popupMenu.close();
                    root.actionTriggered(item.modelData.actionStr);
                }
            }
        }

        //anims
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
