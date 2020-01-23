import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:kiwi/core/logging_service.dart';
import 'package:kiwi/core/plugin_manager.dart';
import 'package:kiwi/domain/plugin_info.dart';
import 'package:kiwi/service/default_plugin_executor.dart';
import 'package:kiwi/service/default_plugin_manager.dart';
import 'package:kiwi/service/simple_logging_service.dart';
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

      expect(rawInfo.script.requireList, isNotEmpty);
      expect(rawInfo.script.requireList[0], isNotEmpty);
    });

    test("test_raw_info_issue_1", () async {
      var executor = DefaultPluginExecutor();

      var fileContent = await TestUtil.loadFile("issue_1_plugin.xml");

      var result = await GetIt.I
          .get<PluginManager>()
          .install(PluginInfo("东方二次元", ""), fileContent);

      expect(result, greaterThan(0));
      var rawInfo = await executor.getRawInfoBy(result);

      expect(rawInfo.version, equals(3));

      expect(rawInfo.meta.title, equals("东方二次元"));

      expect(rawInfo.script.code, isNotEmpty);

      expect(rawInfo.script.requireList, isNotEmpty);
      expect(rawInfo.script.requireList[0], isNotEmpty);

      expect(rawInfo.main.book, isNotNull);
      expect(rawInfo.main.book.method, isNotEmpty);

      expect(rawInfo.main.section, isNotNull);
      expect(rawInfo.main.section.parse, isNotEmpty);
    });

    test("test_raw_info_issue_2", () async {
      var executor = DefaultPluginExecutor();

      var fileContent = await TestUtil.loadFile("issue_2_plugin.xml");

      var result = await GetIt.I
          .get<PluginManager>()
          .install(PluginInfo("naver网漫", ""), fileContent);

      expect(result, greaterThan(0));
      var rawInfo = await executor.getRawInfoBy(result);

      expect(rawInfo.version, equals(4));

      expect(rawInfo.meta.title, equals("naver网漫"));

      expect(rawInfo.main.book.buildUrl, equals("book_buildUrl"));

      expect(rawInfo.main.book.sections, isNotNull);
      expect(rawInfo.main.book.sections.buildUrl, equals("book_s_buildUrl"));
    });
  });
}
