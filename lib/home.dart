import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './entry.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  // store inputted title
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  /* --- Test function --- */

  _testDictionary() async{
    var dictionary = await _storeEntries();

    // all entry names to be tested
    var testEntries = ["main entry", "long entry"];

    // all entries to be tested
    var testResults = [
      "The researchers found that word recall was greatest when the participants read aloud to themselves.\n\n“This study confirms that learning and memory benefit from active involvement,” says study author Colin M. MacLeod, a professor and chair of the Department of Psychology at the University of Waterloo.",
      "The researchers found that word recall was greatest when the participants read aloud to themselves.\n\n“This study confirms that learning and memory benefit from active involvement,” says study author Colin M. MacLeod, a professor and chair of the Department of Psychology at the University of Waterloo. The researchers found that word recall was greatest when the participants read aloud to themselves.\n\n“This study confirms that learning and memory benefit from active involvement,” says study author Colin M. MacLeod, a professor and chair of the Department of Psychology at the University of Waterloo."
    ];

    for(int i = 0; i < testEntries.length; i++){
      if(dictionary['entries'][i]['name'] != testEntries[i] || dictionary['entries'][i]['passage'] != testResults[i]){
        print('Test error at key: ' + testEntries[i]);
      }
    }
    print('Entries test cases pass!');
  }
  /* ------------------------------ */

  /* --- JSON related functions --- */

  // loads data from passages.json
  Future<String> _loadEntries() async {
    return await rootBundle.loadString("assets/passages.json");
  }

  // reads and returns passages.json
  Future _storeEntries() async {
    String result = await _loadEntries();
    return jsonDecode(result);
  }
  /* ------------------------------ */

  /* --- Build related functions --- */

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
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // // Uncomment next line to test dictionary read
    // _testDictionary();
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
  /* ----------------------------------------- */
}
