import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_test/flutter_test.dart';

class TestApp extends StatelessWidget {
  final Widget child;

  TestApp(this.child); // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test wrapper',
      theme: ThemeData(),
      home: Scaffold(body: child),
    );
  }
}

void main() {
  group('Group test for Padding', () {
    testWidgets('Test of paddingAll', (WidgetTester tester) async {
      Widget containerTest;

      expect(find.byType(Padding), findsNothing);

      await tester.pumpWidget(containerTest.paddingAll(16));

      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('Test of paddingOnly', (WidgetTester tester) async {
      Widget containerTest;

      expect(find.byType(Padding), findsNothing);

      await tester.pumpWidget(containerTest.paddingOnly(top: 16));

      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('Test of paddingSymmetric', (WidgetTester tester) async {
      Widget containerTest;

      expect(find.byType(Padding), findsNothing);

      await tester.pumpWidget(containerTest.paddingSymmetric(vertical: 16));

      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('Test of paddingZero', (WidgetTester tester) async {
      Widget containerTest;

      expect(find.byType(Padding), findsNothing);

      await tester.pumpWidget(containerTest.paddingZero);

      expect(find.byType(Padding), findsOneWidget);
    });
  });

  group('Group test for Margin', () {
    testWidgets('Test of marginAll', (WidgetTester tester) async {
      Widget containerTest;

      await tester.pumpWidget(containerTest.marginAll(16));

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Test of marginOnly', (WidgetTester tester) async {
      Widget containerTest;

      await tester.pumpWidget(containerTest.marginOnly(top: 16));

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Test of marginSymmetric', (WidgetTester tester) async {
      Widget containerTest;

      await tester.pumpWidget(containerTest.marginSymmetric(vertical: 16));

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Test of marginZero', (WidgetTester tester) async {
      Widget containerTest;

      await tester.pumpWidget(containerTest.marginZero);

      expect(find.byType(Container), findsOneWidget);
    });
  });

  group('Tests for Visibility', () {
    testWidgets('Test with visible = true', (WidgetTester tester) async {
      Widget containerTest = Container(width: 200, height: 200);

      await tester.pumpWidget(containerTest.visibility(true));

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Test with visible = false', (WidgetTester tester) async {
      Widget containerTest = Container(width: 200, height: 200);

      await tester.pumpWidget(containerTest.visibility(false));

      expect(find.byType(Container), findsNothing);
    });
  });

  group('Tests for Flexible', () {
    testWidgets('Test with only default values', (WidgetTester tester) async {
      Widget containerTest = Container(width: 200, height: 200);

      await tester.pumpWidget(
          TestApp(Row(children: <Widget>[containerTest.flexible()])));

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Flexible), findsOneWidget);
    });

    testWidgets('Test with only flex value', (WidgetTester tester) async {
      Widget containerTest = Container(width: 200, height: 200);

      await tester.pumpWidget(
          TestApp(Row(children: <Widget>[containerTest.flexible(flex: 1)])));

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Flexible), findsOneWidget);
    });

    testWidgets('Test with only fit value', (WidgetTester tester) async {
      Widget containerTest = Container(width: 200, height: 200);

      await tester.pumpWidget(TestApp(
          Row(children: <Widget>[containerTest.flexible(fit: FlexFit.tight)])));

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Flexible), findsOneWidget);
    });

    testWidgets('Test with all values', (WidgetTester tester) async {
      Widget containerTest = Container(width: 200, height: 200);

      await tester.pumpWidget(TestApp(Row(children: <Widget>[
        containerTest.flexible(flex: 1, fit: FlexFit.tight)
      ])));

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Flexible), findsOneWidget);
    });
  });

  group('Tests for Expanded', () {
    testWidgets('Test with all values', (WidgetTester tester) async {
      Widget containerTest = Container(width: 200, height: 200);

      await tester.pumpWidget(
          TestApp(Row(children: <Widget>[containerTest.expanded(flex: 1)])));

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('Test with default values', (WidgetTester tester) async {
      Widget containerTest = Container(width: 200, height: 200);

      await tester.pumpWidget(
          TestApp(Row(children: <Widget>[containerTest.expanded()])));

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
    });
  });
}
