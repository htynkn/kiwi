import 'dart:io';

import 'package:kiwi/core/plugin_manager.dart';
import 'package:kiwi/domain/plugin.dart';
import 'package:kiwi/domain/plugin_info.dart';

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

  @override
  Future<Plugin> getById(int id) {
    // TODO: implement getById
    return null;
  }
}
