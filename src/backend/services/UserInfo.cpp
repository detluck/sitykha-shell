#include "UserInfo.hpp"
#include <pwd.h>
#include <qobject.h>
#include <unistd.h>

namespace sitykha::services {

UserInfo::UserInfo(QObject *parent) : QObject(parent) {
  const uid_t uid = getuid();
  const passwd *pw = getpwuid(uid);
  if (pw) {
    m_userName = QString::fromLocal8Bit(pw->pw_name);

    // The GECOS field may contain multiple comma-separated values, with the
    // real name being the first one.
    const QString gecos = QString::fromLocal8Bit(pw->pw_gecos);
    m_realName = gecos.split(",").first().trimmed();

    // fallback to username if real name is empty
    if (m_realName.isEmpty()) {
      m_realName = m_userName;
    }
  }
}

QString UserInfo::userName() const { return m_userName; }

QString UserInfo::realName() const { return m_realName; }

} // namespace sitykha::services
