import 'package:duoduo_cat/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('init app', (WidgetTester tester) async {
    await tester.pumpWidget(createApp());
  });
}
