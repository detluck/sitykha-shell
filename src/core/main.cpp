#include <QDebug>
#include <QDir>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "config/ConfigManager.hpp"

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);

  QString configPath = QDir::homePath() + "/.config/sitykha/shell.json";
  qDebug() << "Initializing Sitykha Config at:" << configPath;

  auto *config = sitykha::config::Config::instance();
  config->setup(configPath);

  config->save();

  QQmlApplicationEngine engine;

  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
      []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);

  return app.exec();
}
