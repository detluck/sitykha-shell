pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtMultimedia
import Quickshell.Services.Pam
import Sitykha.Core
import "components"

Window {
    id: root

    width: 1920
    height: 1080
    visible: true
    title: "Sitykha Shell - Lock Container Test"
    color: "#000000"

    // Diese Properties bleiben im Window, da sie globale Werte für den MultiEffect sind
    property bool capsLockOn: false
    property real blurMax: 0.0
    property real brightness: 0.0
    property real saturation: 0.0

    PamContext {
        id: pamContext
        config: "login"
    }

    // Main surface frame
    Item {
        id: mainFrame
        anchors.fill: parent

        // 1. STATE LOGIK HIERHER VERSCHOBEN
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
                    blurMax: Config.lock.lockScreen.blur
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
                    blurMax: Config.lock.loginScreen.blur
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
                properties: "blurMax,brightness,saturation"
                duration: 400
            }
        }

        Item {
            id: backgroundManager
            anchors.fill: parent

            // 2. root.state DURCH mainFrame.state ERSETZT
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
            // root.state DURCH mainFrame.state ERSETZT
            readonly property bool displayColor: mainFrame.state === "lockState" && Config.lock.lockScreen.useBackgroundColor || mainFrame.state === "loginState" && Config.lock.loginScreen.useBackgroundColor
            readonly property string placeholder: Config.lock.animatedBackgroundPlaceholder

            Image {
                id: backgroundImage
                anchors.fill: parent
                source: !backgroundManager.isVideo ? Config.lock.getIcon(backgroundManager.currentSource) : ""
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
                        if (source !== "backgrounds/default.jpg" && source !== "") {
                            source = "backgrounds/default.jpg";
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
                source: backgroundManager.isVideo && backgroundManager.currentSource.length > 0 ? Config.getIcon(backgroundManager.currentSource) : ""
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
            blurEnabled: root.blurMax > 0
            blur: root.blurMax > 0 ? 1.0 : 0.0
            brightness: root.brightness
            saturation: root.saturation
            autoPaddingEnabled: false
        }

        Item {
            id: screenContainer
            anchors.fill: parent

            LockScreen {
                id: lockScreen
                // 3. root.state DURCH mainFrame.state ERSETZT
                z: mainFrame.state === "lockState" ? 2 : 1
                anchors.fill: parent
                focus: mainFrame.state === "lockState"
                enabled: mainFrame.state === "lockState"
                capsLockOn: root.capsLockOn

                onLoginRequested: {
                    mainFrame.state = "loginState";
                    loginScreen.resetFocus();
                }
            }

            LoginScreen {
                id: loginScreen
                // 3. root.state DURCH mainFrame.state ERSETZT
                z: mainFrame.state === "loginState" ? 2 : 1
                anchors.fill: parent
                enabled: mainFrame.state === "loginState"
                opacity: 0.0
                capsLockOn: root.capsLockOn
                pamAuth: pamContext

                onClose: {
                    mainFrame.state = "lockState";
                }
                onUnlockRequested: {
                    console.log("Authentication complete. Testing pipeline closing window safely.");
                    root.close();
                }
            }
        }
    }
}
