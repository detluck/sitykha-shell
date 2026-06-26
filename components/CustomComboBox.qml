pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Basic
import Quickshell.Widgets
import Sitykha.Backend

ComboBox {
    id: control

    property int preferredWidth: 200
    implicitWidth: preferredWidth
    implicitHeight: 36

    property color baseColor: "black"
    property color hoverColor: "gray"
    property color borderNormalColor: "white"
    property color borderFocusColor: "gray"
    property color textColor: "white"

    property color popupBgColor: "black"
    property color itemHighlightColor: "gray"

    // Helper functions for polymorphic model handling
    function hasIcon(itemData) {
        return itemData && typeof itemData === "object" && itemData.icon !== undefined;
    }
    function getText(itemData) {
        return typeof itemData === "object" ? (itemData.text ?? "") : itemData;
    }
    function getIcon(itemData) {
        return typeof itemData === "object" ? (itemData.icon ?? "") : "";
    }

    popup: Popup {
        y: control.height + 4
        width: control.width
        implicitHeight: contentItem.implicitHeight
        padding: 4

        background: Rectangle {
            color: control.popupBgColor
            radius: 8
            border.color: control.borderNormalColor
            border.width: 1
        }

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            ScrollIndicator.vertical: ScrollIndicator {}
        }
    }

    delegate: ItemDelegate {
        id: itemDelegate
        width: control.width - 8
        height: 32

        required property var modelData
        required property int index

        Rectangle {
            anchors.fill: parent
            radius: 6
            color: control.itemHighlightColor
            opacity: 0.15
            visible: control.highlightedIndex === itemDelegate.index
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 8
            spacing: 8

            CustomIcon {
                anchors.verticalCenter: parent.verticalCenter
                source: control.hasIcon(itemDelegate.modelData) ? control.getIcon(itemDelegate.modelData) : ""
                visible: control.hasIcon(itemDelegate.modelData)
                color: control.highlightedIndex === itemDelegate.index ? control.itemHighlightColor : control.textColor
                size: 16
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: control.getText(itemDelegate.modelData)
                color: control.textColor // <-- Exposed Property
                font.pixelSize: 14
            }
        }
    }

    background: Rectangle {
        implicitWidth: control.preferredWidth
        implicitHeight: control.implicitHeight
        color: control.hovered ? control.hoverColor : control.baseColor // <-- Exposed Properties
        radius: 8
        border.color: control.activeFocus ? control.borderFocusColor : control.borderNormalColor
        border.width: 1
    }

    contentItem: Item {
        width: control.width
        height: control.height

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 12
            spacing: 8

            CustomIcon {
                anchors.verticalCenter: parent.verticalCenter
                source: control.hasIcon(control.model[control.currentIndex]) ? control.getIcon(control.model[control.currentIndex]) : ""
                visible: control.hasIcon(control.model[control.currentIndex])
                color: control.textColor
                size: 16
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: control.displayText
                color: control.textColor
                font.pixelSize: 14
            }
        }

        CustomIcon {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 12
            source: "qrc:/icons/chevron-down.svg"
            color: control.textColor
            size: 16

            rotation: control.popup.visible ? 180 : 0
            Behavior on rotation {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
        }
    }
}
