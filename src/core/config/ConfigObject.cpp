#include "ConfigObject.hpp"
#include <qmetaobject.h>
#include <qjsonarray.h>
#include <qjsonvalue.h>
#include <QLoggingCategory>
Q_LOGGING_CATEGORY(lcConfig, "sitykha.config")

sitykha::config::ConfigObject::ConfigObject(QObject *parent)
    : QObject(parent), m_batchTimer(new QTimer(this))
{
    m_batchTimer->setSingleShot(true);
    m_batchTimer->setInterval(0);
    connect(m_batchTimer, &QTimer::timeout, this, &ConfigObject::sendChanges);

    if(auto* parentConfig = qobject_cast<ConfigObject*>(parent)) {
        connect(this, &ConfigObject::modified,
            parentConfig, [parentConfig]() {
            // Tell the parent something changed down the tree
            parentConfig->m_batchTimer->start();
        });
    }
}

void sitykha::config::ConfigObject::loadJson(const QJsonObject &obj)
{
    const auto* meta = metaObject();

    qCDebug(lcConfig) << "Loading JSON into" << meta->className() << "with" << obj.keys().size()
                      << "keys:" << obj.keys();
    for(int i = meta->propertyOffset(); i<meta->propertyCount(); ++i){
        QMetaProperty prop = meta->property(i);
        QString key = QString::fromUtf8(prop.name());

        if(!obj.contains(key)) continue;

        const QJsonValue jsonVal = obj.value(key);

        //Check for nested sub-objects
        QVariant currentVal = prop.read(this);
        if (auto* subObj = currentVal.value<sitykha::config::ConfigObject*>()) {
            if (jsonVal.isObject()) {
                qCDebug(lcConfig) << "  Recursing into sub-object" << key;
                subObj->loadJson(jsonVal.toObject());
            }
            continue;
        }

        if(!prop.isWritable()) continue;

        if(jsonVal.isArray()){
            if(prop.metaType().id() == QMetaType::QStringList){
                QStringList list;
                const QJsonArray arr = jsonVal.toArray();
                list.reserve(arr.size());
                for(const QJsonValue& val: arr){
                    list.append(val.toString());
                }
                prop.write(this, QVariant::fromValue(list));
            }
            else{
                prop.write(this, jsonVal.toVariant());
            }
            continue;
        }
        prop.write(this, jsonVal.toVariant());
    }
}

QJsonObject sitykha::config::ConfigObject::saveToJson() const
{
    qDebug(lcConfig) << "Saving to Json";
    QJsonObject obj;
    const auto* meta = metaObject();
    for(int i = meta->propertyOffset(); i < meta->propertyCount(); ++i ){
        QMetaProperty prop = meta->property(i);
        const auto key = QString::fromUtf8(prop.name());
        QVariant currentVal = prop.read(this);
        if (auto* subObj = currentVal.value<sitykha::config::ConfigObject*>()) {
            QJsonObject subJson = subObj->saveToJson();
            if(!subJson.isEmpty()) obj.insert(key, subJson);
            continue;
        }

        if(!prop.isWritable()) continue;

        if(prop.metaType().id() == QMetaType::QStringList){
            QJsonArray arr;
            const QStringList list = currentVal.toStringList();
            for(const QString& str: list){
                arr.append(str);
            }
            obj.insert(key, arr);
            continue;
        }
        if(prop.metaType().id() == QMetaType::QVariantList){
            obj.insert(key, QJsonArray::fromVariantList(currentVal.toList()));
            continue;
        }
        obj.insert(key, QJsonValue::fromVariant(currentVal));
    }
    return obj;
}

void sitykha::config::ConfigObject::notifyPropertyChanged(const QString &name, const QVariant &value)
{
    m_pendingChanges.insert(name, value);
    m_batchTimer->start();
}

void sitykha::config::ConfigObject::sendChanges()
{
    if(m_pendingChanges.isEmpty()){
        return;
    }
    auto changes = std::move(m_pendingChanges);
    m_pendingChanges.clear();
    emit modified(changes);
}
