import '../domain/plugin_info.dart';

abstract class PluginProvider {
  Future<List<PluginInfo>> search(String keyword);
  Future<List<PluginInfo>> list(int pageNum, int pageSize);
}
