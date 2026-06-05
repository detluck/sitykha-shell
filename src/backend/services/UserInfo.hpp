#pragma once

#include <qobject.h>
#include <qqmlintegration.h>
#include <qstring.h>
#include <qtmetamacros.h>

namespace sitykha::services {
class UserInfo : public QObject {
  Q_OBJECT
  QML_ELEMENT
  QML_SINGLETON

  Q_PROPERTY(QString userName READ userName CONSTANT)
  Q_PROPERTY(QString realName READ realName CONSTANT)

public:
  explicit UserInfo(QObject *parent = nullptr);

  QString userName() const;
  QString realName() const;

private:
  QString m_userName;
  QString m_realName;
};
} // namespace sitykha::services
