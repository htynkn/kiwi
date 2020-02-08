import 'dart:io';

class TestUtil {
  static Future<String> loadFile(String fileName) async {
    String basePath = "test/test_resources/";
    if (File(".").absolute.toString().contains("test")) {
      basePath = "test_resources/";
    }

    final file = File(basePath + fileName);
    var fileContent = await file.readAsString();
    return fileContent;
  }
}
