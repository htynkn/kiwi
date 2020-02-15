import 'dart:convert';

import 'package:kiwi/core/http_service.dart';
import 'package:kiwi/core/logging_service.dart';
import 'package:kiwi/core/plugin_provider.dart';
import 'package:kiwi/domain/plugin_info.dart';
import 'package:kiwi/util/decryption_util.dart';

class Ka94PluginProvider extends PluginProvider {
  HttpService httpService;

  LoggingService logging;

  Ka94PluginProvider(this.httpService, this.logging);

  @override
  Future<String> download(String url) async {
    var pluginString = await this.httpService.get(url);

    String txt = DecryptionUtil.decryption(pluginString);

    return Future.value(txt);
  }

  @override
  Future<List<PluginInfo>> list(int pageNum, int pageSize) async {
    var jsonString = await httpService.get("http://sited.ka94.com/api/",
        ua: "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1",
        referer: "http://sited.ka94.com/",
        requestedWith: "XMLHttpRequest");

    List<dynamic> json = jsonDecode(jsonString);

    List<PluginInfo> list = List();

    for (var item in json) {
      if (item["type"] == "1") {
        String name = item["title"];
        String description = item["intro"];
        var pluginInfo = new PluginInfo(name, description);

        String id = item["id"];

        pluginInfo.remoteUrl = "http://sited.ka94.com/plugin.sited.php?id=" +
            id +
            "&t=" +
            (new DateTime.now().millisecondsSinceEpoch / 1000 + 180).toString();

        list.add(pluginInfo);
      }
    }

    return Future.value(list);
  }

  @override
  Future<List<PluginInfo>> search(String keyword) async {
    var list = await this.list(1, 200);

    var nList = list.where((i) => i.name.contains(keyword)).toList();

    return Future.value(nList);
  }
}
