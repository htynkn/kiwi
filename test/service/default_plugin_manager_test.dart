import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/domain/plugin_info.dart';
import 'package:kiwi/service/default_plugin_manager.dart';
import 'package:kiwi/service/simple_logging_service.dart';
import 'package:scratch_space/scratch_space.dart';

import '../util/test_util.dart';

void main() {
  group("default_plugin_manager", () {
    String tempDir;
    var manager;
    setUp(() {
      var scratchSpace = new ScratchSpace();
      tempDir = scratchSpace.tempDir.path;

      manager = DefaultPluginManager(SimpleLoggingService(), path: tempDir);
    });

    tearDown(() {
      Directory(tempDir).delete(recursive: true);
    });

    test("test_install", () async {
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
