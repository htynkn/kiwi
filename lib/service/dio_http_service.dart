import 'package:dio/dio.dart';
import 'package:kiwi/core/http_service.dart';
import 'package:kiwi/core/logging_service.dart';
import 'package:get_it/get_it.dart';

class DioHttpService extends HttpService {
  static final List<int> allowStatusCodeList = [200];

  @override
  get(String url) async {
    try {
      Response response = await Dio().get(url);
      GetIt.I.get<LoggingService>().debug(response.toString());
      if (allowStatusCodeList.contains(response?.statusCode)) {
        return response.data?.toString();
      }
    } catch (e) {
      throw e;
    }
    throw Exception("返回值无效");
  }
}
