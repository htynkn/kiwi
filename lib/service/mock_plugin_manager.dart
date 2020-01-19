import 'dart:io';

import 'package:duoduo_cat/core/plugin_manage.dart';
import 'package:duoduo_cat/domain/plugin.dart';
import 'package:duoduo_cat/domain/plugin_info.dart';

class MockPluginManager extends PluginManager {
  @override
  load() async {
    var plugin = Plugin(1, "漫画家");

    var list = List<Plugin>();

    list.add(plugin);

    sleep(const Duration(seconds: 1));

    return list;
  }

  @override
  Future<int> install(PluginInfo info, String xmlContent) async {
    // TODO: implement install
    return null;
  }

  @override
  Future<void> refresh() {
    // TODO: implement refresh
    return null;
  }
}
