#include "PathConfig.hpp"
#include <QDir>
#include <QProcessEnvironment>
#include <QRegularExpression>

namespace sitykha::config {

PathConfig::PathConfig(QObject *parent) : ConfigObject(parent) {
  QDir().mkpath(config());
  QDir().mkpath(cache());
  QDir().mkpath(thumbnails());
}

QString PathConfig::home() const { return QDir::homePath(); }

QUrl PathConfig::getIcon(const QString &name, const QString &module) const {
  return QUrl(QString("qrc:/icons/%1/%2").arg(module, name));
}

QUrl PathConfig::getImage(const QString &name, const QString &module) const {
  return QUrl(QString("qrc:/images/%1/%2").arg(module, name));
}

QUrl PathConfig::getWallpaper(const QString &name) const {
  return QUrl(QString("root:/assets/wallpapers/%1").arg(name));
}

QUrl PathConfig::getFont(const QString &name) const {
  return QUrl(QString("qrc:/fonts/%1").arg(name));
}

QString PathConfig::absolutePath(QString path) const {
  QString homeDir = home();

  if (path.startsWith("~/")) {
    path.replace(0, 1, homeDir);
  }

  QRegularExpression re("\\$HOME|\\$\\{HOME\\}");
  path.replace(re, homeDir);

  return path;
}

QString PathConfig::resolveConfigHome() {
  QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
  QString base = env.value("XDG_CONFIG_HOME", QDir::homePath() + "/.config");
  return base + "/sitykha";
}

QString PathConfig::resolveCacheHome() {
  QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
  QString base = env.value("XDG_CACHE_HOME", QDir::homePath() + "/.cache");
  return base + "/sitykha";
}

} // namespace sitykha::config
