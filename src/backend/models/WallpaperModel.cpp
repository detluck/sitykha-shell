#include "WallpaperModel.hpp"
#include <qabstractitemmodel.h>
#include <qcontainerfwd.h>
#include <qdir.h>
#include <qdiriterator.h>
#include <qfileinfo.h>
#include <qfilesystemwatcher.h>
#include <qobject.h>
#include <qprocess.h>
#include <qvariant.h>

namespace sitykha::models {

WallpaperModel::WallpaperModel(const QString watchedDir, QObject *parent)
    : QAbstractListModel(parent) {
  setup(watchedDir);
}

void WallpaperModel::setup(const QString watchedDir) {
  m_watchedDir = watchedDir;

  QDir dir;
  if (!dir.exists(watchedDir)) {
    dir.mkpath(m_watchedDir);
  }

  m_watcher = new QFileSystemWatcher(this);
  m_watcher->addPath(m_watchedDir);

  connect(m_watcher, &QFileSystemWatcher::directoryChanged, this,
          &WallpaperModel::scanDir);
  scanDir();
}

void WallpaperModel::scanDir() {
  beginResetModel();

  m_wallpapers.clear();

  QStringList filters = {"*.jpg", "*.jpeg", "*.png", "*.mp4", "*.webm"};
  QDirIterator it(m_watchedDir, filters, QDir::Files,
                  QDirIterator::NoIteratorFlags);

  while (it.hasNext()) {
    it.next();
    QFileInfo info = it.fileInfo();

    WallpaperItem wallpaper;
    QString name = info.baseName();
    wallpaper.filePath = info.absoluteFilePath();
    wallpaper.fileName = name;
    wallpaper.isVideo = (info.suffix() == "mp4" || info.suffix() == "webm");

    if (wallpaper.isVideo) {
      extractThumbnail(wallpaper);
    }

    m_wallpapers.append(wallpaper);
  }
  endResetModel();
}

void WallpaperModel::extractThumbnail(const WallpaperItem video) {
  QString cacheDir = QDir::homePath() + "/.cache/sitykha/thumbnails/";
  QString targetThumb = cacheDir + video.fileName + ".jpg";

  QDir dir;
  if (!dir.exists(cacheDir))
    dir.mkpath(cacheDir);
  if (!QFileInfo::exists(targetThumb)) {
    qDebug() << "[sitykha.model] NEW VIDEO FOUND. Extracting thumbnail for:"
             << video.fileName;

    // Run ffmpeg silently
    QProcess ffmpeg;
    QStringList args;
    args << "-ss" << "00:00:01"
         << "-i" << video.filePath << "-vframes" << "1" << targetThumb << "-y";

    ffmpeg.start("ffmpeg", args);
    ffmpeg.waitForFinished();

    qDebug() << "[sitykha.model] Extraction finished. Status:"
             << ffmpeg.exitStatus();
  } else {
    qDebug() << "[sitykha.model] CACHE HIT. Thumbnail already exists for:"
             << video.fileName;
  }
}

int WallpaperModel::rowCount(const QModelIndex &parent) const {
  if (parent.isValid())
    return 0;
  return static_cast<int>(m_wallpapers.count());
}

QHash<int, QByteArray> WallpaperModel::roleNames() const {
  return {{FilePathRole, "filePath"},
          {FileNameRole, "fileName"},
          {IsVideoRole, "isVideo"}};
}

QVariant WallpaperModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid() || index.row() >= m_wallpapers.count())
    return QVariant();

  const WallpaperItem &wallpaper = m_wallpapers[index.row()];

  switch (role) {
  case FilePathRole:
    return wallpaper.filePath;
  case FileNameRole:
    return wallpaper.fileName;
  case IsVideoRole:
    return wallpaper.isVideo;
  default:
    return QVariant();
  }
}

} // namespace sitykha::models
