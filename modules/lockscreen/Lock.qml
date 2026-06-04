pragma ComponentBehavior: Bound
import Quickshell.Wayland
import QtQuick
import qs.modules.lockscreen.components

WlSessionLock {
    id: wlLock
    locked: true
    LockContent {
        lock: wlLock
    }
}
