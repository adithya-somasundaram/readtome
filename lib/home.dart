import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './entry.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> _loadEntries() async {
    return await rootBundle.loadString("assets/passages.json");
  }

  Future _storeEntries() async {
    String result = await _loadEntries();
    return jsonDecode(result);
  }

  _helper(name, msg) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Entry(title: name, message: msg)));
      },
      child: new Card(
        child: ListTile(
          title: Text(name),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder(
              future: _storeEntries(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                List<Widget> result;
                if (snapshot.hasData) {
                  result = <Widget>[
                    for (var x in snapshot.data['entries'])
                      _helper(x['name'], x['passage'])
                  ];
                } else if (snapshot.hasError) {
                  result = <Widget>[
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Result: ${snapshot.data}'),
                    )
                  ];
                } else {
                  result = <Widget>[
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Result: ${snapshot.data}'),
                    )
                  ];
                }
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: result);
              })),
    );
  }
}
