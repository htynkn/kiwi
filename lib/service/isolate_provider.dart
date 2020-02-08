import 'dart:isolate';

import 'package:get_it/get_it.dart';

import 'default_plugin_executor.dart';

class IsolateProvider {
  static get(String method, int id) async {
    var defaultPluginExecutor = GetIt.I.get<DefaultPluginExecutor>();

    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(getRawInfoBy, receivePort.sendPort);

    final sendPort = await receivePort.first;

    final answer = ReceivePort();

    sendPort.send([answer.sendPort, "getRawInfoBy", defaultPluginExecutor, id]);

    return answer.first;
  }

  static getRawInfoBy(SendPort port) async {
    final rPort = ReceivePort();

    port.send(rPort.sendPort);

    rPort.listen((message) async {
      final send = message[0] as SendPort;
      final method = message[1] as String;
      final defaultPluginExecutor = message[2] as DefaultPluginExecutor;
      final id = message[3] as int;
      send.send(await defaultPluginExecutor.getRawInfoBy(id));
    });
  }
}
