pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import "modules/lockscreen"
import "services"

ShellRoot {
    id: root

    // Load fonts globally from resource compilation
    FontLoader {
        source: Pathes.getFont("redhat/RedHatDisplay-Regular.otf")
    }
    FontLoader {
        source: Pathes.getFont("redhat/RedHatDisplay-Medium.otf")
    }
    FontLoader {
        source: Pathes.getFont("redhat/RedHatDisplay-SemiBold.otf")
    }
    FontLoader {
        source: Pathes.getFont("redhat/RedHatDisplay-Bold.otf")
    }
    FontLoader {
        source: Pathes.getFont("redhat/RedHatDisplay-Black.otf")
    }

    Lock {}
}
