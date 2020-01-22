import 'dart:collection';
import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:kiwi/core/http_service.dart';
import 'package:kiwi/core/plugin_manager.dart';
import 'package:kiwi/domain/comic_book.dart';
import 'package:kiwi/domain/comic_detail.dart';
import 'package:kiwi/domain/comic_section.dart';
import 'package:kiwi/domain/raw_plugin_info.dart';
import 'package:kiwi/exception/plugin_exception.dart';
import 'package:kiwi/service/js_engine_service.dart';
import 'package:ms_dart/ms_dart.dart';
import 'package:quiver/strings.dart';
import 'package:xml/xml.dart' as xml;

class DefaultPluginExecutor {
  final String defaultUA =
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36";

  Future<RawPluginInfo> getRawInfoBy(int id) async {
    var manager = GetIt.I.get<PluginManager>();
    var plugin = await manager.getById(id);
    var rawPluginInfo = RawPluginInfo();

    var xmlContent = plugin.content;

    var document = xml.parse(xmlContent);

    var sited = _findFirstElement(document, "sited", alias: "site");

    rawPluginInfo.version = int.parse(sited.getAttribute("ver"));
    rawPluginInfo.engineVersion = int.parse(sited.getAttribute("engine"));
    rawPluginInfo.private = sited.getAttribute("private") == "1";

    var rawPluginMetaInfo = RawPluginMetaInfo();

    var metaContainer = sited;
    if (_hasElement(sited, "meta")) {
      metaContainer = sited.findElements("meta").first;
    }

    if (metaContainer != null) {
      rawPluginMetaInfo.ua = _getText(metaContainer, "ua");
      rawPluginMetaInfo.title = _getText(metaContainer, "title");
      rawPluginMetaInfo.author = _getText(metaContainer, "author");
      rawPluginMetaInfo.intro = _getText(metaContainer, "intro");
      rawPluginMetaInfo.url = _getText(metaContainer, "url");
      rawPluginMetaInfo.expr = _getText(metaContainer, "expr");
      rawPluginMetaInfo.logo = _getText(metaContainer, "logo");
      rawPluginMetaInfo.encode = _getText(metaContainer, "encode");
    }

    rawPluginInfo.meta = rawPluginMetaInfo;

    var main = sited.findElements("main").first;

    var rawPluginMainInfo = RawPluginMainInfo();

    rawPluginMainInfo.dtype = int.parse(main.getAttribute("dtype"));

    rawPluginInfo.main = rawPluginMainInfo;

    var home = main.findElements("home").first;

    var homeInfo = RawPluginMainHostInfo();
    var hots = _findFirstElement(home, "hots");

    homeInfo.cache = hots.getAttribute("cache");
    homeInfo.title = hots.getAttribute("title");
    homeInfo.method = hots.getAttribute("method");
    homeInfo.parse = hots.getAttribute("parse");
    homeInfo.url = hots.getAttribute("url");

    rawPluginInfo.main.home = homeInfo;

    var book = _findFirstElement(main, "book");

    var bookInfo = RawPluginMainBookInfo();

    bookInfo.cache = book.getAttribute("cache");
    bookInfo.title = book.getAttribute("title");
    bookInfo.method = book.getAttribute("method");
    bookInfo.parse = book.getAttribute("parse");

    rawPluginInfo.main.book = bookInfo;

    var section = _findFirstElement(main, "section");

    var sectionInfo = RawPluginMainSectionInfo();

    sectionInfo.cache = section.getAttribute("cache");
    sectionInfo.method = section.getAttribute("method");
    sectionInfo.parse = section.getAttribute("parse");

    rawPluginInfo.main.section = sectionInfo;

    var script = _findFirstElement(sited, "script", alias: "jscript");

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
      var requireScript = await httpService.get(url, ua: pluginInfo.meta.ua);

      code = requireScript + ";" + code;
    }

    var home = pluginInfo.main.home;

    var html = await httpService.get(home.url,
        ua: pluginInfo.meta.ua, duration: _getDuration(home.cache));

    Map<String, String> context = HashMap();
    context.putIfAbsent("html", () => html);
    context.putIfAbsent("url", () => home.url);

    var result = await jsEngineService.executeJsWithContext(
        code, home.parse + "(url,html)", context);

    var books = ComicBook.fromJsonList(result);

    return Future.value(books);
  }

  getSections(RawPluginInfo pluginInfo, String url) async {
    var httpService = GetIt.I.get<HttpService>();

    var jsEngineService = GetIt.I.get<JsEngineService>();

    var code = pluginInfo.script.code;

    for (var url in pluginInfo.script.requireList) {
      var requireScript = await httpService.get(url, ua: pluginInfo.meta.ua);

      code = requireScript + ";" + code;
    }

    var book = pluginInfo.main.book;

    var html = await httpService.get(url,
        ua: pluginInfo.meta.ua, duration: _getDuration(book.cache));

    Map<String, String> context = HashMap();
    context.putIfAbsent("html", () => html);
    context.putIfAbsent("url", () => url);

    var result = await jsEngineService.executeJsWithContext(
        code, book.parse + "(url,html)", context);

    var section = ComicSection.fromJsonString(result);

    section.pluginName = pluginInfo.meta.title;

    return Future.value(section);
  }

  Future<ComicDetail> getComicDetails(
      RawPluginInfo pluginInfo, String url) async {
    var comicDetail = ComicDetail();

    var httpService = GetIt.I.get<HttpService>();

    var jsEngineService = GetIt.I.get<JsEngineService>();

    var code = pluginInfo.script.code;

    for (var url in pluginInfo.script.requireList) {
      var requireScript = await httpService.get(url, ua: pluginInfo.meta.ua);

      code = requireScript + ";" + code;
    }

    var section = pluginInfo.main.section;

    var html = await httpService.get(url,
        ua: pluginInfo.meta.ua, duration: _getDuration(section.cache));

    Map<String, String> context = HashMap();
    context.putIfAbsent("html", () => html);
    context.putIfAbsent("url", () => url);

    var result = await jsEngineService.executeJsWithContext(
        code, section.parse + "(url,html)", context);

    var pics = (jsonDecode(result) as List<dynamic>).cast<String>();

    comicDetail.pics = pics;
    comicDetail.ua = pluginInfo.meta.ua;
    comicDetail.reference = url;
    comicDetail.duration =
        this._getDuration(section.cache, defaultDurationInMin: 60 * 24 * 7);

    return Future.value(comicDetail);
  }

  xml.XmlElement _findFirstElement(xml.XmlParent xmlParent, String name,
      {String alias}) {
    var findByName = xmlParent.findElements(name);

    if (findByName.length > 0) {
      return findByName.first;
    }

    if (isNotEmpty(alias)) {
      return xmlParent.findElements(alias).first;
    }

    throw PluginException();
  }

  bool _hasElement(xml.XmlParent xmlParent, String name) {
    return xmlParent.findElements(name).length > 0;
  }

  String _getText(xml.XmlParent xmlParent, String name) {
    if (_hasElement(xmlParent, name)) {
      return _findFirstElement(xmlParent, name).text;
    }
    return "";
  }

  _getDuration(String durationString, {int defaultDurationInMin = 1}) {
    if (isNotBlank(durationString)) {
      if (durationString == "1") {
        return Duration(days: 10);
      }
      try {
        int ms = MS.toMs(durationString).toInt();
        return Duration(milliseconds: ms);
      } catch (e) {}
    }
    return Duration(minutes: defaultDurationInMin);
  }
}
