#pragma once

#include <QAbstractListModel>
#include <QVector>
#include <qcontainerfwd.h>
#include <qfileinfo.h>
#include <qfilesystemwatcher.h>
#include <qhashfunctions.h>
#include <qqmlintegration.h>
#include <qtmetamacros.h>
#include <qvariant.h>

namespace sitykha::models {

struct WallpaperItem {
  QString filePath;
  QString fileName;
  bool isVideo;
};

class WallpaperModel : public QAbstractListModel {
  Q_OBJECT
  QML_ANONYMOUS

public:
  enum WallpaperRoles {
    FilePathRole = Qt::UserRole + 1,
    FileNameRole,
    IsVideoRole
  };

  explicit WallpaperModel(const QString wathcedDir, QObject *parent = nullptr);

  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  QVariant data(const QModelIndex &index,
                int role = Qt::DisplayRole) const override;

protected:
  QHash<int, QByteArray> roleNames() const override;

private slots:
  void scanDir();

private:
  void setup(const QString watchedDir);
  void extractThumbnail(const WallpaperItem video);
  QString m_watchedDir;
  QVector<WallpaperItem> m_wallpapers;
  QFileSystemWatcher *m_watcher;
};
} // namespace sitykha::models
