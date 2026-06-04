pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import "modules/lockscreen"

ShellRoot {
    id: root

    // 1. The PAM Authentication Context
    // Functions exactly the same as the real lock screen.
    Lock {}
}
