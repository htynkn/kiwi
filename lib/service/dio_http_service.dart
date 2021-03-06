import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:kiwi/core/analysis_service.dart';
import 'package:kiwi/core/http_service.dart';
import 'package:kiwi/core/logging_service.dart';
import 'package:quiver/strings.dart';

class DioHttpService extends HttpService {
  static final List<int> allowStatusCodeList = [200];
  var dio = Dio();
  AnalysisService analysisService;
  LoggingService loggingService;

  DioHttpService(this.analysisService, this.loggingService) {
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
      String referer,
      String requestedWith,
      String encode}) async {
    var uuid = await analysisService.startHttpMetric(url, HttpMethod.Get);

    try {
      var cacheOption = buildCacheOptions(duration);

      if (isNotEmpty(ua)) {
        cacheOption.headers.putIfAbsent(HttpHeaders.userAgentHeader, () => ua);
      }

      if (isNotEmpty(referer)) {
        cacheOption.headers
            .putIfAbsent(HttpHeaders.refererHeader, () => referer);
      }

      if (isNotEmpty(requestedWith)) {
        cacheOption.headers
            .putIfAbsent("X-Requested-With", () => requestedWith);
      }

      cacheOption.sendTimeout = 3000;
      cacheOption.receiveTimeout = 3000;

      cacheOption.responseDecoder = (List<int> responseBytes,
          RequestOptions options, ResponseBody responseBody) {
        if (isNotBlank(encode) && encode.startsWith("gb")) {
          return gbk.decode(responseBytes);
        } else {
          return Utf8Decoder().convert(responseBytes);
        }
      };

      Response response = await dio.get(url, options: cacheOption);

      this.loggingService.debug(response.toString());

      if (allowStatusCodeList.contains(response?.statusCode)) {
        return response.data?.toString();
      }
    } catch (e) {
      throw e;
    } finally {
      await analysisService.stopHttpMetric(uuid);
    }

    throw Exception("返回值无效");
  }
}
