import 'dart:collection';

import 'package:firebase_performance/firebase_performance.dart';
import 'package:kiwi/core/analysis_service.dart';
import 'package:uuid/uuid.dart';

class FirebaseAnalysisService extends AnalysisService {
  var uuid = new Uuid();
  Map<String, HttpMetric> httpMetricMap = HashMap();

  @override
  Future<String> startHttpMetric(String url, HttpMethod method) async {
    var metric =
        FirebasePerformance.instance.newHttpMetric(url, HttpMethod.Get);
    await metric.start();

    var id = uuid.v5("analysis", "http");

    httpMetricMap.putIfAbsent(id, () => metric);

    return id;
  }

  @override
  Future<void> stopHttpMetric(String uuid) async {
    var metric = httpMetricMap.putIfAbsent(uuid, () => null);
    if (metric != null) {
      await metric.stop();
    }
  }
}
