#include "GlobalThemeConfig.hpp"

namespace sitykha::config {

static GlobalThemeConfig *s_instance = nullptr;

GlobalThemeConfig::GlobalThemeConfig(QObject *parent) : ConfigObject(parent) {
  s_instance = this;
}

GlobalThemeConfig *GlobalThemeConfig::instance() { return s_instance; }
} // namespace sitykha::config
