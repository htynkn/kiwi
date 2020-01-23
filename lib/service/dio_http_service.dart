import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:get_it/get_it.dart';
import 'package:kiwi/core/http_service.dart';
import 'package:kiwi/core/logging_service.dart';
import 'package:quiver/strings.dart';

class DioHttpService extends HttpService {
  static final List<int> allowStatusCodeList = [200];
  var dio = Dio();

  DioHttpService() {
    if (!isDebug()) {
      dio.interceptors.add(DioCacheManager(CacheConfig()).interceptor);

      var cookieJar = CookieJar();
      dio.interceptors.add(CookieManager(cookieJar));
    }
  }

  @override
  Future<String> get(String url,
      {String ua,
      Duration duration = const Duration(minutes: 1),
      String referer}) async {
    var metric;

    if (!isDebug()) {
      metric = FirebasePerformance.instance.newHttpMetric(url, HttpMethod.Get);
      await metric.start();
    }

    try {
      var cacheOption = buildCacheOptions(duration);

      if (isNotEmpty(ua)) {
        cacheOption.headers.putIfAbsent(HttpHeaders.userAgentHeader, () => ua);
      }

      if (isNotEmpty(referer)) {
        cacheOption.headers
            .putIfAbsent(HttpHeaders.refererHeader, () => referer);
      }

      cacheOption.sendTimeout = 3000;
      cacheOption.receiveTimeout = 3000;

      Response response = await dio.get(url, options: cacheOption);

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
