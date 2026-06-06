#include "KeyboardModel.hpp"
#include <qcontainerfwd.h>
#include <qjsonarray.h>
#include <qjsondocument.h>
#include <qjsonobject.h>
#include <qnamespace.h>
#include <qprocess.h>
#include <qregularexpression.h>
#include <qvariant.h>

namespace sitykha::models {
KeyboardModel::KeyboardModel(QObject *parent) : QObject(parent) {
  refresh();
  connectSocket();
}

QStringList KeyboardModel::layouts() const { return m_layouts; }
QString KeyboardModel::activeKeymap() const { return m_activeKeymap; }
int KeyboardModel::activeIndex() const { return m_activeIndex; }
bool KeyboardModel::capsLock() const { return m_capsLock; }
bool KeyboardModel::numLock() const { return m_numLock; }

void KeyboardModel::switchLayout(int index) {
  if (index < 0 || index >= m_layouts.size())
    return;

  QProcess::startDetached("hyprctl",
                          {"switchxkblayout", m_name, QString::number(index)});
}

void KeyboardModel::nextLayout() {
  switchLayout((m_activeIndex + 1) % m_layouts.size());
}

void KeyboardModel::refresh() {
  QProcess *process = new QProcess(this);

  connect(process, &QProcess::finished, this, [this, process]() {
    parse(process->readAllStandardOutput());
    process->deleteLater();
  });
  process->start("hyprctl", {"devices", "-j"});
}

void KeyboardModel::parse(const QByteArray &json) {
  const auto doc = QJsonDocument::fromJson(json);
  if (doc.isNull())
    return;

  const auto keyboards = doc.object()["keyboards"].toArray();
  if (keyboards.isEmpty())
    return;

  // find main keyboard, fallback to first one
  QJsonObject kb;
  for (const auto &entry : keyboards) {
    const auto obj = entry.toObject();
    if (obj["main"].toBool()) {
      kb = obj;
      break;
    }
  }
  if (kb.isEmpty())
    kb = keyboards[0].toObject();

  // parse data
  const QStringList layouts =
      kb["layouts"]
          .toString()
          .split(",", Qt::SkipEmptyParts)
          .replaceInStrings(QRegularExpression("^\\s+|\\s+$"), "");

  const QString activeKeymap = kb["active_keymap"].toString();
  const int activeIndex = kb["active_layout_index"].toInt();
  const bool capsLock = kb["capsLock"].toBool();
  const bool numLock = kb["numLock"].toBool();
  const QString name = kb["name"].toString();

  if (m_name != name)
    m_name = name;

  if (m_layouts != layouts) {
    m_layouts = layouts;
    emit layoutsChanged();
  }

  if (m_activeKeymap != activeKeymap) {
    m_activeKeymap = activeKeymap;
    emit activeKeymapChanged();
  }

  if (m_activeIndex != activeIndex) {
    m_activeIndex = activeIndex;
    emit activeIndexChanged();
  }

  if (m_capsLock != capsLock) {
    m_capsLock = capsLock;
    emit capsLockChanged();
  }

  if (m_numLock != numLock) {
    m_numLock = numLock;
    emit numLockChanged();
  }
}

void KeyboardModel::connectSocket() {}

void KeyboardModel::onSocketData() {}
} // namespace sitykha::models
