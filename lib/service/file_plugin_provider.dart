import 'dart:io';

import 'package:kiwi/core/logging_service.dart';
import 'package:kiwi/core/plugin_provider.dart';
import 'package:kiwi/domain/plugin_info.dart';

class FilePluginProvider extends PluginProvider {
  LoggingService logging;

  FilePluginProvider(this.logging);

  @override
  Future<String> download(String url) async {
    var file = File(url);

    var xmlContent = file.readAsStringSync();

    return Future.value(xmlContent);
  }

  @override
  Future<List<PluginInfo>> list(int pageNum, int pageSize) async {
    return Future.value(List());
  }

  @override
  Future<List<PluginInfo>> search(String keyword) async {
    return Future.value(List());
  }
}
