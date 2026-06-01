#pragma once

#include "ConfigObject.hpp"
#include <QString>
#include <qqmlintegration.h>

namespace sitykha::config {

// ==========================================
// 1. CLOCK CONFIGURATION
// ==========================================
class LockClockConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS

  CONFIG_PROPERTY(bool, display, true)
  CONFIG_PROPERTY(QString, position, QStringLiteral("top-center"))
  CONFIG_PROPERTY(QString, align, QStringLiteral("center"))

  CONFIG_PROPERTY(QString, format, QStringLiteral("hh:mm"))
  CONFIG_PROPERTY(QString, fontFamily, QStringLiteral("RedHatDisplay"))
  CONFIG_PROPERTY(int, fontSize, 70)
  CONFIG_PROPERTY(int, fontWeight, 900)

  CONFIG_PROPERTY(QString, color, QStringLiteral("#cdd6f4"))

public:
  explicit LockClockConfig(QObject *parent = nullptr) : ConfigObject(parent) {}
};

// ==========================================
// 2. DATE CONFIGURATION
// ==========================================
class LockDateConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS

  CONFIG_PROPERTY(bool, display, true)
  CONFIG_PROPERTY(QString, format, QStringLiteral("dddd, MMMM dd, yyyy"))
  CONFIG_PROPERTY(QString, locale, QStringLiteral("en_US"))

  CONFIG_PROPERTY(QString, fontFamily, QStringLiteral("RedHatDisplay"))
  CONFIG_PROPERTY(int, fontSize, 14)
  CONFIG_PROPERTY(int, fontWeight, 600)
  CONFIG_PROPERTY(int, marginTop, -15)

  CONFIG_PROPERTY(QString, color, QStringLiteral("#cdd6f4"))

public:
  explicit LockDateConfig(QObject *parent = nullptr) : ConfigObject(parent) {}
};

// ==========================================
// 3. MESSAGE CONFIGURATION
// ==========================================
class LockMessageConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS

  CONFIG_PROPERTY(bool, display, true)
  CONFIG_PROPERTY(QString, position, QStringLiteral("bottom-center"))
  CONFIG_PROPERTY(QString, align, QStringLiteral("center"))
  CONFIG_PROPERTY(QString, text, QStringLiteral("Press any key"))

  CONFIG_PROPERTY(QString, fontFamily, QStringLiteral("RedHatDisplay"))
  CONFIG_PROPERTY(int, fontSize, 12)
  CONFIG_PROPERTY(int, fontWeight, 400)

  CONFIG_PROPERTY(bool, displayIcon, true)
  CONFIG_PROPERTY(QString, icon, QStringLiteral("catppuccin.png"))
  CONFIG_PROPERTY(int, iconSize, 16)
  CONFIG_PROPERTY(bool, paintIcon, false)

  CONFIG_PROPERTY(QString, color, QStringLiteral("#cdd6f4"))
  CONFIG_PROPERTY(int, spacing, 0)

public:
  explicit LockMessageConfig(QObject *parent = nullptr)
      : ConfigObject(parent) {}
};

// ==========================================
// MAIN LOCKSCREEN CONFIGURATION
// ==========================================
class LockConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS

  CONFIG_PROPERTY(bool, display, true)
  CONFIG_PROPERTY(int, paddingTop, 0)
  CONFIG_PROPERTY(int, paddingRight, 0)
  CONFIG_PROPERTY(int, paddingBottom, 0)
  CONFIG_PROPERTY(int, paddingLeft, 0)

  CONFIG_PROPERTY(QString, background, QStringLiteral("sunset.jpg"))
  CONFIG_PROPERTY(bool, useBackgroundColor, false)
  CONFIG_PROPERTY(QString, backgroundColor, QStringLiteral("#1e1e2e"))

  CONFIG_PROPERTY(int, blur, 0)
  CONFIG_PROPERTY(double, brightness, 0.0)
  CONFIG_PROPERTY(double, saturation, 0.0)

  CONFIG_SUBOBJECT(LockClockConfig, clock)
  CONFIG_SUBOBJECT(LockDateConfig, date)
  CONFIG_SUBOBJECT(LockMessageConfig, message)

public:
  explicit LockConfig(QObject *parent = nullptr) : ConfigObject(parent) {}
};

} // namespace sitykha::config
