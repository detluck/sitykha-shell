pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import qs.modules.lockscreen.components

Scope {
    id: lockController

    WlSessionLock {
        id: wlLock

        LockContent {
            lock: wlLock
        }
    }

    IpcHandler {
        target: "wlLock"

        function lock(): void {
            wlLock.locked = true;
        }
    }
}
