import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:string_validator/string_validator.dart';

class Entry extends StatefulWidget {
  Entry({Key key, this.title, this.message}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String message;

  @override
  _EntryState createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  _showDefinition(BuildContext context, String word) {
    if (!isAlpha(word)) {
      while (!isAlpha(word[0])) {
        word = word.substring(1);
      }
      while (!isAlpha(word[word.length - 1])) {
        word = word.substring(0, word.length - 1);
      }
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(word), content: Text('definition here'));
        });
  }

  _displayWord(BuildContext context, String word) {
    if (word == " " || word =="\n" || word == "\r" || word == "\t"){
      return TextSpan(
        text: word
      );
    }
    return TextSpan(
        text: word,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _showDefinition(context, word);
          }
    );
  }

  @override
  Widget build(BuildContext context) {
    var test2 = widget.message.split(RegExp(r"((?<=\s)|(?=\s))"));
    print(test2);
    // RegExp exp = new RegExp(r"(\w+)");
    // String str = "Parse my string";
    // Iterable<RegExpMatch> matches = exp.allMatches(widget.message);
    // matches.forEach((m)=>print(m.group(0)));
    var test = ['hi', 'there'];

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 20),
                children: <TextSpan>[
              for (var i in test2) _displayWord(context, i)
            ]))
      ]

              // <Widget>[
              //   RichText(
              //     text: TextSpan(
              //         style: TextStyle(color: Colors.black, fontSize: 20),
              //         children: <TextSpan>[
              //           TextSpan(
              //               text: widget.message,
              //               recognizer: TapGestureRecognizer()
              //                 ..onTap = () {
              //                   _showDefinition(context);
              //                 })
              //         ]),
              //   )
              // ],
              ),
    );
  }
}
