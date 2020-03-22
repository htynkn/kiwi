enum PluginProviderType { Sited, Ka94, File }

class PluginProviderTypeHelper {
  static String getValue(PluginProviderType type) {
    switch (type) {
      case PluginProviderType.Sited:
        return "Sited官方插件中心";
      case PluginProviderType.Ka94:
        return "Ka94独立插件中心";
      case PluginProviderType.File:
        return "本地文件";
      default:
        return "";
    }
  }

  static PluginProviderType fromValue(String value) {
    if (PluginProviderType.Sited.toString() == value) {
      return PluginProviderType.Sited;
    } else if (PluginProviderType.Ka94.toString() == value) {
      return PluginProviderType.Ka94;
    } else {
      return PluginProviderType.File;
    }
  }
}
