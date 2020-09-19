import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './entry.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // store inputted title
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // loads data from passages.json
  Future<String> _loadEntries() async {
    return await rootBundle.loadString("assets/passages.json");
  }

  // reads and returns passages.json
  Future _storeEntries() async {
    String result = await _loadEntries();
    return jsonDecode(result);
  }

  // returns card wrapped in gestureDector to sense onTap
  _displayEntry(name, msg) {
    return GestureDetector(
      // onTap push to entry.dart page w/ corresponding title and message
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Entry(title: name, message: msg)));
      },
      // selectable card with corresponding title name
      child: new Card(
        child: ListTile(
          title: Text(name),
          trailing: Icon(Icons.arrow_forward_ios),
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
        // building w/FutureBuilder since json read returns Future type
        child: FutureBuilder(
          future: _storeEntries(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<Widget> result;
            if (snapshot.hasData) {
              result = <Widget>[
                for (var e in snapshot.data['entries'])
                  _displayEntry(e['name'], e['passage'])
              ];
            } else if (snapshot.hasError) {
              result = <Widget>[
                Text('Error fetching data!')
              ];
            } else {
              result = <Widget>[
                Text('Loading...')
              ];
            }
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: result
            );
          }
        )
      ),
    );
  }
}
