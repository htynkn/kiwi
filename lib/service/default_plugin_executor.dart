import 'dart:collection';
import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:kiwi/core/http_service.dart';
import 'package:kiwi/core/plugin_manager.dart';
import 'package:kiwi/domain/comic_book.dart';
import 'package:kiwi/domain/raw_plugin_info.dart';
import 'package:kiwi/service/js_engine_service.dart';
import 'package:quiver/strings.dart';
import 'package:xml/xml.dart' as xml;

class DefaultPluginExecutor {
  Future<RawPluginInfo> getRawInfoBy(int id) async {
    var manager = GetIt.I.get<PluginManager>();
    var plugin = await manager.getById(id);
    var rawPluginInfo = RawPluginInfo();

    var xmlContent = plugin.content;

    var document = xml.parse(xmlContent);

    var sited = document.findElements("sited").first;

    rawPluginInfo.version = int.parse(sited.getAttribute("ver"));
    rawPluginInfo.engineVersion = int.parse(sited.getAttribute("engine"));
    rawPluginInfo.private = sited.getAttribute("private") == "1";

    var meta = sited.findElements("meta").first;

    var rawPluginMetaInfo = RawPluginMetaInfo();
    rawPluginMetaInfo.ua = meta.findElements("ua").first.text;
    rawPluginMetaInfo.title = meta.findElements("title").first.text;
    rawPluginMetaInfo.author = meta.findElements("author").first.text;
    rawPluginMetaInfo.intro = meta.findElements("intro").first.text;
    rawPluginMetaInfo.url = meta.findElements("url").first.text;
    rawPluginMetaInfo.expr = meta.findElements("expr").first.text;
    rawPluginMetaInfo.logo = meta.findElements("logo").first.text;
    rawPluginMetaInfo.encode = meta.findElements("encode").first.text;

    rawPluginInfo.meta = rawPluginMetaInfo;

    var main = sited.findElements("main").first;

    var rawPluginMainInfo = RawPluginMainInfo();

    rawPluginMainInfo.dtype = int.parse(main.getAttribute("dtype"));

    rawPluginInfo.main = rawPluginMainInfo;

    var home = main.findElements("home").first;

    var homeInfo = RawPluginMainHostInfo();
    var hots = home.findElements("hots").first;

    homeInfo.cache = hots.getAttribute("cache");
    homeInfo.title = hots.getAttribute("title");
    homeInfo.method = hots.getAttribute("method");
    homeInfo.parse = hots.getAttribute("parse");
    homeInfo.url = hots.getAttribute("url");

    rawPluginInfo.main.home = homeInfo;

    var script = sited.findElements("script").first;

    var rawPluginScriptInfo = RawPluginScriptInfo();

    rawPluginScriptInfo.code = script.findElements("code").first.text;

    rawPluginScriptInfo.requireList =
        script.findElements("require").first.findElements("item").map((f) {
      return f.getAttribute("url");
    }).toList();

    rawPluginInfo.script = rawPluginScriptInfo;

    return Future.value(rawPluginInfo);
  }

  Future<List<ComicBook>> getComicBooks(RawPluginInfo pluginInfo) async {
    var httpService = GetIt.I.get<HttpService>();

    var jsEngineService = GetIt.I.get<JsEngineService>();

    var code = pluginInfo.script.code;

    for (var url in pluginInfo.script.requireList) {
      var requireScript;
      if (isNotEmpty(pluginInfo.meta.ua)) {
        requireScript = await httpService.get(url, pluginInfo.meta.ua);
      } else {
        requireScript = await httpService.get(url);
      }

      code = requireScript + ";" + code;
    }

    var home = pluginInfo.main.home;

    var html = await httpService.get(home.url);

    Map<String, String> context = HashMap();
    context.putIfAbsent("html", () => html);
    context.putIfAbsent("url", () => home.url);

    var result = await jsEngineService.executeJsWithContext(
        code, home.parse + "(url,html)", context);

    var books = ComicBook.fromJsonList(result);

    return Future.value(books);
  }
}
