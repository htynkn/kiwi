import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/app.dart';
import 'package:kiwi/ioc_configuration.dart';

void main() {
  testWidgets('init app', (WidgetTester tester) async {
    IocConfiguration().configDependencies();

    await tester.pumpWidget(createApp());
  });
}
