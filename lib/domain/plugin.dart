// for installed plugin
import 'package:duoduo_cat/domain/enum/plugin_type.dart';

class Plugin {
  int id;
  PluginType pluginType;
  String name;
  String content;

  Plugin(this.id, this.name);
}
