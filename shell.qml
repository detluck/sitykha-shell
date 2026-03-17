import QtQuick
import Quickshell
import Quickshell.Services.Pam

ShellRoot {
    id: root

    // 1. The PAM Authentication Context
    // Functions exactly the same as the real lock screen.
    PamContext {
        id: pamAuth

        Component.onCompleted: start()

        onCompleted: {
            console.log("Authentication successful! Test passed.")
            // Instead of unlocking a Wayland session, we just quit the app to simulate a successful unlock.
            Qt.quit() 
        }

        
        onError: (error) => {
            console.log("Authentication failed! Check your password.")
        }
    }

    // 2. The Multi-Monitor Repeater
    // Still loops through all your screens, but creates normal windows instead of lock surfaces.
    FloatingWindow {
        // Using standard windows for safe testing
        width: 800
        height: 600

        // Background color applied directly to the window
        color: "#1e1e2e"

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "Safe Mode Lock Screen"
                color: "white"
                font.pixelSize: 24
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                width: 300
                height: 50
                color: "#313244"
                radius: 10

                TextInput {
                    anchors.fill: parent
                    anchors.margins: 10
                    verticalAlignment: TextInput.AlignVCenter
                    color: "white"
                    font.pixelSize: 20
                    echoMode: TextInput.Password
                    focus: true

                    onAccepted: {
                        // Trigger PAM check
                        console.log("Attempting login...")
                        pamAuth.respond(text)
                        text = "" // Clear the field
                    }
                }
            }
        }
    }
}
