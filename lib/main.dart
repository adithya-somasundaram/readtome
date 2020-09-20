import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import './home.dart';
import './entry.dart';

void main() {
  // runApp(MyApp());

  Widget _createTest({Widget input}){
    return MaterialApp(home: input);
  }

  testWidgets("Testing home screen", (WidgetTester test) async {
    await test.pumpWidget(_createTest(input: Home(title: 'Read to Me')));

    final titleFind = find.text('Read to Me');

    expect(titleFind, findsOneWidget);
  });

  testWidgets("Testing entry screen", (WidgetTester test) async {
    await test.pumpWidget(_createTest(input: Entry(title: 'test', message: 'testing\nmessage')));

    final titleFind = find.text('test');
    // final testingFind = find.text('testing');
    // final messageFind = find.text('message');

    expect(titleFind, findsOneWidget);
    // expect(testingFind, findsOneWidget);
    // expect(messageFind, findsOneWidget);
  });

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(title: 'Read to Me'),
    );
  }
}