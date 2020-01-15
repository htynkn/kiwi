import 'dart:async';

import 'domain/plugin.dart';

abstract class PluginLoader {
  Future<List<Plugin>> load();
}
