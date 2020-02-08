import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:kiwi/core/js_engine_service.dart';
import 'package:process_run/process_run.dart';
import 'package:scratch_space/scratch_space.dart';

class NodeJsEngineService implements JsEngineService {
  @override
  Future<String> executeJs(String script, String method) async {
    var scratchSpace = new ScratchSpace();
    var tempPath = scratchSpace.tempDir.path;

    var uniqueKey = md5.convert(utf8.encode(script + ";" + method)).toString();

    var fileName = tempPath + "/" + uniqueKey + ".js";

    var file = File(fileName);

    await file.writeAsString(script + ";\r\nconsole.log(" + method + ")");

    var result = await run('node', [fileName], verbose: true);

    Directory(tempPath).deleteSync(recursive: true);

    return Future.value(result.stdout.toString().trim());
  }

  @override
  Future<String> executeJsWithContext(
      String script, String method, Map<String, dynamic> context) async {
    var scratchSpace = new ScratchSpace();
    var tempPath = scratchSpace.tempDir.path;

    var uniqueKey = md5.convert(utf8.encode(script + ";" + method)).toString();

    var fileName = tempPath + "/" + uniqueKey + ".js";

    var file = File(fileName);

    var contents = script + ";\r\nconsole.log(" + method + ")";

    context.forEach((key, value) {
      if (value is int) {
        contents = "var $key=$value;" + contents;
      } else {
        var trimValue = value
            .toString()
            .replaceAll("\"", "\\" + "\"")
            .replaceAll("\r\n", " ")
            .replaceAll("\n", " ")
            .trim();
        contents = "var $key=\"$trimValue\";" + contents;
      }
    });

    await file.writeAsString(contents);

    var result = await run('node', [fileName], verbose: true);

    Directory(tempPath).deleteSync(recursive: true);

    return Future.value(result.stdout.toString().trim());
  }
}
