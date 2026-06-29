#pragma once

#include "ConfigObject.hpp"
#include <qdir.h>

namespace sitykha::config {

class PathConfig : public ConfigObject {

  Q_PROPERTY(QString home READ home CONSTANT)
  CONFIG_PROPERTY(QString, config, resolveConfigHome())
  CONFIG_PROPERTY(QString, wallpapers,
                  QDir::homePath() + "/Pictures/Wallpapers")
  CONFIG_PROPERTY(QString, cache, resolveCacheHome())
  CONFIG_PROPERTY(QString, thumbnails, resolveCacheHome() + "/thumbnails")

public:
  explicit PathConfig(QObject *parent = nullptr);
  QString home() const;

  Q_INVOKABLE QUrl getIcon(const QString &name, const QString &module) const;
  Q_INVOKABLE QUrl getImage(const QString &name, const QString &module) const;
  Q_INVOKABLE QUrl getWallpaper(const QString &name) const;
  Q_INVOKABLE QUrl getFont(const QString &name) const;
  Q_INVOKABLE QString absolutePath(QString path) const;

private:
  static QString resolveConfigHome();
  static QString resolveCacheHome();
};
} // namespace sitykha::config
