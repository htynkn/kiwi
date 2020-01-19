import 'dart:async';

import 'package:duoduo_cat/domain/plugin_info.dart';

import '../domain/plugin.dart';

abstract class PluginManager {
  Future<List<Plugin>> load();
  Future<void> refresh();
  Future<int> install(PluginInfo info, String xmlContent);
}
