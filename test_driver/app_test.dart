import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Kiwi App', () {
    final installButton = find.byValueKey("home_button_install_plugin");

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('test home page', () async {
      await driver.waitFor(installButton, timeout: Duration(seconds: 5));
    });
  });
}
