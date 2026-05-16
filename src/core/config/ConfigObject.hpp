/**
 * @file ConfigObject.hpp
 *
 * @note Architectural Reference & Attribution:
 * The foundational logic for the configuration batching, Qt MetaObject JSON
 * serialization, and floating-point type traits was referenced and adapted
 * from the Caelestia Shell project.
 *
 * Original Source: https://github.com/caelestia-dots/shell
 *
 * Sitykha Shell Modifications:
 * - Stripped out multi-monitor and fallback routing overhead.
 * - Replaced runtime reflection-based signal wiring with compile-time parent bubbling.
 * - Optimized memory footprint specifically for single-display Wayland environments.
 */
#pragma once
#include <qjsonobject.h>
#include <qloggingcategory.h>
#include <qobject.h>
#include <qmap.h>
#include <qtimer.h>
#include <QVariant>
#include <type_traits>

#define CONFIG_PROPERTY(type, name, defaultVal, ...)                                \
                                                                                    \
  Q_PROPERTY(type name READ name WRITE set##name NOTIFY name##Changed)              \
                                                                                    \
public:                                                                             \
  [[nodiscard]] type name() const { return m_##name; }                              \
                                                                                    \
  void set##name(const type &val) {                                                 \
    if(sitykha::config::ConfigObject::updateMember(m_##name, val)){                 \
        Q_EMIT name##Changed();                                                     \
        notifyPropertyChanged(QStringLiteral(#name), QVariant::fromValue(m_##name));\
    }                                                                               \
  }                                                                                 \
  Q_SIGNAL void name##Changed();                                                    \
                                                                                    \
private:                                                                            \
  type m_##name __VA_OPT__(= __VA_ARGS__);                                          \

#define CONFIG_SUBOBJECT(type, name)                                                \
                                                                                    \
  Q_PROPERTY(sitykha::config::type *name READ name CONSTANT)                        \
                                                                                    \
public:                                                                             \
  [[nodiscard]] type* name() { return &m_##name; }                                  \
                                                                                    \
private:                                                                            \
    type m_##name{this};                                                            \

namespace sitykha::config {

Q_DECLARE_LOGGING_CATEGORY(lcConfig)

class ConfigObject : public QObject {
  Q_OBJECT

public:
  explicit ConfigObject(QObject *parent = nullptr);

    void loadJson(const QJsonObject &obj);
    [[nodiscard]] QJsonObject saveToJson() const;

signals:
    void modified(const QMap<QString, QVariant>& changed);

protected:
    template <typename T> static bool updateMember(T& member, const T& value){
        if constexpr (std::is_floating_point_v<T>) {
            if (qFuzzyCompare(member + 1.0, value + 1.0))
                return false;
        } else {
            if (member == value)
                return false;
        }
        member = value;
        return true;
    }
    void notifyPropertyChanged(const QString& name, const QVariant& value);

private:
    void sendChanges();
    QMap<QString, QVariant> m_pendingChanges;
    QTimer* m_batchTimer;

};
} // namespace sitykha::config
