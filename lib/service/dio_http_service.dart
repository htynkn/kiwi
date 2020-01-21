import 'package:dio/dio.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:get_it/get_it.dart';
import 'package:kiwi/core/http_service.dart';
import 'package:kiwi/core/logging_service.dart';

class DioHttpService extends HttpService {
  static final List<int> allowStatusCodeList = [200];

  @override
  get(String url) async {
    var metric;

    if (!isDebug()) {
      metric = FirebasePerformance.instance.newHttpMetric(url, HttpMethod.Get);
      await metric.start();
    }

    try {
      Response response = await Dio().get(url);
      GetIt.I.get<LoggingService>().debug(response.toString());
      if (allowStatusCodeList.contains(response?.statusCode)) {
        return response.data?.toString();
      }
    } catch (e) {
      throw e;
    } finally {
      if (!isDebug()) {
        await metric.stop();
      }
    }
    throw Exception("返回值无效");
  }
}
