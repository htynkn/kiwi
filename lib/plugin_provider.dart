import 'domain/plugin_info.dart';

abstract class PluginProvider {
  List<PluginInfo> search(String keyword);
  List<PluginInfo> list(int pageNum, int pageSize);
}
