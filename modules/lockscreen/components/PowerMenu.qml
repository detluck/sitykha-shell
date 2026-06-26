import QtQuick
import Quickshell.Io
import qs.components

CustomMenu {
    id: powerButton
    width: 40
    height: 36

    mainIcon: "power.svg"
    iconModule: "power"
    popUpDirection: "up"

    hoveredColor: "#312229"
    activeContentColor: "#f38ba8"

    menuModel: [
        {
            label: "Sleep",
            iconName: "moon.svg",
            actionStr: "suspend"
        },
        {
            label: "Reboot",
            iconName: "refresh.svg",
            actionStr: "reboot"
        },
        {
            label: "Shutdown",
            iconName: "power.svg",
            actionStr: "poweroff"
        }
    ]

    onActionTriggered: actionId => {
        console.log("Executing system action: " + actionId);

    // let cmd = "systemctl " + actionId;
    // powerProcess.command = ["sh", "-c", cmd];
    // powerProcess.start();
    }
}
