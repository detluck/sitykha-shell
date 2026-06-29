pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import "modules/lockscreen"
import Sitykha.Backend

ShellRoot {
    id: root

    // Load fonts globally from resource compilation
    FontLoader {
        source: Config.pathes.getFont("redhat/RedHatDisplay-Regular.otf")
    }
    FontLoader {
        source: Config.pathes.getFont("redhat/RedHatDisplay-Medium.otf")
    }
    FontLoader {
        source: Config.pathes.getFont("redhat/RedHatDisplay-SemiBold.otf")
    }
    FontLoader {
        source: Config.pathes.getFont("redhat/RedHatDisplay-Bold.otf")
    }
    FontLoader {
        source: Config.pathes.getFont("redhat/RedHatDisplay-Black.otf")
    }

    Lock {}
}
