#include "ConfigObject.hpp"
#include <QLoggingCategory>
#include <qhashfunctions.h>
#include <qjsonarray.h>
#include <qjsonvalue.h>
#include <qlogging.h>
#include <qmetaobject.h>
#include <qobject.h>
#include <qsharedpointer.h>
#include <qvariant.h>
Q_LOGGING_CATEGORY(lcConfig, "sitykha.config")

namespace sitykha::config {
ConfigObject::ConfigObject(QObject *parent)
    : QObject(parent), m_batchTimer(new QTimer(this)) {
  m_batchTimer->setSingleShot(true);
  m_batchTimer->setInterval(0);
  connect(m_batchTimer, &QTimer::timeout, this, &ConfigObject::sendChanges);

  if (auto *parentConfig = qobject_cast<ConfigObject *>(parent)) {
    connect(this, &ConfigObject::modified, parentConfig, [parentConfig](const QMap<QString, QVariant> &changes) {
      // Propagate the changes to the parent's pendingChanges map
      for (auto it = changes.constBegin(); it != changes.constEnd(); ++it) {
        parentConfig->m_pendingChanges.insert(it.key(), it.value());
      }
      parentConfig->m_batchTimer->start();
    });
  }
}

void ConfigObject::loadJson(const QJsonObject &obj) {
  const auto *meta = metaObject();

  qCDebug(lcConfig) << "Loading JSON into" << meta->className() << "with"
                    << obj.keys().size() << "keys:" << obj.keys();
  for (int i = meta->propertyOffset(); i < meta->propertyCount(); ++i) {
    QMetaProperty prop = meta->property(i);
    auto key = QString::fromUtf8(prop.name());
    if (key.startsWith("raw_")) {
      key = key.mid(4);
    }
    if (!obj.contains(key))
      continue;

    const QJsonValue jsonVal = obj.value(key);

    // Check for nested sub-objects
    QVariant currentVal = prop.read(this);
    if (currentVal.canConvert<QObject *>()) {
      if (auto *subObj = qobject_cast<sitykha::config::ConfigObject *>(
              currentVal.value<QObject *>())) {
        if (jsonVal.isObject()) {
          qCDebug(lcConfig) << "  Recursing into sub-object" << key;
          subObj->loadJson(jsonVal.toObject());
        }
        continue;
      }
    }

    if (!prop.isWritable())
      continue;

    if (jsonVal.isArray()) {
      if (prop.metaType().id() == QMetaType::QStringList) {
        QStringList list;
        const QJsonArray arr = jsonVal.toArray();
        list.reserve(arr.size());
        for (const QJsonValue &val : arr) {
          list.append(val.toString());
        }
        prop.write(this, QVariant::fromValue(list));
      } else {
        prop.write(this, jsonVal.toVariant());
      }
      continue;
    }
    prop.write(this, jsonVal.toVariant());
  }
}

QJsonObject ConfigObject::saveToJson() const {
  qDebug(lcConfig) << "Saving to Json";
  QJsonObject obj;
  const auto *meta = metaObject();
  for (int i = meta->propertyOffset(); i < meta->propertyCount(); ++i) {
    QMetaProperty prop = meta->property(i);
    auto key = QString::fromUtf8(prop.name());
    bool isShadowProperty = key.startsWith("raw_");
    if (isShadowProperty) {
      key = key.mid(4);
    }
    QVariant currentVal = prop.read(this);

    // skip if its empty ShadowProperty
    if (isShadowProperty && prop.metaType().id() == QMetaType::QString &&
        currentVal.toString().isEmpty()) {
      qDebug(lcConfig) << "Skipping shadow property";
      continue;
    }

    if (currentVal.canConvert<QObject *>()) {
      if (auto *subObj = qobject_cast<sitykha::config::ConfigObject *>(
              currentVal.value<QObject *>())) {
        QJsonObject subJson = subObj->saveToJson();
        if (!subJson.isEmpty())
          obj.insert(key, subJson);
        continue;
      }
    }

    if (!prop.isWritable())
      continue;

    if (prop.metaType().id() == QMetaType::QStringList) {
      QJsonArray arr;
      const QStringList list = currentVal.toStringList();
      for (const QString &str : list) {
        arr.append(str);
      }
      obj.insert(key, arr);
      continue;
    }
    if (prop.metaType().id() == QMetaType::QVariantList) {
      obj.insert(key, QJsonArray::fromVariantList(currentVal.toList()));
      continue;
    }
    obj.insert(key, QJsonValue::fromVariant(currentVal));
  }
  return obj;
}

void ConfigObject::notifyPropertyChanged(const QString &name,
                                         const QVariant &value) {
  m_pendingChanges.insert(name, value);
  m_batchTimer->start();
}

void ConfigObject::sendChanges() {
  if (m_pendingChanges.isEmpty()) {
    return;
  }
  auto changes = std::move(m_pendingChanges);
  m_pendingChanges.clear();
  emit modified(changes);
}

void ConfigObject::resetThemeOverrides() {
  qDebug(lcConfig) << "Reseting all properties to default theme";
  const auto *meta = metaObject();

  for (int i = meta->propertyOffset(); i < meta->propertyCount(); ++i) {
    QMetaProperty prop = meta->property(i);
    auto const key = QString::fromUtf8(prop.name());
    QVariant currentVal = prop.read(this);

    if (currentVal.canConvert<QObject *>()) {
      if (auto *subObj =
              qobject_cast<ConfigObject *>(currentVal.value<QObject *>())) {
        subObj->resetThemeOverrides();
      }
      continue;
    }
    if (key.startsWith("raw_") && prop.isWritable()) {
      if (prop.metaType().id() == QMetaType::QString) {
        prop.write(this, "");
      } else if (prop.metaType().id() == QMetaType::Double) {
        prop.write(this, -1.0);
      } else if (prop.metaType().id() == QMetaType::Int) {
        prop.write(this, -1);
      }
    }
  }
}

void sitykha::config::ConfigObject::refreshThemeBindings() {
  const auto *meta = metaObject();

  for (int i = meta->propertyOffset(); i < meta->propertyCount(); ++i) {
    QMetaProperty prop = meta->property(i);
    QString name = QString::fromUtf8(prop.name());

    QVariant currentVal = prop.read(this);
    if (currentVal.canConvert<QObject *>()) {
      if (auto *subObj =
              qobject_cast<ConfigObject *>(currentVal.value<QObject *>())) {
        subObj->refreshThemeBindings();
      }
      continue;
    }

    if (name.startsWith("raw_")) {
      // 1. Invoke the notify signal of the raw shadow property (e.g. raw_colorChanged)
      if (prop.hasNotifySignal()) {
        prop.notifySignal().invoke(this, Qt::DirectConnection);
      }

      // 2. Retrieve and invoke the notify signal of the clean property (e.g. colorChanged)
      QString cleanName = name.mid(4);
      int cleanPropIdx = meta->indexOfProperty(cleanName.toUtf8().constData());
      if (cleanPropIdx != -1) {
        QMetaProperty cleanProp = meta->property(cleanPropIdx);
        if (cleanProp.hasNotifySignal()) {
          cleanProp.notifySignal().invoke(this, Qt::DirectConnection);
        }
      }
    }
  }
}
} // namespace sitykha::config
