import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Kiwi App', () {
    final installButton = find.byValueKey("home_button_install_plugin");
    final installSearchInput = find.byValueKey("install-search-input");
    final installSearchButton = find.byValueKey("install-search-button");

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

    test('go to install page', () async {
      await driver.tap(installButton);

      await driver.waitFor(find.byValueKey("install_item_1"),
          timeout: Duration(seconds: 5));
    });

    test('test plugin search', () async {
      await driver.tap(installButton);

      await driver.waitFor(installSearchInput, timeout: Duration(seconds: 5));

      await driver.tap(installSearchInput); // acquire focus
      await driver.enterText('na');

      await driver.tap(installSearchButton);

      await driver.waitFor(find.byValueKey("install_item_1"),
          timeout: Duration(seconds: 5));
    });
  });
}
