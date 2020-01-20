import 'dart:io';

import 'package:duoduo_cat/core/logging_service.dart';
import 'package:duoduo_cat/core/plugin_manager.dart';
import 'package:duoduo_cat/domain/plugin_info.dart';
import 'package:duoduo_cat/service/default_plugin_executor.dart';
import 'package:duoduo_cat/service/default_plugin_manager.dart';
import 'package:duoduo_cat/service/simple_logging_service.dart';
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
    });

    test("test_raw_info", () async {
//      var executor = DefaultPluginExecutor();

      var fileContent = await TestUtil.loadFile("default_plugin.xml");

      var result = await GetIt.I
          .get<PluginManager>()
          .install(PluginInfo("漫画堆-手机版", ""), fileContent);

      expect(result, greaterThan(0));

//      var rawInfo = await executor.getRawInfoBy(result);
//      String response = await executor.getHots(rawInfo);
    });
  });
}
