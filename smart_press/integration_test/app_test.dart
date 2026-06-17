import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_press/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-End Authentication and Navigation Flow', (WidgetTester tester) async {
    // 1. Launch the application
    app.main();
    await tester.pumpAndSettle();

    // Verify Welcome Screen
    expect(find.text('Smart Press'), findsOneWidget);
    expect(find.byKey(const Key('owner_login_btn')), findsOneWidget);

    // 2. Tap Owner Login
    await tester.tap(find.byKey(const Key('owner_login_btn')));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify OTP Login screen loaded
    expect(find.byKey(const Key('mobile_field')), findsOneWidget);
    expect(find.byKey(const Key('send_otp_btn')), findsOneWidget);

    // 3. Enter Mobile Number
    await tester.enterText(find.byKey(const Key('mobile_field')), '9876543210');
    await tester.pumpAndSettle();

    // 4. Tap Send OTP
    await tester.tap(find.byKey(const Key('send_otp_btn')));
    
    // Allow up to 10 seconds for API request and server wake up
    await tester.pumpAndSettle(const Duration(seconds: 8));

    // Find the dynamically generated dev OTP from the screen
    final otpFinder = find.byWidgetPredicate(
      (widget) => widget is Text && RegExp(r'^\d{6}$').hasMatch(widget.data ?? ''),
    );
    expect(otpFinder, findsOneWidget);

    final Text otpTextWidget = tester.widget(otpFinder);
    final String otp = otpTextWidget.data!;
    debugPrint('Fetched Dev OTP: $otp');

    // 5. Input the OTP digits
    for (int i = 0; i < 6; i++) {
      await tester.enterText(find.byKey(Key('otp_digit_$i')), otp[i]);
      await tester.pump();
    }
    await tester.pumpAndSettle();

    // 6. Tap Verify and Continue
    await tester.tap(find.byKey(const Key('verify_otp_btn')));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 7. Verify Dashboard loads
    expect(find.text("Today's Revenue"), findsOneWidget);
    expect(find.byKey(const Key('dashboard_settings_btn')), findsOneWidget);

    // 8. Go to Settings
    await tester.tap(find.byKey(const Key('dashboard_settings_btn')));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify App Settings page loaded
    expect(find.text('App Settings'), findsOneWidget);
    expect(find.byKey(const Key('settings_logout_btn')), findsOneWidget);

    // 9. Logout from the application
    await tester.tap(find.byKey(const Key('settings_logout_btn')));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify we are redirected back to the Welcome Screen
    expect(find.text('Smart Press'), findsOneWidget);
  });
}
