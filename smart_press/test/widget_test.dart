import 'package:flutter_test/flutter_test.dart';
import 'package:smart_press/app.dart';

void main() {
  testWidgets('App launch smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartPressApp());

    // Verify that the welcome text is present
    expect(find.text('Smart Press'), findsOneWidget);
    expect(find.text('FOR SHOP OWNERS'), findsOneWidget);
  });
}
