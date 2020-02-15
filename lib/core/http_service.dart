abstract class HttpService {
  Future<String> get(String url,
      {String ua, Duration duration, String referer, String requestedWith});
}
