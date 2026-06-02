#include "LockConfig.hpp"
#include <QFileInfo>

namespace sitykha::config {

// ==========================================
// 1. LEAF CONSTRUCTORS
// ==========================================
ClockConfig::ClockConfig(QObject *parent) : ConfigObject(parent) {}
DateConfig::DateConfig(QObject *parent) : ConfigObject(parent) {}
MessageConfig::MessageConfig(QObject *parent) : ConfigObject(parent) {}
AvatarConfig::AvatarConfig(QObject *parent) : ConfigObject(parent) {}
UsernameConfig::UsernameConfig(QObject *parent) : ConfigObject(parent) {}
PasswordInputConfig::PasswordInputConfig(QObject *parent)
    : ConfigObject(parent) {}
LoginButtonConfig::LoginButtonConfig(QObject *parent) : ConfigObject(parent) {}
SpinnerConfig::SpinnerConfig(QObject *parent) : ConfigObject(parent) {}
WarningMessageConfig::WarningMessageConfig(QObject *parent)
    : ConfigObject(parent) {}
MenuButtonsConfig::MenuButtonsConfig(QObject *parent) : ConfigObject(parent) {}
MenuPopupsConfig::MenuPopupsConfig(QObject *parent) : ConfigObject(parent) {}
MenuSessionConfig::MenuSessionConfig(QObject *parent) : ConfigObject(parent) {}
MenuLayoutConfig::MenuLayoutConfig(QObject *parent) : ConfigObject(parent) {}
MenuPowerConfig::MenuPowerConfig(QObject *parent) : ConfigObject(parent) {}
TooltipsConfig::TooltipsConfig(QObject *parent) : ConfigObject(parent) {}

// ==========================================
// 2. MID-LEVEL BRANCH CONSTRUCTORS
// ==========================================
LockScreenConfig::LockScreenConfig(QObject *parent) : ConfigObject(parent) {
  m_clock = new ClockConfig(this);
  m_date = new DateConfig(this);
  m_message = new MessageConfig(this);

  connect(m_clock, &ConfigObject::modified, this, &LockScreenConfig::modified);
  connect(m_date, &ConfigObject::modified, this, &LockScreenConfig::modified);
  connect(m_message, &ConfigObject::modified, this,
          &LockScreenConfig::modified);
}

LoginAreaConfig::LoginAreaConfig(QObject *parent) : ConfigObject(parent) {
  m_avatar = new AvatarConfig(this);
  m_username = new UsernameConfig(this);
  m_passwordInput = new PasswordInputConfig(this);
  m_loginButton = new LoginButtonConfig(this);
  m_spinner = new SpinnerConfig(this);
  m_warningMessage = new WarningMessageConfig(this);

  connect(m_avatar, &ConfigObject::modified, this, &LoginAreaConfig::modified);
  connect(m_username, &ConfigObject::modified, this,
          &LoginAreaConfig::modified);
  connect(m_passwordInput, &ConfigObject::modified, this,
          &LoginAreaConfig::modified);
  connect(m_loginButton, &ConfigObject::modified, this,
          &LoginAreaConfig::modified);
  connect(m_spinner, &ConfigObject::modified, this, &LoginAreaConfig::modified);
  connect(m_warningMessage, &ConfigObject::modified, this,
          &LoginAreaConfig::modified);
}

MenuAreaConfig::MenuAreaConfig(QObject *parent) : ConfigObject(parent) {
  m_buttons = new MenuButtonsConfig(this);
  m_popups = new MenuPopupsConfig(this);
  m_session = new MenuSessionConfig(this);
  m_layout = new MenuLayoutConfig(this);
  m_power = new MenuPowerConfig(this);

  connect(m_buttons, &ConfigObject::modified, this, &MenuAreaConfig::modified);
  connect(m_popups, &ConfigObject::modified, this, &MenuAreaConfig::modified);
  connect(m_session, &ConfigObject::modified, this, &MenuAreaConfig::modified);
  connect(m_layout, &ConfigObject::modified, this, &MenuAreaConfig::modified);
  connect(m_power, &ConfigObject::modified, this, &MenuAreaConfig::modified);
}

// ==========================================
// 3. HIGH-LEVEL BRANCH CONSTRUCTORS
// ==========================================
LoginScreenConfig::LoginScreenConfig(QObject *parent) : ConfigObject(parent) {
  m_loginArea = new LoginAreaConfig(this);
  m_menuArea = new MenuAreaConfig(this);

  connect(m_loginArea, &ConfigObject::modified, this,
          &LoginScreenConfig::modified);
  connect(m_menuArea, &ConfigObject::modified, this,
          &LoginScreenConfig::modified);
}

// ==========================================
// 4. ROOT CONSTRUCTOR
// ==========================================
LockConfig::LockConfig(QObject *parent) : ConfigObject(parent) {
  m_lockScreen = new LockScreenConfig(this);
  m_loginScreen = new LoginScreenConfig(this);
  m_tooltips = new TooltipsConfig(this);

  connect(m_lockScreen, &ConfigObject::modified, this, &LockConfig::modified);
  connect(m_loginScreen, &ConfigObject::modified, this, &LockConfig::modified);
  connect(m_tooltips, &ConfigObject::modified, this, &LockConfig::modified);
}

QString LockConfig::getIcon(const QString &iconName) const {
  if (iconName.isEmpty()) {
    return "";
  }
  if (iconName.startsWith("file://")) {
    return iconName;
  }

  QFileInfo info(iconName);
  QString finalName = iconName;

  // Clean up prefix directories if already present
  if (finalName.startsWith("backgrounds/")) {
    finalName.remove(0, 12);
  } else if (finalName.startsWith("icons/")) {
    finalName.remove(0, 6);
  }

  // If there is no extension (like .svg or .png), append .svg automatically
  if (info.suffix().isEmpty()) {
    finalName += ".svg";
  }

  QString basePath = "/home/detluck/Projects/sitykha-shell/assets/";

  // Check if file exists in backgrounds folder
  QFileInfo bgCheck(basePath + "backgrounds/" + finalName);
  if (bgCheck.exists() && bgCheck.isFile()) {
    return "file://" + basePath + "backgrounds/" + finalName;
  }

  // Otherwise assume it is in icons folder
  return "file://" + basePath + "icons/" + finalName;
}

} // namespace sitykha::config
