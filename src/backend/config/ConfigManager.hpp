#pragma once
#include "ConfigObject.hpp"
#include <optional>
#include <qfilesystemwatcher.h>
#include <qobjectdefs.h>
#include <qqmlengine.h>
#include <qtimer.h>
#include <qtmetamacros.h>

namespace sitykha::models {
class WallpaperModel;
class KeyboardModel;
} // namespace sitykha::models
namespace sitykha::config {

class LockConfig;
class PathConfig;
class GlobalThemeConfig;

class Config : public ConfigObject {
  Q_OBJECT
  QML_ELEMENT
  QML_SINGLETON

  Q_MOC_INCLUDE("lock/LockConfig.hpp")
  Q_MOC_INCLUDE("appearance/GlobalThemeConfig.hpp")
  Q_MOC_INCLUDE("pathes/PathConfig.hpp")
  Q_MOC_INCLUDE("models/KeyboardModel.hpp")
  Q_MOC_INCLUDE("models/WallpaperModel.hpp")

  Q_PROPERTY(sitykha::models::WallpaperModel *wallpaperModel READ wallpaperModel
                 CONSTANT)
  Q_PROPERTY(
      sitykha::models::KeyboardModel *keyboardModel READ keyboardModel CONSTANT)
  CONFIG_SUBOBJECT(GlobalThemeConfig, theme)
  CONFIG_SUBOBJECT(LockConfig, lock)
  CONFIG_SUBOBJECT(PathConfig, pathes)

public:
  explicit Config(QObject *parent = nullptr);

  static Config *instance();
  static Config *create(QQmlEngine *, QJSEngine *);

  void setup(const QString &filePath);
  sitykha::models::WallpaperModel *wallpaperModel() const {
    return m_wallpaperModel;
  }
  sitykha::models::KeyboardModel *keyboardModel() const {
    return m_keyboardModel;
  }
public slots:
  void save();
  void reload();

signals:
  void saved();
  void reloaded();
  void errorOccurred(const QString &errMsg);

private slots:
  void executeSave();
  void executeReload();
  void onWatcherEvent();
  void updateFileWatch();

private:
  std::optional<QString> reloadFromFile;
  QString m_filePath;
  QString m_watchedDir;
  QFileSystemWatcher *m_watcher{nullptr};

  // timers
  QTimer *m_saveTimer{nullptr};
  QTimer *m_reloadTimer{nullptr};
  QTimer *m_cooldownTimer{nullptr};
  QTimer *m_retryTimer{nullptr};

  bool m_recentlySaved{false};
  int m_parseRetries{0};
  bool m_loading{false};

  // models
  sitykha::models::WallpaperModel *m_wallpaperModel = nullptr;
  sitykha::models::KeyboardModel *m_keyboardModel = nullptr;
};
} // namespace sitykha::config
