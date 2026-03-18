pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

/****************************************************************************
 * LockScreenConfig.qml
 *
 * This file is based on the Quickshell configuration system from:
 * https://github.com/caelestia-dots/shell
 *
 * The JsonObject structure and serialize functions were adapted
 * to store and load LockScreen and UI settings.
 *
 * Modifications:
 * - Fonts changed to JetBrainsMono / NerdFont
 * - Custom property names for LockScreen, Clock, Date, Message, etc.
 *
 ****************************************************************************/

Singleton{
    id: root

    property bool savedRecently: false

    property alias lockscreen: adapter.lockscreen


    function serializeConfig(){
        return{
            lockscreen: serializeLockscreen()
        };
    }

    function serializeLockscreen() {
        return {
            general: {
                scale: lockscreen.general.scale,
                enableAnimations: lockscreen.general.enableAnimations,
                animatedBackgroundPlaceholder: lockscreen.general.animatedBackgroundPlaceholder,
                backgroundFillMode: lockscreen.general.backgroundFillMode
            },
            lockSurface: {
                display: lockscreen.lockSurface.display,
                paddingTop: lockscreen.lockSurface.paddingTop,
                paddingRight: lockscreen.lockSurface.paddingRight,
                paddingBottom: lockscreen.lockSurface.paddingBottom,
                paddingLeft: lockscreen.lockSurface.paddingLeft,
                background: lockscreen.lockSurface.background,
                useBackgroundColor: lockscreen.lockSurface.useBackgroundColor,
                backgroundColor: lockscreen.lockSurface.backgroundColor,
                blur: lockscreen.lockSurface.blur,
                brightness: lockscreen.lockSurface.brightness,
                saturation: lockscreen.lockSurface.saturation
            },
            clock: {
                display: lockscreen.clock.display,
                position: lockscreen.clock.position,
                align: lockscreen.clock.align,
                format: lockscreen.clock.format,
                fontFamily: lockscreen.clock.fontFamily,
                fontSize: lockscreen.clock.fontSize,
                fontWeight: lockscreen.clock.fontWeight,
                color: lockscreen.clock.color
            },
            date: {
                display: lockscreen.date.display,
                format: lockscreen.date.format,
                locale: lockscreen.date.locale,
                fontFamily: lockscreen.date.fontFamily,
                fontSize: lockscreen.date.fontSize,
                fontWeight: lockscreen.date.fontWeight,
                color: lockscreen.date.color,
                marginTop: lockscreen.date.marginTop
            },
            message: {
                display: lockscreen.message.display,
                position: lockscreen.message.position,
                align: lockscreen.message.align,
                text: lockscreen.message.text,
                fontFamily: lockscreen.message.fontFamily,
                fontSize: lockscreen.message.fontSize,
                fontWeight: lockscreen.message.fontWeight,
                displayIcon: lockscreen.message.displayIcon,
                icon: lockscreen.message.icon,
                iconFontFamily: lockscreen.message.iconFontFamily,
                iconSize: lockscreen.message.iconSize,
                color: lockscreen.message.color,
                paintIcon: lockscreen.message.paintIcon,
                spacing: lockscreen.message.spacing
            },
            loginScreen: {
                background: lockscreen.loginScreen.background,
                useBackgroundColor: lockscreen.loginScreen.useBackgroundColor,
                backgroundColor: lockscreen.loginScreen.backgroundColor,
                blur: lockscreen.loginScreen.blur,
                brightness: lockscreen.loginScreen.brightness,
                saturation: lockscreen.loginScreen.saturation
            },
            loginArea: {
                position: lockscreen.loginArea.position,
                margin: lockscreen.loginArea.margin
            },
            avatar: {
                shape: lockscreen.avatar.shape,
                borderRadius: lockscreen.avatar.borderRadius,
                activeSize: lockscreen.avatar.activeSize,
                inactiveSize: lockscreen.avatar.inactiveSize,
                inactiveOpacity: lockscreen.avatar.inactiveOpacity,
                activeBorderSize: lockscreen.avatar.activeBorderSize,
                inactiveBorderSize: lockscreen.avatar.inactiveBorderSize,
                activeBorderColor: lockscreen.avatar.activeBorderColor,
                inactiveBorderColor: lockscreen.avatar.inactiveBorderColor
            },
            input: {
                width: lockscreen.input.width,
                height: lockscreen.input.height,
                displayIcon: lockscreen.input.displayIcon,
                fontFamily: lockscreen.input.fontFamily,
                fontSize: lockscreen.input.fontSize,
                icon: lockscreen.input.icon,
                iconFontFamily: lockscreen.input.iconFontFamily,
                iconSize: lockscreen.input.iconSize,
                contentColor: lockscreen.input.contentColor,
                backgroundColor: lockscreen.input.backgroundColor,
                backgroundOpacity: lockscreen.input.backgroundOpacity,
                borderSize: lockscreen.input.borderSize,
                borderColor: lockscreen.input.borderColor,
                borderRadiusLeft: lockscreen.input.borderRadiusLeft,
                borderRadiusRight: lockscreen.input.borderRadiusRight,
                marginTop: lockscreen.input.marginTop,
                maskedCharacter: lockscreen.input.maskedCharacter
            },
            loginButton: {
                backgroundColor: lockscreen.loginButton.backgroundColor,
                backgroundOpacity: lockscreen.loginButton.backgroundOpacity,
                activeBackgroundColor: lockscreen.loginButton.activeBackgroundColor,
                activeBackgroundOpacity: lockscreen.loginButton.activeBackgroundOpacity,
                icon: lockscreen.loginButton.icon,
                iconFontFamily: lockscreen.loginButton.iconFontFamily,
                iconSize: lockscreen.loginButton.iconSize,
                contentColor: lockscreen.loginButton.contentColor,
                activeContentColor: lockscreen.loginButton.activeContentColor,
                borderSize: lockscreen.loginButton.borderSize,
                borderColor: lockscreen.loginButton.borderColor,
                borderRadiusLeft: lockscreen.loginButton.borderRadiusLeft,
                borderRadiusRight: lockscreen.loginButton.borderRadiusRight,
                marginLeft: lockscreen.loginButton.marginLeft,
                showTextIfNoPassword: lockscreen.loginButton.showTextIfNoPassword,
                hideIfNotNeeded: lockscreen.loginButton.hideIfNotNeeded,
                fontFamily: lockscreen.loginButton.fontFamily,
                fontSize: lockscreen.loginButton.fontSize,
                fontWeight: lockscreen.loginButton.fontWeight
            },
            tooltips: {
                enable: lockscreen.tooltips.enable,
                fontFamily: lockscreen.tooltips.fontFamily,
                fontSize: lockscreen.tooltips.fontSize,
                contentColor: lockscreen.tooltips.contentColor,
                backgroundColor: lockscreen.tooltips.backgroundColor,
                backgroundOpacity: lockscreen.tooltips.backgroundOpacity,
                borderRadius: lockscreen.tooltips.borderRadius,
                disableUser: lockscreen.tooltips.disableUser,
                disableLoginButton: lockscreen.tooltips.disableLoginButton
            }
        };
    }

    Timer{
        id: saveTimer

        interval: 500
        onTriggered: {
            timer.restart()

            let config = {}

        }
    }

    ElapsedTimer {
        id: timer
    }


    Timer{
        id: recentlySavedTimer

        interval: 2000
        onTriggered: {
            root.savedRecently = false
        }
    }

    FileView{
        id: fileView

        path: "/home/detluck/.config/sitykha-shell/"



    }

    JsonAdapter{
        id: adapter

        property LockscreenConfig lockscreen: LockscreenConfig{}
    }
}
