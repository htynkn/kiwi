import 'dart:collection';
import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:kiwi/core/http_service.dart';
import 'package:kiwi/core/js_engine_service.dart';
import 'package:kiwi/core/plugin_manager.dart';
import 'package:kiwi/domain/comic_book.dart';
import 'package:kiwi/domain/comic_detail.dart';
import 'package:kiwi/domain/comic_section.dart';
import 'package:kiwi/domain/comic_tag.dart';
import 'package:kiwi/domain/comic_tags.dart';
import 'package:kiwi/domain/raw_plugin_info.dart';
import 'package:kiwi/exception/plugin_exception.dart';
import 'package:ms_dart/ms_dart.dart';
import 'package:quiver/strings.dart';
import 'package:xml/xml.dart' as xml;

class DefaultPluginExecutor {
  final String defaultUA =
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36";

  PluginManager manager;
  HttpService httpService;
  JsEngineService jsEngineService;

  DefaultPluginExecutor(this.manager, this.httpService, this.jsEngineService);

  Future<RawPluginInfo> getRawInfoContent(String xmlContent) {
    return parsePlugin(xmlContent);
  }

  Future<RawPluginInfo> getRawInfoBy(int id) async {
    var plugin = await manager.getById(id);

    var xmlContent = plugin.content;

    return parsePlugin(xmlContent);
  }

  Future<RawPluginInfo> parsePlugin(String xmlContent) {
    var rawPluginInfo = RawPluginInfo();

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
      rawPluginMetaInfo.ua =
          _getText(metaContainer, "ua").replaceAll("\n", " ").trim();
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
    var hots = _findFirstElement(home, "hots", alias: "updates");

    homeInfo.cache = hots.getAttribute("cache");
    homeInfo.title = hots.getAttribute("title");
    homeInfo.method = hots.getAttribute("method");
    homeInfo.parse = hots.getAttribute("parse");
    homeInfo.url = hots.getAttribute("url");

    rawPluginInfo.main.home = homeInfo;

    if (_hasElement(home, "tags")) {
      var tags = _findFirstElement(home, "tags");

      var tagsInfo = RawPluginMainTagsInfo();

      tagsInfo.title = tags.getAttribute("title");
      tagsInfo.tags = List();
      tagsInfo.items = List();

      if (_hasElement(tags, "tags")) {
        for (var tag in tags.findElements("tags")) {
          var tagInfo = RawPluginMainHostInfo();

          tagInfo.parse = tag.getAttribute("parse");
          tagInfo.cache = tag.getAttribute("cache");
          tagInfo.url = tag.getAttribute("url");
          tagInfo.method = tag.getAttribute("method");

          tagsInfo.tags.add(tagInfo);
        }
      }

      if (_hasElement(tags, "item")) {
        for (var item in tags.findElements("item")) {
          var itemInfo = RawPluginMainTagInfo();

          itemInfo.url = item.getAttribute("url");
          itemInfo.title = item.getAttribute("title");

          tagsInfo.items.add(itemInfo);
        }
      }

      rawPluginInfo.main.tags = tagsInfo;
    }

    var book = _findFirstElement(main, "book");

    var bookInfo = RawPluginMainBookInfo();

    bookInfo.cache = book.getAttribute("cache");
    bookInfo.title = book.getAttribute("title");
    bookInfo.method = book.getAttribute("method");
    bookInfo.parse = book.getAttribute("parse");
    bookInfo.buildUrl = book.getAttribute("buildUrl");

    if (this._hasElement(book, "sections")) {
      var sections = this._findFirstElement(book, "sections");

      var sectionsInfo = RawPluginMainSectionsInfo();

      sectionsInfo.parseUrl = sections.getAttribute("parseUrl");
      sectionsInfo.buildUrl = sections.getAttribute("buildUrl");
      sectionsInfo.parse = sections.getAttribute("parse");

      bookInfo.sections = sectionsInfo;
    }

    rawPluginInfo.main.book = bookInfo;

    var section = _findFirstElement(main, "section");

    var sectionInfo = RawPluginMainSectionInfo();

    sectionInfo.cache = section.getAttribute("cache");
    sectionInfo.method = section.getAttribute("method");
    sectionInfo.parse = section.getAttribute("parse");
    sectionInfo.parseUrl = section.getAttribute("parseUrl");

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

    var books = await compute(ComicBook.fromJsonList, result);

    return Future.value(books);
  }

