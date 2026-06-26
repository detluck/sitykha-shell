pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property string home: Quickshell.env("HOME")
    readonly property string config: `${Quickshell.env("XDG_CONFIG_HOME") || `${home}/.config`}/sitykha`
    readonly property string cache: `${Quickshell.env("XDG_CACHE_HOME") || `${home}/.cache`}/sitykha`

    function getIcon(name: string, module: string): url {
        return Qt.resolvedUrl(`qrc:/icons/${module}/${name}`);
    }

    function getImage(name: string, module: string): url {
        return Qt.resolvedUrl(`qrc:/images/${module}/${name}`);
    }

    function getWallpaper(name: string): url {
        return Qt.resolvedUrl(`root:/assets/wallpapers/${name}`);
    }

    function getFont(name: string): url {
        return Qt.resolvedUrl(`qrc:/fonts/${name}`);
    }

    function absolutePath(path: string): string {
        return path.replace(/~|(\$({?)HOME(}?))+/, home);
    }
}
