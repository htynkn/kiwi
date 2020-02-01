import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:kiwi/core/http_service.dart';
import 'package:kiwi/core/js_engine_service.dart';
import 'package:kiwi/core/plugin_manager.dart';
import 'package:kiwi/domain/plugin_info.dart';
import 'package:kiwi/ioc_configuration.dart';
import 'package:kiwi/service/default_plugin_executor.dart';
import 'package:kiwi/service/default_plugin_manager.dart';
import 'package:kiwi/service/simple_logging_service.dart';
import 'package:mockito/mockito.dart';
import 'package:scratch_space/scratch_space.dart';

import '../util/test_util.dart';
import 'mock_analysis_service.dart';
import 'mock_http_service.dart';
import 'node_js_engine_service.dart';

void main() {
  group("test_plugin_executor", () {
    String tempDir;
    PluginManager pluginManager;
    DefaultPluginExecutor executor;

    setUp(() {
      var scratchSpace = new ScratchSpace();
      tempDir = scratchSpace.tempDir.path;

      GetIt.I.reset();

      var loader = IocConfiguration().configDependencies(
          jsEngineService: NodeJsEngineService(),
          analysisService: MockAnalysisService());

      pluginManager =
          DefaultPluginManager(SimpleLoggingService(), path: tempDir);

      executor = DefaultPluginExecutor(pluginManager, loader.get<HttpService>(),
          loader.get<JsEngineService>());
    });

    tearDown(() {
      Directory(tempDir).delete(recursive: true);
    });

    test("test_raw_info", () async {
      var fileContent = await TestUtil.loadFile("default_plugin.xml");

      var result =
          await pluginManager.install(PluginInfo("漫画堆-手机版", ""), fileContent);

      expect(result, greaterThan(0));
      var rawInfo = await executor.getRawInfoBy(result);

      expect(rawInfo.version, equals(18));

      expect(rawInfo.script.code, isNotEmpty);

      expect(rawInfo.script.requireList, isNotEmpty);
      expect(rawInfo.script.requireList[0], isNotEmpty);
    });

    test("test_raw_info_issue_1", () async {
      var fileContent = await TestUtil.loadFile("issue_1_plugin.xml");

      var result =
          await pluginManager.install(PluginInfo("东方二次元", ""), fileContent);

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
      var fileContent = await TestUtil.loadFile("issue_2_plugin.xml");

      var result =
          await pluginManager.install(PluginInfo("naver网漫", ""), fileContent);

      expect(result, greaterThan(0));
      var rawInfo = await executor.getRawInfoBy(result);

      expect(rawInfo.version, equals(4));

      expect(rawInfo.meta.title, equals("naver网漫"));

      expect(rawInfo.main.book.buildUrl, equals("book_buildUrl"));

      expect(rawInfo.main.book.sections, isNotNull);
      expect(rawInfo.main.book.sections.buildUrl, equals("book_s_buildUrl"));
    });

    test("test_raw_info_issue_3", () async {
      var fileContent = await TestUtil.loadFile("issue_3_plugin.xml");

      var result =
          await pluginManager.install(PluginInfo("naver网漫", ""), fileContent);

      expect(result, greaterThan(0));
      var rawInfo = await executor.getRawInfoBy(result);

      expect(rawInfo.main.section.parse, isNotNull);
      expect(rawInfo.main.section.parseUrl, equals("section_parse_url"));
    });
  });

  group("test_parse", () {
    String tempDir;
    PluginManager pluginManager;
    DefaultPluginExecutor executor;

    setUp(() async {
      var scratchSpace = new ScratchSpace();
      tempDir = scratchSpace.tempDir.path;

      GetIt.I.reset();

      var loader = IocConfiguration().configDependencies(
          jsEngineService: NodeJsEngineService(),
          analysisService: MockAnalysisService());

      pluginManager =
          DefaultPluginManager(SimpleLoggingService(), path: tempDir);

      var mockHttpService = MockHttpService();

      executor = DefaultPluginExecutor(
          pluginManager, mockHttpService, loader.get<JsEngineService>());

      var cheerioContent = await TestUtil.loadFile("cheerio.js");

      when(mockHttpService.get(
              argThat(equals("http://sited.noear.org/addin/js/cheerio.js")),
              ua: anyNamed("ua")))
          .thenAnswer((_) => Future.value(cheerioContent));

      var tohomh123Html = await TestUtil.loadFile("tohomh123.html");

      when(mockHttpService.get(argThat(equals("https://www.tohomh123.com/")),
              ua: anyNamed("ua"), duration: anyNamed("duration")))
          .thenAnswer((_) => Future.value(tohomh123Html));
    });

    tearDown(() {
      Directory(tempDir).delete(recursive: true);
    });

    test("test_get_comic_books", () async {
      var fileContent = await TestUtil.loadFile("issue_3_plugin.xml");

      var id = await pluginManager.install(PluginInfo("土豪漫画", ""), fileContent);

      expect(id, greaterThan(0));

      var raw = await executor.getRawInfoBy(id);

      var list = await executor.getComicBooks(raw);

      expect(list, isNotEmpty);
    });
  });
}
