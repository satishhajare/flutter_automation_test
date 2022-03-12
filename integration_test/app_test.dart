import 'package:flutter_automation_poc/main.dart';
//import 'package:flutter_automation_poc/model/technology_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';

//import 'package:provider/provider.dart';

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

      // await tester.enterText(
      //     find.byKey(const ValueKey('technologyField')), 'Android');
      // await tester.enterText(
      //     find.byKey(const ValueKey('descriptionField')), 'Open Source');

      // await addDelay(4000);

      // await tester.ensureVisible(find.byType(ElevatedButton));
      // await tester.pumpAndSettle();
      // await tester.tap(find.byType(ElevatedButton));
      // await addDelay(4000);

      // tester.printToConsole('New Technology added!');
      // await tester.pumpAndSettle();
      // await addDelay(1000);

      // final state = tester.state(find.byType(Scaffold));
      // final title = Provider.of<TechnologyModel>(state.context, listen: false)
      //     .getAllIdeas[0]
      //     .title;
      // await addDelay(1000);
      // final temp = title!;
      // await tester.drag(
      //   find.byKey(ValueKey(
      //     title.toString(),
      //   )),
      //   const Offset(-600, 0),
      // );
      // await addDelay(5000);

      // expect(find.text(temp), findsNothing);
      // tester.printToConsole('Record Deleted Successfully!!');
      // await logout(tester);
    });
  });
}
