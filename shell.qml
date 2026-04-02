import QtQuick
import Quickshell
import Quickshell.Services.Pam
import "modules/lockscreen"
ShellRoot {
    id: root

    // 1. The PAM Authentication Context
    // Functions exactly the same as the real lock screen.
    Lockscreen{
    }
}
