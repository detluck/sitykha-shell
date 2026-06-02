pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pam
import Sitykha.Core

Item {
    id: loginScreen

    required property PamContext pamAuth

    signal close
    signal toggleLayoutPopup
    signal unlockRequested

    property bool capsLockOn: false

    state: "normal"
    property bool stateChanging: false
    function safeStateChange(newState) {
        if (!stateChanging) {
            stateChanging = true;
            state = newState;
            stateChanging = false;
        }
    }

    onStateChanged: {
        if (state === "normal") {
            resetFocus();
        }
    }

    readonly property alias password: password
    readonly property alias loginButton: loginButton
    readonly property alias loginContainer: loginContainer

    // --- SINGLE USER CONFIGURATION ---
    property string userName: "detluck"
    property string userRealName: "Pavlo Sytnyk"
    property bool userNeedsPassword: true

    // --- QUICKSHELL PAM LOGIN LOGIC ---
    function login() {
        if (userName !== "" && password.text !== "") {
            safeStateChange("authenticating");

            // Start the PAM conversation
            if (!pamAuth.active) {
                pamAuth.user = userName;
                pamAuth.start();
            }
        }
    }

    Connections {
        target: loginScreen.pamAuth

        // 1. PAM sends a message or asks for input
        function onPamMessage() {
            if (loginScreen.pamAuth.responseRequired) {
                // PAM is asking for the password, give it to them
                loginScreen.pamAuth.respond(password.text);
            } else if (loginScreen.pamAuth.message !== "") {
                // PAM just wants to show a message (like "Welcome" or a warning)
                if (loginScreen.pamAuth.messageIsError) {
                    loginMessage.warn(loginScreen.pamAuth.message, "error");
                } else {
                    loginMessage.warn(loginScreen.pamAuth.message, "warning");
                }
            }
        }

        // 2. PAM finishes processing the password
        function onCompleted(result) {
            if (result === PamResult.Success) {
                loginContainer.scale = 0.0;
                loginScreen.unlockRequested();
            } else {
                loginScreen.safeStateChange("normal");
                loginMessage.warn("Incorrect password", "error");
                password.text = "";
                password.input.forceActiveFocus();
            }
        }

        // 3. System-level PAM error (missing config, root permission issue, etc.)
        function onError(error) {
            loginScreen.safeStateChange("normal");
            loginMessage.warn("Internal PAM Error", "error");
            password.text = "";
        }
    }

    function updateCapsLock() {
        if (loginScreen.capsLockOn && loginScreen.state !== "authenticating") {
            loginMessage.warn("Caps Lock is on", "warning");
        } else {
            loginMessage.clear();
        }
    }

    function resetFocus() {
        if (loginScreen.userNeedsPassword) {
            password.input.forceActiveFocus();
        } else {
            loginButton.forceActiveFocus();
        }
    }

    // --- UI LAYOUT ---
    Item {
        id: loginContainer

        width: Config.lock.loginScreen.loginArea.position === "left" || Config.lock.loginScreen.loginArea.position === "right" ? (Config.lock.loginScreen.loginArea.avatar.activeSize + Config.lock.loginScreen.loginArea.username.margin + loginArea.width) : loginLayout.width

        height: childrenRect.height
        scale: 0.5

        Behavior on scale {
            enabled: Config.lock.enableAnimations
            NumberAnimation {
                duration: 200
            }
        }

        Component.onCompleted: {
            if (Config.lock.loginScreen.loginArea.position === "left") {
                anchors.verticalCenter = parent.verticalCenter;
                if (Config.lock.loginScreen.loginArea.margin === -1) {
                    anchors.horizontalCenter = parent.horizontalCenter;
                } else {
                    anchors.left = parent.left;
                    anchors.leftMargin = Config.lock.loginScreen.loginArea.margin;
                }
            } else if (Config.lock.loginScreen.loginArea.position === "right") {
                anchors.verticalCenter = parent.verticalCenter;
                if (Config.lock.loginScreen.loginArea.margin === -1) {
                    anchors.horizontalCenter = parent.horizontalCenter;
                } else {
                    anchors.right = parent.right;
                    anchors.rightMargin = Config.lock.loginScreen.loginArea.margin;
                }
            } else {
                anchors.horizontalCenter = parent.horizontalCenter;
                if (Config.lock.loginScreen.loginArea.margin === -1) {
                    anchors.verticalCenter = parent.verticalCenter;
                } else {
                    anchors.top = parent.top;
                    anchors.topMargin = Config.lock.loginScreen.loginArea.margin;
                }
            }
        }

        Item {
            id: loginLayout
            height: activeUserName.height + Config.lock.loginScreen.loginArea.passwordInput.marginTop + loginArea.height
            width: loginArea.width > activeUserName.width ? loginArea.width : activeUserName.width

            Component.onCompleted: {
                if (Config.lock.loginScreen.loginArea.position === "left") {
                    anchors.verticalCenter = parent.verticalCenter;
                    anchors.left = parent.left;
                } else if (Config.lock.loginScreen.loginArea.position === "right") {
                    anchors.verticalCenter = parent.verticalCenter;
                    anchors.right = parent.right;
                } else {
                    anchors.top = parent.top;
                    anchors.horizontalCenter = parent.horizontalCenter;
                }
            }

            Text {
                id: activeUserName
                font.family: Config.lock.loginScreen.loginArea.username.fontFamily
                font.weight: Config.lock.loginScreen.loginArea.username.fontWeight
                font.pixelSize: Config.lock.loginScreen.loginArea.username.fontSize * Config.lock.generalScale
                color: Config.lock.loginScreen.loginArea.username.color
                text: loginScreen.userRealName || loginScreen.userName

                Component.onCompleted: {
                    anchors.top = parent.top;
                    if (Config.lock.loginScreen.loginArea.position === "left") {
                        anchors.left = parent.left;
                    } else if (Config.lock.loginScreen.loginArea.position === "right") {
                        anchors.right = parent.right;
                    } else {
                        anchors.horizontalCenter = parent.horizontalCenter;
                    }
                }
            }

            RowLayout {
                id: loginArea
                height: Config.lock.loginScreen.loginArea.passwordInput.height * Config.lock.generalScale
                spacing: Config.lock.loginScreen.loginArea.loginButton.marginLeft
                visible: loginScreen.state !== "authenticating"

                Component.onCompleted: {
                    anchors.top = activeUserName.bottom;
                    anchors.topMargin = Config.lock.loginScreen.loginArea.passwordInput.marginTop;
                    if (Config.lock.loginScreen.loginArea.position === "left") {
                        anchors.left = parent.left;
                    } else if (Config.lock.loginScreen.loginArea.position === "right") {
                        anchors.right = parent.right;
                    } else {
                        anchors.horizontalCenter = parent.horizontalCenter;
                    }
                }

                Input {
                    id: password
                    Layout.alignment: Qt.AlignHCenter
                    enabled: loginScreen.state === "normal"
                    visible: loginScreen.userNeedsPassword
                    icon: "file:///home/detluck/Projects/sitykha-shell/assets/icons/" + (Config.lock.loginScreen.loginArea.passwordInput.icon || "password.svg")
                    eyeIconCl: "file:///home/detluck/Projects/sitykha-shell/assets/icons/eye-cl.svg"
                    eyeIconO: "file:///home/detluck/Projects/sitykha-shell/assets/icons/eye-o.svg"
                    placeholder: "Password"
                    isPassword: true
                    splitBorderRadius: true
                    onAccepted: {
                        loginScreen.login();
                    }
                    Component.onCompleted: input.forceActiveFocus()
                }

                IconButton {
                    id: loginButton
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: width
                    height: password.height
                    visible: !Config.lock.loginScreen.loginArea.loginButton.hideIfNotNeeded || !loginScreen.userNeedsPassword
                    enabled: loginScreen.state !== "authenticating"
                    activeFocusOnTab: true
                    icon: "file:///home/detluck/Projects/sitykha-shell/assets/icons/" + (Config.lock.loginScreen.loginArea.loginButton.icon || "arrow-right.svg")
                    label: "Login"
                    showLabel: Config.lock.loginScreen.loginArea.loginButton.showTextIfNoPassword && !loginScreen.userNeedsPassword
                    tooltipText: !Config.lock.tooltips.disableLoginButton && (!Config.lock.loginScreen.loginArea.loginButton.showTextIfNoPassword || loginScreen.userNeedsPassword) ? "Login" : ""

                    iconSize: Config.lock.loginScreen.loginArea.loginButton.iconSize
                    fontFamily: Config.lock.loginScreen.loginArea.loginButton.fontFamily
                    fontSize: Config.lock.loginScreen.loginArea.loginButton.fontSize
                    fontWeight: Config.lock.loginScreen.loginArea.loginButton.fontWeight
                    contentColor: Config.lock.loginScreen.loginArea.loginButton.contentColor
                    activeContentColor: Config.lock.loginScreen.loginArea.loginButton.activeContentColor
                    backgroundColor: Config.lock.loginScreen.loginArea.loginButton.backgroundColor
                    backgroundOpacity: Config.lock.loginScreen.loginArea.loginButton.backgroundOpacity
                    activeBackgroundColor: Config.lock.loginScreen.loginArea.loginButton.activeBackgroundColor
                    activeBackgroundOpacity: Config.lock.loginScreen.loginArea.loginButton.activeBackgroundOpacity
                    borderSize: Config.lock.loginScreen.loginArea.loginButton.borderSize
                    borderColor: Config.lock.loginScreen.loginArea.loginButton.borderColor
                    borderRadiusLeft: password.visible ? Config.lock.loginScreen.loginArea.loginButton.borderRadiusLeft : Config.lock.loginScreen.loginArea.loginButton.borderRadiusRight
                    borderRadiusRight: Config.lock.loginScreen.loginArea.loginButton.borderRadiusRight

                    onClicked: loginScreen.login()

                    Behavior on x {
                        enabled: Config.lock.enableAnimations
                        NumberAnimation {
                            duration: 150
                        }
                    }
                }
            }

            Spinner {
                id: spinner
                visible: loginScreen.state === "authenticating"
                opacity: visible ? 1.0 : 0.0

                Component.onCompleted: {
                    anchors.top = activeUserName.bottom;
                    anchors.topMargin = Config.lock.loginScreen.loginArea.passwordInput.marginTop;
                    if (Config.lock.loginScreen.loginArea.position === "left") {
                        anchors.left = parent.left;
                    } else if (Config.lock.loginScreen.loginArea.position === "right") {
                        anchors.right = parent.right;
                    } else {
                        anchors.horizontalCenter = parent.horizontalCenter;
                    }
                }
            }

            Text {
                id: loginMessage
                property bool capslockWarning: false
                font.pixelSize: Config.lock.loginScreen.loginArea.warningMessage.fontSize * Config.lock.generalScale
                font.family: Config.lock.loginScreen.loginArea.warningMessage.fontFamily
                font.weight: Config.lock.loginScreen.loginArea.warningMessage.fontWeight
                color: Config.lock.loginScreen.loginArea.warningMessage.normalColor
                visible: text !== "" && loginScreen.state !== "authenticating" && (capslockWarning ? loginScreen.userNeedsPassword : true)
                opacity: visible ? 1.0 : 0.0
                anchors.top: loginArea.bottom
                anchors.topMargin: visible ? Config.lock.loginScreen.loginArea.warningMessage.marginTop : 0

                Component.onCompleted: {
                    if (loginScreen.capsLockOn)
                        loginMessage.warn("Caps Lock is on", "warning");

                    if (Config.lock.loginScreen.loginArea.position === "left") {
                        anchors.left = parent.left;
                    } else if (Config.lock.loginScreen.loginArea.position === "right") {
                        anchors.right = parent.right;
                    } else {
                        anchors.horizontalCenter = parent.horizontalCenter;
                    }
                }

                Behavior on anchors.topMargin {
                    enabled: Config.lock.enableAnimations
                    NumberAnimation {
                        duration: 150
                    }
                }
                Behavior on opacity {
                    enabled: Config.lock.enableAnimations
                    NumberAnimation {
                        duration: 150
                    }
                }

                function warn(message, type) {
                    clear();
                    text = message;
                    color = type === "error" ? Config.lock.loginScreen.loginArea.warningMessage.errorColor : (type === "warning" ? Config.lock.loginScreen.loginArea.warningMessage.warningColor : Config.lock.loginScreen.loginArea.warningMessage.normalColor);
                    if (message === "Caps Lock is on")
                        capslockWarning = true;
                }

                function clear() {
                    text = "";
                    capslockWarning = false;
                }
            }
        }
    }

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Escape) {
            if (loginScreen.state === "authenticating") {
                event.accepted = false;
                return;
            }
            if (Config.lock.lockScreen.display) {
                loginScreen.close();
            }
            password.text = "";
        } else if (event.key === Qt.Key_CapsLock) {
            loginScreen.capsLockOn = !loginScreen.capsLockOn;
        }
        event.accepted = true;
    }

    MouseArea {
        z: -1
        anchors.fill: parent
        hoverEnabled: true
    }
}
