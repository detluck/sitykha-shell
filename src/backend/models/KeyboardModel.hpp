#pragma once
#include <QLocalSocket>
#include <qobject.h>
#include <qqmlintegration.h>
#include <qstring.h>
#include <qstringlist.h>
#include <qtimer.h>

namespace sitykha::models {
class KeyboardModel : public QObject {
  Q_OBJECT
  QML_ANONYMOUS

  Q_PROPERTY(QVariantList menuLayouts READ menuLayouts NOTIFY layoutsChanged)
  Q_PROPERTY(QStringList layouts READ layouts NOTIFY layoutsChanged)
  Q_PROPERTY(QString activeKeymap READ activeKeymap NOTIFY activeKeymapChanged)
  Q_PROPERTY(int activeIndex READ activeIndex NOTIFY activeIndexChanged)
  Q_PROPERTY(bool capsLock READ capsLock NOTIFY capsLockChanged)
  Q_PROPERTY(bool numLock READ numLock NOTIFY numLockChanged)

public:
  explicit KeyboardModel(QObject *parent = nullptr);
  QVariantList menuLayouts() const;
  QStringList layouts() const;
  QString activeKeymap() const;
  int activeIndex() const;
  bool capsLock() const;
  bool numLock() const;

  Q_INVOKABLE void switchLayout(int index);
  Q_INVOKABLE void nextLayout();
  Q_INVOKABLE void refresh();

signals:
  void layoutsChanged();
  void activeKeymapChanged();
  void activeIndexChanged();
  void capsLockChanged();
  void numLockChanged();

private:
  void connectSocket();
  void onSocketData();
  void parse(const QByteArray &json);

  QString m_name;
  QStringList m_layouts;
  QString m_activeKeymap;
  int m_activeIndex{0};
  bool m_capsLock{false};
  bool m_numLock{false};

  QLocalSocket *m_socket{nullptr};
  QTimer *m_reconnectTimmer{nullptr};
};
} // namespace sitykha::models
