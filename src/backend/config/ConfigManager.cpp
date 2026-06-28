#include "ConfigManager.hpp"
#include "ConfigObject.hpp"
#include "appearance/GlobalThemeConfig.hpp"
#include "lock/LockConfig.hpp"
#include "qdebug.h"
#include "qdir.h"
#include "qfileinfo.h"
#include <qdebug.h>
#include <qfiledevice.h>
#include <qjsondocument.h>
#include <qjsonobject.h>
#include <qjsonparseerror.h>
#include <qvariant.h>

namespace sitykha::config {
Q_LOGGING_CATEGORY(lcConfig, "sitykha.config")
static Config *s_instance = nullptr;

Config *Config::instance() {
  if (!s_instance) {
    s_instance = new Config();
  }
  return s_instance;
}

Config *Config::create(QQmlEngine *, QJSEngine *) { return instance(); }

Config::Config(QObject *parent) : ConfigObject(parent) {
  if (!s_instance) {
    s_instance = this;
  }

  m_theme = new GlobalThemeConfig(this);
  m_lock = new LockConfig(this);

  connect(this, &ConfigObject::modified, this, &Config::save);
  setup(QDir::homePath() + "/.config/sitykha/shell.json");
}

void Config::setup(const QString &path) {
  m_filePath = path;

  QFileInfo fileInfo(m_filePath);
  m_watchedDir = fileInfo.absolutePath();

  QDir dir;
  if (!dir.exists(m_watchedDir)) {
    dir.mkpath(m_watchedDir);
  }

  m_watcher = new QFileSystemWatcher(this);
  m_watcher->addPath(m_watchedDir);
  if (QFile::exists(m_filePath)) {
    m_watcher->addPath(m_filePath);
  }
  connect(m_watcher, &QFileSystemWatcher::directoryChanged, this,
          &Config::onWatcherEvent);
  connect(m_watcher, &QFileSystemWatcher::fileChanged, this,
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

void Config::save() {
  if (!m_loading) {
    m_saveTimer->start();
  }
}

void Config::reload() {
  m_parseRetries = 0;
  m_saveTimer->stop();
  executeReload();
}

void Config::executeReload() {
  if (m_filePath.isEmpty())
    return;

  QFile file(m_filePath);
  if (!file.exists()) {
    save();
    return;
  }

  if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
    emit errorOccurred("Failed to read config: " + file.errorString());
    qDebug(lcConfig) << "Failed to read config: " << file.errorString();
    return;
  }

  QByteArray data = file.readAll();
  if (data.isEmpty()) {
    if (m_parseRetries < 3) {
      m_parseRetries++;
      m_retryTimer->start();
      return;
    }
    emit errorOccurred("Config is empty after multipe retries");
    qDebug(lcConfig) << "Config is empty";
    return;
  }

  QJsonParseError error;
  QJsonDocument doc = QJsonDocument::fromJson(data, &error);

  if (error.error != QJsonParseError::NoError) {
    if (m_parseRetries < 3) {
      m_parseRetries++;
      m_retryTimer->start();
      return;
    }
    emit errorOccurred("Json parse error: " + error.errorString());
    qDebug(lcConfig) << "Json parse error: " << error.errorString();
    return;
  }

  m_loading = true;
  this->loadJson(doc.object());
  m_loading = false;

  m_parseRetries = 0;
  emit reloaded();
}

void Config::executeSave() {
  if (m_filePath.isEmpty() || m_loading)
    return;

  QFileInfo fileInfo(m_filePath);
  QDir().mkpath(fileInfo.absolutePath());

  QJsonObject obj = this->saveToJson();
  QJsonDocument doc(obj);

  QFile file(m_filePath);
  if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
    emit errorOccurred("Failed to write config: " + file.errorString());
    qDebug(lcConfig) << "Failed to write config: " << file.errorString();
    return;
  }

  m_recentlySaved = true;

  file.write(doc.toJson(QJsonDocument::Indented));
  file.close();

  updateFileWatch();

  emit saved();
  m_cooldownTimer->start();
}

void Config::updateFileWatch() {
  QStringList dirs = m_watcher->directories();
  if (!dirs.contains(m_watchedDir)) {
    m_watcher->addPath(m_watchedDir);
  }
  QStringList files = m_watcher->files();
  if (QFile::exists(m_filePath) && !files.contains(m_filePath)) {
    m_watcher->addPath(m_filePath);
  }
}

void Config::onWatcherEvent() {
  if (m_recentlySaved)
    return;
  updateFileWatch();
  m_reloadTimer->start();
}

} // namespace sitykha::config
