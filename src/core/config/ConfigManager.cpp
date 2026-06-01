#include "ConfigManager.hpp"
#include "qdir.h"
#include "qfileinfo.h"

void sitykha::config::Config::setup(const QString &path) {
  m_filePath = path;

  QFileInfo fileInfo(m_filePath);
  m_watchedDir = fileInfo.absolutePath();

  QDir dir;
  if (!dir.exists(m_watchedDir)) {
    dir.mkpath(m_watchedDir);
  }

  m_watcher = new QFileSystemWatcher(this);
  m_watcher->addPath(m_watchedDir);
  connect(m_watcher, &QFileSystemWatcher::directoryChanged, this,
          &Config::onWatcherEvent);

  m_saveTimer = new QTimer(this);
  m_saveTimer->setSingleShot(true);
  m_saveTimer->setInterval(500);
  connect(m_saveTimer, &QTimer::timeout, this, &Config::executeSave);

  m_reloadTimer = new QTimer(this);
  m_reloadTimer->setSingleShot(true);
  m_reloadTimer->setInterval(100);
  connect(m_reloadTimer, &QTimer::timeout, this, &Config::executeReload);

  m_retryTimer = new QTimer(this);
  m_retryTimer->setSingleShot(true);
  m_retryTimer->setInterval(50);
  connect(m_retryTimer, &QTimer::timeout, this, &Config::executeReload);

  m_cooldownTimer = new QTimer(this);
  m_cooldownTimer->setSingleShot(true);
  m_cooldownTimer->setInterval(2000);
  connect(m_cooldownTimer, &QTimer::timeout, this,
          [this]() { m_recentlySaved = false; });

  this->reload();
}