  getSections(RawPluginInfo pluginInfo, String url, String sectionName) async {
    var code = pluginInfo.script.code;

    for (var url in pluginInfo.script.requireList) {
      var requireScript = await httpService.get(url, ua: pluginInfo.meta.ua);

      code = requireScript + ";" + code;
    }

    var book = pluginInfo.main.book;

    if (isNotEmpty(book.buildUrl)) {
      Map<String, String> context = HashMap();
      context.putIfAbsent("url", () => url);

      url = await jsEngineService.executeJsWithContext(
          code, book.buildUrl + "(url)", context);
    }

    var html = await httpService.get(url,
        ua: pluginInfo.meta.ua, duration: _getDuration(book.cache));

    Map<String, String> context = HashMap();
    context.putIfAbsent("html", () => html);
    context.putIfAbsent("url", () => url);

    var result = await jsEngineService.executeJsWithContext(
        code, book.parse + "(url,html)", context);

    var comicSection = await compute(ComicSection.fromJsonString, result);

    comicSection.pluginName = pluginInfo.meta.title;

    if (comicSection.sections == null) {
      comicSection.sections = List();
    }

    if (book.sections != null) {
      if (isNotEmpty(book.sections.buildUrl)) {
        Map<String, String> context = HashMap();
        context.putIfAbsent("url", () => url);

        url = await jsEngineService.executeJsWithContext(
            code, book.sections.buildUrl + "(url)", context);
      }

      List<String> sectionsUrl = List();

      if (isNotEmpty(book.sections.parseUrl)) {
        var html = await httpService.get(url,
            ua: pluginInfo.meta.ua, duration: _getDuration(book.cache));
        Map<String, String> context = HashMap();
        context.putIfAbsent("url", () => url);
        context.putIfAbsent("html", () => html);

        var tempResult = await jsEngineService.executeJsWithContext(
            code, book.sections.parseUrl + "(url,html)", context);

        sectionsUrl.addAll(tempResult.split(";"));
      } else {
        sectionsUrl.add(url);
      }

      for (var sectionUrl in sectionsUrl) {
        var html = await httpService.get(sectionUrl,
            ua: pluginInfo.meta.ua, duration: _getDuration(book.cache));
        Map<String, String> context = HashMap();
        context.putIfAbsent("url", () => sectionUrl);
        context.putIfAbsent("html", () => html);

        var tempResult = await jsEngineService.executeJsWithContext(
            code, book.sections.parse + "(url,html)", context);

        var tempSection =
            await compute(ComicSection.fromJsonString, tempResult);

        comicSection.sections.addAll(tempSection.sections);
      }
    }

    if (StringUtils.isNullOrEmpty(comicSection.name)) {
      comicSection.name = sectionName;
    }

    return Future.value(comicSection);
  }

  Future<ComicDetail> getComicDetails(
      RawPluginInfo pluginInfo, String url) async {
    var comicDetail = ComicDetail();
    comicDetail.pics = List();

    var code = pluginInfo.script.code;

    for (var url in pluginInfo.script.requireList) {
      var requireScript = await httpService.get(url, ua: pluginInfo.meta.ua);

      code = requireScript + ";" + code;
    }

    var section = pluginInfo.main.section;

    List<String> urls = List();
    if (isNotEmpty(section.parseUrl)) {
      var html = await httpService.get(url,
          ua: pluginInfo.meta.ua, duration: _getDuration(section.cache));

      Map<String, String> context = HashMap();
      context.putIfAbsent("html", () => html);
      context.putIfAbsent("url", () => url);

      var result = await jsEngineService.executeJsWithContext(
          code, section.parseUrl + "(url,html)", context);

      urls.addAll(result.split(";"));
    } else {
      urls.add(url);
    }

    comicDetail.ua = pluginInfo.meta.ua;
    comicDetail.reference = url;
    comicDetail.duration =
        this._getDuration(section.cache, defaultDurationInMin: 60 * 24 * 7);

    for (var singleUrl in urls) {
      var html = await httpService.get(singleUrl,
          ua: pluginInfo.meta.ua, duration: _getDuration(section.cache));

      Map<String, String> context = HashMap();
      context.putIfAbsent("html", () => html);
      context.putIfAbsent("url", () => url);

      var result = await jsEngineService.executeJsWithContext(
          code, section.parse + "(url,html)", context);

      var pics = (jsonDecode(result) as List<dynamic>).cast<String>();

      comicDetail.pics.addAll(pics);
    }

    return Future.value(comicDetail);
  }

  Future<ComicTags> getComicTags(RawPluginInfo pluginInfo) async {
    var tags = ComicTags();

    var rawTags = pluginInfo.main.tags;
    tags.title = rawTags.title;
    tags.list = List();

    for (var tag in rawTags.tags) {
      var code = pluginInfo.script.code;

      for (var url in pluginInfo.script.requireList) {
        var requireScript = await httpService.get(url, ua: pluginInfo.meta.ua);

        code = requireScript + ";" + code;
      }

      var url = tag.url;

      var html = await httpService.get(url,
          ua: pluginInfo.meta.ua, duration: _getDuration(tag.cache));

      Map<String, String> context = HashMap();
      context.putIfAbsent("html", () => html);
      context.putIfAbsent("url", () => url);

      var result = await jsEngineService.executeJsWithContext(
          code, tag.parse + "(url,html)", context);
    }

    for (var item in rawTags.items) {
      var tag = ComicTag();

      tag.name = item.title;
      tag.url = item.url;

      tags.list.add(tag);
    }

    return Future.value(tags);
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
