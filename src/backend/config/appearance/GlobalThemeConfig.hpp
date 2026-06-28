#pragma once
#include "../ConfigObject.hpp"
#include <QtQml/qqmlregistration.h>

namespace sitykha::config {
using namespace Qt::Literals::StringLiterals;

class GlobalThemeConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS

  // mode
  CONFIG_PROPERTY(QString, mode, u"dark"_s)

  // base palette
  CONFIG_PROPERTY(QString, base, u"1e1e2e"_s)
  CONFIG_PROPERTY(QString, mantle, u"181825"_s)
  CONFIG_PROPERTY(QString, crust, u"11111b"_s)

  // surface overlay
  CONFIG_PROPERTY(QString, surface0, u"313244"_s)
  CONFIG_PROPERTY(QString, surface1, u"45475a"_s)
  CONFIG_PROPERTY(QString, surface2, u"585b70"_s)

  CONFIG_PROPERTY(QString, overlay0, u"6c7086"_s)
  CONFIG_PROPERTY(QString, overlay1, u"7f849c"_s)
  CONFIG_PROPERTY(QString, overlay2, u"9399b2"_s)

  // text
  CONFIG_PROPERTY(QString, text, u"cdd6f4"_s)
  CONFIG_PROPERTY(QString, subtext0, u"a6adc8"_s)
  CONFIG_PROPERTY(QString, subtext1, u"bac2de"_s)

  // accent colors
  CONFIG_PROPERTY(QString, rosewater, u"f5e0dc"_s)
  CONFIG_PROPERTY(QString, flamingo, u"f2cdcd"_s)
  CONFIG_PROPERTY(QString, pink, u"f5c2e7"_s)
  CONFIG_PROPERTY(QString, mauve, u"cba6f7"_s)
  CONFIG_PROPERTY(QString, red, u"f38ba8"_s)
  CONFIG_PROPERTY(QString, maroon, u"eba0ac"_s)
  CONFIG_PROPERTY(QString, peach, u"fab387"_s)
  CONFIG_PROPERTY(QString, yellow, u"f9e2af"_s)
  CONFIG_PROPERTY(QString, green, u"a6e3a1"_s)
  CONFIG_PROPERTY(QString, teal, u"94e2d5"_s)
  CONFIG_PROPERTY(QString, sky, u"89dceb"_s)
  CONFIG_PROPERTY(QString, sapphire, u"74c7ec"_s)
  CONFIG_PROPERTY(QString, blue, u"89b4fa"_s)
  CONFIG_PROPERTY(QString, lavender, u"b4befe"_s)

  // roles
  CONFIG_PROPERTY(QString, primary, u"cba6f7"_s)        // mauve
  CONFIG_PROPERTY(QString, onPrimary, u"1e1e2e"_s)      // base
  CONFIG_PROPERTY(QString, secondary, u"89b4fa"_s)      // blue
  CONFIG_PROPERTY(QString, onSecondary, u"1e1e2e"_s)    // base
  CONFIG_PROPERTY(QString, accent, u"cba6f7"_s)         // mauve
  CONFIG_PROPERTY(QString, surface, u"1e1e2e"_s)        // base
  CONFIG_PROPERTY(QString, onSurface, u"cdd6f4"_s)      // text
  CONFIG_PROPERTY(QString, surfaceVariant, u"313244"_s) // surface0
  CONFIG_PROPERTY(QString, outline, u"585b70"_s)        // surface2
  CONFIG_PROPERTY(QString, error, u"f38ba8"_s)          // red
  CONFIG_PROPERTY(QString, onError, u"1e1e2e"_s)        // base
  CONFIG_PROPERTY(QString, success, u"a6e3a1"_s)        // green
  CONFIG_PROPERTY(QString, warning, u"f9e2af"_s)        // yellow

  // appearance
  CONFIG_PROPERTY(int, radiusSmall, 8)
  CONFIG_PROPERTY(int, radiusMedium, 12)
  CONFIG_PROPERTY(int, radiusLarge, 20)
  CONFIG_PROPERTY(int, paddingSmall, 6)
  CONFIG_PROPERTY(int, paddingMedium, 12)
  CONFIG_PROPERTY(int, paddingLarge, 20)
  CONFIG_PROPERTY(int, borderWidth, 1)
  CONFIG_PROPERTY(double, opacity, 0.85)

  // font
  CONFIG_PROPERTY(QString, fontFamily, u"Inter"_s)
  CONFIG_PROPERTY(int, fontSizeSmall, 12)
  CONFIG_PROPERTY(int, fontSizeMedium, 14)
  CONFIG_PROPERTY(int, fontSizeLarge, 16)

  // animation duration in ms
  CONFIG_PROPERTY(int, durationShort, 150)
  CONFIG_PROPERTY(int, durationMedium, 250)
  CONFIG_PROPERTY(int, durationLong, 400)

public:
  explicit GlobalThemeConfig(QObject *parent = nullptr);

  static GlobalThemeConfig *instance();
};

} // namespace sitykha::config
