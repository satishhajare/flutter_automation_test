import 'package:flutter_automation_poc/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';

Future<void> addDelay(int ms) async {
  await Future<void>.delayed(Duration(milliseconds: ms));
}

Future<void> logout(WidgetTester tester) async {
  await addDelay(6000);
  await tester.tap(find.byKey(
    const ValueKey('LogoutKey'),
  ));

  await addDelay(4000);
  tester.printToConsole('Login screen opens');
  await tester.pumpAndSettle();
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  // ignore: unnecessary_type_check
  if (binding is LiveTestWidgetsFlutterBinding) {
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  }

  group('end-to-end test', () {
    final timeBasedEmail =
        DateTime.now().microsecondsSinceEpoch.toString() + '@gmail.com';
    testWidgets('Authentication Testing', (WidgetTester tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      /*Sign Up*/
      await tester.tap(find.byType(TextButton));
      tester.printToConsole('SignUp screen opens');
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const ValueKey('emailSignUpField')), timeBasedEmail);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const ValueKey('passwordSignUpField')), 'Test@123');
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const ValueKey('confirmPasswordSignUpField')), 'Test@123');
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await addDelay(24000);
      await tester.pumpAndSettle();

      expect(find.text('Technology'), findsOneWidget);

      await logout(tester);
    });

    //Login screen test
    testWidgets('Modifying Features test', (WidgetTester tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      await addDelay(5000);
      await tester.enterText(
          find.byKey(const ValueKey('emailLoginField')), "test@gmail.com");
      await tester.enterText(
          find.byKey(const ValueKey('passwordLoginField')), 'Test@123');
      await tester.tap(find.byType(ElevatedButton));
      await addDelay(18000);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await addDelay(2000);
      tester.printToConsole('New Technology screen opens');
      await tester.pumpAndSettle();
    });
  });
}
