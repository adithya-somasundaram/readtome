import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import './home.dart';
import './entry.dart';

void main() {
  runApp(MyApp());

  testWidgets("Testing home screen", (WidgetTester test) async {
    await test.pumpWidget(MyHomePage(title: 'Read to Me'));

    final titleFind = find.text('Read to Me');

    expect(titleFind, findsOneWidget);
  });

  testWidgets("Testing entry screen", (WidgetTester test) async {
    await test.pumpWidget(Entry(title: 'test', message: 'test message'));

    final titleFind = find.text('test');
    final messageFind = find.text('test message');

    expect(titleFind, findsOneWidget);
    expect(messageFind, findsOneWidget);
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
      home: MyHomePage(title: 'Read to Me'),
    );
  }
}