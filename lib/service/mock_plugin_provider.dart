import '../core/plugin_provider.dart';

class MockPluginProvider extends PluginProvider {
  @override
  list(int pageNum, int pageSize) async {
    return List();
  }

  @override
  search(String keyword) async {
    return null;
  }
}
