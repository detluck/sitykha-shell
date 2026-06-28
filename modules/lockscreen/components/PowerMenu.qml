import QtQuick
import Quickshell
import qs.components
import Sitykha.Backend

CustomMenu {
    id: powerButton

    mainIcon: Config.lock.loginScreen.menuArea.power.icon
    iconModule: "power"

    btnMarginTop: Config.lock.loginScreen.menuArea.buttons.marginTop * Config.lock.generalScale
    btnMarginRight: Config.lock.loginScreen.menuArea.buttons.marginRight * Config.lock.generalScale
    btnMarginBottom: Config.lock.loginScreen.menuArea.buttons.marginBottom * Config.lock.generalScale
    btnMarginLeft: Config.lock.loginScreen.menuArea.buttons.marginLeft * Config.lock.generalScale
    btnSize: Config.lock.loginScreen.menuArea.buttons.size * Config.lock.generalScale
    btnBorderRadius: Config.lock.loginScreen.menuArea.buttons.borderRadius * Config.lock.generalScale
    btnSpacing: Config.lock.loginScreen.menuArea.buttons.spacing * Config.lock.generalScale
    btnFontFamily: Config.lock.loginScreen.menuArea.buttons.fontFamily

    btnBackgroundColor: Config.lock.loginScreen.menuArea.power.backgroundColor
    btnBackgroundOpacity: Config.lock.loginScreen.menuArea.power.backgroundOpacity
    btnActiveBackgroundColor: Config.lock.loginScreen.menuArea.power.backgroundColor
    btnActiveBackgroundOpacity: Config.lock.loginScreen.menuArea.power.activeBackgroundOpacity
    contentColor: Config.lock.loginScreen.menuArea.power.contentColor
    btnContentHoveredColor: Config.lock.loginScreen.menuArea.power.btnContentHoveredColor
    activeContentColor: Config.lock.loginScreen.menuArea.popups.activeContentColor

    maxHeight: Config.lock.loginScreen.menuArea.popups.maxHeight * Config.lock.generalScale
    itemHeight: Config.lock.loginScreen.menuArea.popups.itemHeight * Config.lock.generalScale
    spacing: Config.lock.loginScreen.menuArea.popups.spacing * Config.lock.generalScale
    padding: Config.lock.loginScreen.menuArea.popups.padding * Config.lock.generalScale
    displayScrollbar: Config.lock.loginScreen.menuArea.popups.displayScrollbar
    margin: Config.lock.loginScreen.menuArea.popups.margin * Config.lock.generalScale
    backgroundColor: Config.lock.loginScreen.menuArea.popups.backgroundColor
    backgroundOpacity: Config.lock.loginScreen.menuArea.popups.backgroundOpacity
    activeOptionBackgroundColor: Config.lock.loginScreen.menuArea.popups.activeOptionBackgroundColor
    activeOptionBackgroundOpacity: Config.lock.loginScreen.menuArea.popups.activeOptionBackgroundOpacity
    fontFamily: Config.lock.loginScreen.menuArea.popups.fontFamily
    borderSize: Config.lock.loginScreen.menuArea.popups.borderSize * Config.lock.generalScale
    borderColor: Config.lock.loginScreen.menuArea.popups.borderColor
    fontSize: Config.lock.loginScreen.menuArea.popups.fontSize * Config.lock.generalScale
    iconSize: Config.lock.loginScreen.menuArea.power.iconSize * Config.lock.generalScale

    popUpDirection: Config.lock.loginScreen.menuArea.power.popupDirection
    popUpwidth: Config.lock.loginScreen.menuArea.power.popupWidth * Config.lock.generalScale

    menuModel: [
        {
            label: "Sleep",
            icon: "power-suspend.svg",
            actionStr: "suspend"
        },
        {
            label: "Reboot",
            icon: "power-reboot.svg",
            actionStr: "reboot"
        },
        {
            label: "Shutdown",
            icon: "power.svg",
            actionStr: "poweroff"
        }
    ]

    onActionTriggered: actionId => {
        Quickshell.execDetached(["systemctl", actionId]);
    }
}
