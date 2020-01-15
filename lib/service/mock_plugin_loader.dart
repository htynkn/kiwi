import 'dart:io';

import 'package:duoduo_cat/domain/plugin.dart';

import '../core/plugin_loader.dart';

class MockPluginLoader extends PluginLoader {
  @override
  load() async {
    var plugin = Plugin(1, "漫画家");

    var list = List<Plugin>();

    list.add(plugin);

    sleep(const Duration(seconds: 1));

    return list;
  }
}
