import 'package:duoduo_cat/core/http_service.dart';

import 'package:dio/dio.dart';
import 'package:duoduo_cat/core/logging_service.dart';
import 'package:get_it/get_it.dart';

class DioHttpService extends HttpService {
  static final List<int> allowStatusCodeList = [200];

  LoggingService logger;

  DioHttpService() {
    this.logger = GetIt.I.get<LoggingService>();
  }

  @override
  get(String url) async {
    try {
      Response response = await Dio().get(url);
      logger.debug(response.toString());
      if (allowStatusCodeList.contains(response?.statusCode)) {
        return response.data?.toString();
      }
    } catch (e) {
      throw e;
    }
    throw Exception("返回值无效");
  }
}
