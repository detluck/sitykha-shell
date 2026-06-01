#pragma once
#include "ConfigObject.hpp"
#include <optional>
#include <qfilesystemwatcher.h>
#include <qobjectdefs.h>
#include <qqmlengine.h>
#include <qtimer.h>
#include <qtmetamacros.h>

namespace sitykha::config {
class LockConfig;
// class BarConfig;
} // namespace sitykha::config

namespace sitykha::config {

class Config : public ConfigObject {
  Q_OBJECT
  QML_ELEMENT
  QML_SINGLETON

  Q_MOC_INCLUDE("LockConfig.hpp")

  CONFIG_SUBOBJECT(LockConfig, lock)

public:
  explicit Config(QObject *parent = nullptr);

  static Config *instance();
  static Config *create(QQmlEngine *, QJSEngine *);

  void setup(const QString &filePath);

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
};
} // namespace sitykha::config
