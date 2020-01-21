import 'dart:io';

import 'package:kiwi/core/logging_service.dart';
import 'package:kiwi/core/plugin_manager.dart';
import 'package:kiwi/domain/plugin_info.dart';
import 'package:kiwi/service/default_plugin_executor.dart';
import 'package:kiwi/service/default_plugin_manager.dart';
import 'package:kiwi/service/simple_logging_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:scratch_space/scratch_space.dart';

import '../util/test_util.dart';

void main() {
  group("test_plugin_executor", () {
    String tempDir;

    setUp(() {
      var scratchSpace = new ScratchSpace();
      tempDir = scratchSpace.tempDir.path;
      GetIt.I.reset();
      GetIt.I.registerSingleton<LoggingService>(SimpleLoggingService());
      GetIt.I.registerSingleton<PluginManager>(DefaultPluginManager(tempDir));
    });

    tearDown(() {
      Directory(tempDir).delete(recursive: true);
    });

    test("test_raw_info", () async {
      var executor = DefaultPluginExecutor();

      var fileContent = await TestUtil.loadFile("default_plugin.xml");

      var result = await GetIt.I
          .get<PluginManager>()
          .install(PluginInfo("漫画堆-手机版", ""), fileContent);

      expect(result, greaterThan(0));
      var rawInfo = await executor.getRawInfoBy(result);

      expect(rawInfo.version, equals(18));

      expect(rawInfo.script.code, isNotEmpty);
    });
  });
}
