enum PluginProviderType { Sited, Ka94 }

class PluginProviderTypeHelper {
  static String getValue(PluginProviderType type) {
    switch (type) {
      case PluginProviderType.Sited:
        return "Sited官方插件中心";
      case PluginProviderType.Ka94:
        return "Ka94独立插件中心";
      default:
        return "";
    }
  }

  static PluginProviderType fromValue(String value) {
    if (PluginProviderType.Sited.toString() == value) {
      return PluginProviderType.Sited;
    } else {
      return PluginProviderType.Ka94;
    }
  }
}
