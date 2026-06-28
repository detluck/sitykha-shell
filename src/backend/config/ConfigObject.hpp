/*
 * @file ConfigObject.hpp
 *
 * @note Architectural Reference & Attribution:
 * The foundational logic for the configuration batching was referenced and
 * adapted from the Caelestia Shell project.
 *
 * Original Source: https://github.com/caelestia-dots/shell
 *
 * Sitykha Shell Modifications:
 * - Stripped out multi-monitor and fallback routing overhead.
 * - Replaced runtime reflection-based signal wiring with compile-time parent
 * bubbling.
 * - Optimized memory footprint specifically for single-display Wayland
 * environments.
 */
#pragma once
#include <QVariant>
#include <qjsonobject.h>
#include <qloggingcategory.h>
#include <qmap.h>
#include <qobject.h>
#include <qtimer.h>
#include <type_traits>

#define CONFIG_PROPERTY(type, name, defaultVal, ...)                           \
                                                                               \
  Q_PROPERTY(type name READ name WRITE set##name NOTIFY name##Changed)         \
                                                                               \
public:                                                                        \
  [[nodiscard]] type name() const { return m_##name; }                         \
                                                                               \
  void set##name(const type &val) {                                            \
    if (sitykha::config::ConfigObject::updateMember(m_##name, val)) {          \
      Q_EMIT name##Changed();                                                  \
      notifyPropertyChanged(QStringLiteral(#name),                             \
                            QVariant::fromValue(m_##name));                    \
    }                                                                          \
  }                                                                            \
  Q_SIGNAL void name##Changed();                                               \
                                                                               \
private:                                                                       \
  type m_##name = defaultVal;

#define CONFIG_SUBOBJECT(type, name)                                           \
                                                                               \
  Q_PROPERTY(sitykha::config::type *name READ name CONSTANT)                   \
                                                                               \
public:                                                                        \
  [[nodiscard]] type *name() { return m_##name; }                              \
                                                                               \
private:                                                                       \
  type *m_##name = nullptr;

#define CONFIG_THEME_PROPERTY(type, name, emptyVal, fallbackExpr)              \
                                                                               \
  /* The Shadow Property (For  C++ Parser only) */                             \
  Q_PROPERTY(type raw_##name READ raw_##name WRITE set##name NOTIFY            \
                 raw_##name##Changed)                                          \
                                                                               \
  /* The Clean UI Property (For QML only) */                                   \
  Q_PROPERTY(type name READ name NOTIFY name##Changed)                         \
                                                                               \
public:                                                                        \
  [[nodiscard]] type raw_##name() const { return m_##name; }                   \
                                                                               \
  [[nodiscard]] type name() const {                                            \
    if (m_##name != emptyVal) {                                                \
      return m_##name;                                                         \
    }                                                                          \
    return fallbackExpr;                                                       \
  }                                                                            \
                                                                               \
  void set##name(const type &val) {                                            \
    if (sitykha::config::ConfigObject::updateMember(m_##name, val)) {          \
      Q_EMIT raw_##name##Changed();                                            \
      Q_EMIT name##Changed();                                                  \
      notifyPropertyChanged(QStringLiteral("raw_" #name),                      \
                            QVariant::fromValue(m_##name));                    \
    }                                                                          \
  }                                                                            \
  Q_SIGNAL void raw_##name##Changed();                                         \
  Q_SIGNAL void name##Changed();                                               \
                                                                               \
private:                                                                       \
  type m_##name = emptyVal;

namespace sitykha::config {

Q_DECLARE_LOGGING_CATEGORY(lcConfig)

class ConfigObject : public QObject {
  Q_OBJECT

public:
  explicit ConfigObject(QObject *parent = nullptr);

  void loadJson(const QJsonObject &obj);
  void resetThemeOverrides();
  [[nodiscard]] QJsonObject saveToJson() const;

signals:
  void modified(const QMap<QString, QVariant> &changed);

protected:
  template <typename T> static bool updateMember(T &member, const T &value) {
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
  void notifyPropertyChanged(const QString &name, const QVariant &value);

private:
  void sendChanges();
  QMap<QString, QVariant> m_pendingChanges;
  QTimer *m_batchTimer;
};
} // namespace sitykha::config
