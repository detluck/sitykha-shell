pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtMultimedia
import Quickshell.Services.Pam
import Quickshell.Wayland
import Sitykha.Backend
import qs.services

WlSessionLockSurface {
    id: root

    color: "#000000"

    required property WlSessionLock lock
    property bool capsLockOn: false
    property real blur: 0.0
    property real brightness: 0.0
    property real saturation: 0.0

    PamContext {
        id: pamContext
        config: "login"
    }

    FocusScope {
        id: mainFrame
        anchors.fill: parent
        focus: true

        state: Config.lock.lockScreen.display ? "lockState" : "loginState"

        states: [
            State {
                name: "lockState"
                PropertyChanges {
                    target: lockScreen
                    opacity: 1.0
                }
                PropertyChanges {
                    target: loginScreen
                    opacity: 0.0
                }
                PropertyChanges {
                    target: loginScreen.loginContainer
                    scale: 0.5
                }
                PropertyChanges {
                    target: root
                    blur: Config.lock.lockScreen.blur / Math.max(Config.lock.lockScreen.blur, Config.lock.loginScreen.blur, 1)
                    brightness: Config.lock.lockScreen.brightness
                    saturation: Config.lock.lockScreen.saturation
                }
            },
            State {
                name: "loginState"
                PropertyChanges {
                    target: lockScreen
                    opacity: 0.0
                }
                PropertyChanges {
                    target: loginScreen
                    opacity: 1.0
                }
                PropertyChanges {
                    target: loginScreen.loginContainer
                    scale: 1.0
                }
                PropertyChanges {
                    target: root
                    blur: Config.lock.loginScreen.blur / Math.max(Config.lock.lockScreen.blur, Config.lock.loginScreen.blur, 1)
                    brightness: Config.lock.loginScreen.brightness
                    saturation: Config.lock.loginScreen.saturation
                }
            }
        ]

        transitions: Transition {
            enabled: Config.lock.enableAnimations
            PropertyAnimation {
                properties: "opacity"
                duration: 150
            }
            PropertyAnimation {
                properties: "blur,brightness,saturation"
                duration: 400
            }
        }

        Item {
            id: backgroundManager
            anchors.fill: parent

            readonly property string currentSource: mainFrame.state === "lockState" ? Config.lock.lockScreen.background : Config.lock.loginScreen.background
            readonly property bool isVideo: {
                if (currentSource.length === 0)
                    return false;
                var parts = currentSource.split(".");
                if (parts.length === 0)
                    return false;
                var ext = parts[parts.length - 1].toLowerCase();
                return ["avi", "mp4", "mov", "mkv", "m4v", "webm"].indexOf(ext) !== -1;
            }
            readonly property bool displayColor: mainFrame.state === "lockState" && Config.lock.lockScreen.useBackgroundColor || mainFrame.state === "loginState" && Config.lock.loginScreen.useBackgroundColor
            readonly property string placeholder: Config.lock.animatedBackgroundPlaceholder

            Image {
                id: backgroundImage
                anchors.fill: parent
                source: !backgroundManager.isVideo ? Pathes.getWallpaper(backgroundManager.currentSource || "default.jpg") : ""
                cache: true
                mipmap: true
                visible: !backgroundManager.displayColor && !backgroundManager.isVideo
                fillMode: {
                    if (Config.lock.backgroundFillMode === "stretch")
                        return Image.Stretch;
                    if (Config.lock.backgroundFillMode === "fit")
                        return Image.PreserveAspectFit;
                    return Image.PreserveAspectCrop;
                }
                onStatusChanged: {
                    if (status === Image.Error) {
                        var fallback = Pathes.getWallpaper("default.jpg");
                        if (source !== fallback && source !== "") {
                            source = fallback;
                        }
                    }
                }
            }

            Rectangle {
                id: backgroundColorLayer
                anchors.fill: parent
                // root.state DURCH mainFrame.state ERSETZT
                color: mainFrame.state === "lockState" && Config.lock.lockScreen.useBackgroundColor ? Config.lock.lockScreen.backgroundColor : mainFrame.state === "loginState" && Config.lock.loginScreen.useBackgroundColor ? Config.lock.loginScreen.backgroundColor : "black"
                visible: backgroundManager.displayColor || (backgroundVideoOutput.visible && backgroundManager.placeholder.length === 0)
            }

            MediaPlayer {
                id: backgroundMediaPlayer
                videoOutput: backgroundVideoOutput
                audioOutput: AudioOutput {
                    muted: true
                }
                source: backgroundManager.isVideo && backgroundManager.currentSource.length > 0 ? Pathes.getWallpaper(backgroundManager.currentSource) : ""
                loops: MediaPlayer.Infinite
                onSourceChanged: {
                    if (source.toString().length > 0) {
                        backgroundMediaPlayer.play();
                    }
                }
            }

            VideoOutput {
                id: backgroundVideoOutput
                anchors.fill: parent
                visible: backgroundManager.isVideo && !backgroundManager.displayColor
                fillMode: {
                    if (Config.lock.backgroundFillMode === "stretch")
                        return VideoOutput.Stretch;
                    if (Config.lock.backgroundFillMode === "fit")
                        return VideoOutput.PreserveAspectFit;
                    return VideoOutput.PreserveAspectCrop;
                }
            }

            Component.onDestruction: {
                backgroundMediaPlayer.stop();
            }
        }

        MultiEffect {
            id: backgroundEffect
            source: backgroundManager
            anchors.fill: parent
            blurEnabled: Math.max(Config.lock.lockScreen.blur, Config.lock.loginScreen.blur) > 0
            blur: root.blur
            blurMax: Math.max(Config.lock.lockScreen.blur, Config.lock.loginScreen.blur)
            brightness: root.brightness
            saturation: root.saturation
            autoPaddingEnabled: false
        }

        FocusScope {
            id: screenContainer
            anchors.fill: parent
            focus: true

            LockScreen {
                id: lockScreen
                z: mainFrame.state === "lockState" ? 2 : 1
                anchors.fill: parent
                focus: mainFrame.state === "lockState"
                enabled: mainFrame.state === "lockState"
                capsLockOn: root.capsLockOn
                onCapsLockToggled: root.capsLockOn = !root.capsLockOn

                onLoginRequested: {
                    mainFrame.state = "loginState";
                    loginScreen.resetFocus();
                }
            }

            LoginScreen {
                id: loginScreen
                z: mainFrame.state === "loginState" ? 2 : 1
                anchors.fill: parent
                enabled: mainFrame.state === "loginState"
                opacity: 0.0
                capsLockOn: root.capsLockOn
                pamAuth: pamContext
                onCapsLockToggled: root.capsLockOn = !root.capsLockOn

                onClose: {
                    mainFrame.state = "lockState";
                }
                onUnlockRequested: {
                    root.lock.locked = false;
                }
            }
        }
    }
}
