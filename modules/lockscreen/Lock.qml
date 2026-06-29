pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import qs.modules.lockscreen.components

Scope {
    id: lockController

    IpcHandler {
        target: "wlLock"

        function lock(): void {
            lockLoader.active = true;
        }
    }

    Loader {
        id: lockLoader
        active: false

        sourceComponent: WlSessionLock {
            id: wlLock
            locked: true

            LockContent {
                lock: wlLock
            }

            onLockedChanged: {
                if (!locked) {
                    lockLoader.active = false;
                }
            }
        }
    }
}
