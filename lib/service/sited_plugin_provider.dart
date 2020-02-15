import 'dart:convert';

import 'package:html/parser.dart';
import 'package:kiwi/core/http_service.dart';
import 'package:kiwi/core/logging_service.dart';
import 'package:kiwi/core/plugin_provider.dart';
import 'package:kiwi/domain/plugin_info.dart';
import 'package:kiwi/exception/http_exception.dart';
import 'package:kiwi/util/decryption_util.dart';

class SitedPluginProvider extends PluginProvider {
  HttpService httpService;

  LoggingService logging;

  SitedPluginProvider(this.httpService, this.logging);

  @override
  list([int pageNum = 1, int pageSize = 20]) async {
    var html = await this.httpService.get("http://sited.noear.org/?tag=1",
        ua: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.100 Safari/537.36",
        referer: "http://sited.noear.org/");
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

    String txt = DecryptionUtil.decryption(pluginString);

    return Future.value(txt);
  }
}
