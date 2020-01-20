import 'dart:io';

import 'package:duoduo_cat/core/logging_service.dart';
import 'package:duoduo_cat/domain/plugin_info.dart';
import 'package:duoduo_cat/service/default_plugin_manager.dart';
import 'package:duoduo_cat/service/simple_logging_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:scratch_space/scratch_space.dart';
import '../util/test_util.dart';

void main() {
  group("default_plugin_manager", () {
    String tempDir;

    setUpAll(() {
      GetIt.I.reset();
      GetIt.I.registerSingleton<LoggingService>(SimpleLoggingService());
    });

    setUp(() {
      var scratchSpace = new ScratchSpace();
      tempDir = scratchSpace.tempDir.path;
    });

    tearDown(() {
      Directory(tempDir).delete(recursive: true);
    });

    test("test_install", () async {
      var manager = DefaultPluginManager(tempDir);

      var list = await manager.load();

      expect(list, isNotNull);
      expect(list.length, equals(0));

      var fileContent = await TestUtil.loadFile("default_plugin.xml");
      var result =
          await manager.install(PluginInfo("漫画堆-手机版", ""), fileContent);

      expect(result, greaterThan(0));

      list = await manager.load();

      expect(list, isNotNull);
      expect(list.length, greaterThan(0));
    });

    test("test_reinstall", () async {
      var manager = DefaultPluginManager(tempDir);

      var list = await manager.load();

      expect(list, isNotNull);
      expect(list.length, equals(0));

      var fileContent = await TestUtil.loadFile("default_plugin.xml");
      var result =
          await manager.install(PluginInfo("漫画堆-手机版", ""), fileContent);

      expect(result, greaterThan(0));

      list = await manager.load();

      expect(list, isNotNull);
      expect(list.length, equals(1));

      var newResult =
          await manager.install(PluginInfo("漫画堆-手机版", ""), fileContent);

      expect(newResult, equals(result));

      list = await manager.load();

      expect(list.length, equals(1));
    });

    test("test_get_by_id", () async {
      var manager = DefaultPluginManager(tempDir);

      var list = await manager.load();

      expect(list, isNotNull);
      expect(list.length, equals(0));

      var fileContent = await TestUtil.loadFile("default_plugin.xml");
      var result =
          await manager.install(PluginInfo("漫画堆-手机版", ""), fileContent);

      expect(result, greaterThan(0));

      var plugin = await manager.getById(result);

      expect(plugin.id, equals(result));
      expect(plugin.name, equals("漫画堆-手机版"));
    });
  });
}
