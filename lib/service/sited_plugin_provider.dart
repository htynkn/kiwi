import 'package:duoduo_cat/core/http_service.dart';
import 'package:duoduo_cat/core/logging_service.dart';
import 'package:duoduo_cat/core/plugin_provider.dart';
import 'package:duoduo_cat/domain/plugin.dart';
import 'package:duoduo_cat/domain/plugin_info.dart';
import 'package:get_it/get_it.dart';
import 'package:html/parser.dart';
import 'package:logger/logger.dart';

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
        var link = value.getElementsByTagName("a")?.first?.attributes["href"];

        var pluginInfo = PluginInfo(name.text, desp.text);
        
        pluginInfo.remoteUrl = link;

        result.add(pluginInfo);
      });

      return Future.value(result);
    } else {
      throw Exception();
    }
  }

  @override
  Future<List<PluginInfo>> search(String keyword) {
    // TODO: implement search
    return null;
  }
}
