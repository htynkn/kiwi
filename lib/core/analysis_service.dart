import 'package:firebase_performance/firebase_performance.dart';

abstract class AnalysisService {
  Future<String> startHttpMetric(String url, HttpMethod method);

  Future<void> stopHttpMetric(String uuid);
}
