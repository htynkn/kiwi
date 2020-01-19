import 'package:duoduo_cat/core/http_service.dart';
import 'package:duoduo_cat/core/logging_service.dart';
import 'package:duoduo_cat/core/plugin_provider.dart';
import 'package:duoduo_cat/domain/plugin_info.dart';
import 'package:duoduo_cat/exception/http_exception.dart';
import 'package:get_it/get_it.dart';
import 'package:html/parser.dart';
import 'dart:convert';

class SitedPluginProvider extends PluginProvider {
  HttpService httpService;

  LoggingService logging;

  SitedPluginProvider() {
    var loader = GetIt.I;

    this.httpService = loader.get<HttpService>();
    this.logging = loader.get<LoggingService>();
  }

  @override
  list([int pageNum = 1, int pageSize = 20]) async {
    var html = await this.httpService.get("http://sited.noear.org/?tag=1");
    if (html != null) {
      var document = parse(html);

      var itemList = document.getElementById("list").getElementsByTagName("li");

      List<PluginInfo> result = List();

      itemList.asMap().forEach((index, value) {
        var name = value.getElementsByTagName("a")?.first;
        var desp = value.getElementsByTagName("p")?.first;
        var link =
            value.getElementsByClassName("button")?.first?.attributes["href"];

        var pluginInfo = PluginInfo(name.text, desp.text);

        pluginInfo.remoteUrl = link;

        result.add(pluginInfo);
      });

      return Future.value(result);
    } else {
      throw HttpException();
    }
  }

  @override
  Future<List<PluginInfo>> search(String keyword) async {
    var html =
        await this.httpService.get("http://sited.noear.org/?key=$keyword");
    if (html != null) {
      var document = parse(html);

      var itemList = document.getElementById("list").getElementsByTagName("li");

      List<PluginInfo> result = List();

      itemList.asMap().forEach((index, value) {
        var name = value.getElementsByTagName("a")?.first;
        var desp = value.getElementsByTagName("p")?.first;
        var link =
            value.getElementsByClassName("button")?.first?.attributes["href"];

        var pluginInfo = PluginInfo(name.text, desp.text);

        pluginInfo.remoteUrl = link;

        result.add(pluginInfo);
      });

      return Future.value(result);
    } else {
      throw HttpException();
    }
  }

  @override
  Future<String> download(String remoteUrl) async {
    remoteUrl = remoteUrl.replaceFirst("sited://data?", "");

    remoteUrl = utf8.decode(base64.decode(remoteUrl));

    var pluginString = await this.httpService.get(remoteUrl);

    int start = pluginString.indexOf("::") + 2;
    int end = pluginString.lastIndexOf("::");
    String txt = pluginString.substring(start, end);
    String key = pluginString.substring(end + 2);

    StringBuffer sb = new StringBuffer();
    for (int i = 0, len = txt.length; i < len; i++) {
      if (i % 2 == 0) {
        sb.write(txt[i]);
      }
    }

    txt = sb.toString();
    txt = utf8.decode(base64.decode(txt));
    key = key + "ro4w78Jx";

    var data = utf8.encode(txt);
    var keyData = utf8.encode(key);

    int keyIndex = 0;

    for (int x = 0; x < data.length; x++) {
      data[x] = (data[x] ^ keyData[keyIndex]);
      keyIndex += 1;

      if (keyIndex == keyData.length) {
        keyIndex = 0;
      }
    }

    txt = utf8.decode(data);

    txt = utf8.decode(base64.decode(txt));

    return Future.value(txt);
  }
}
