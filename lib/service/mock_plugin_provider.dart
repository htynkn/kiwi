import 'package:duoduo_cat/domain/plugin_info.dart';

import '../core/plugin_provider.dart';

class MockPluginProvider extends PluginProvider {
  @override
  list(int pageNum, int pageSize) async {
    List<PluginInfo> plugins = List();
    return plugins;
  }

  @override
  search(String keyword) async {
    return null;
  }
}
