import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:string_validator/string_validator.dart';

class Entry extends StatefulWidget {
  Entry({Key key, this.title, this.message}) : super(key: key);

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
    if (word == " " || word == "\n" || word == "\r" || word == "\t") {
      return TextSpan(text: word);
    }
    return TextSpan(
        text: word,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _showDefinition(context, word);
          });
  }

  @override
  Widget build(BuildContext context) {
    var test2 = widget.message.split(RegExp(r"((?<=\s)|(?=\s))"));
    print(test2);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 20, height: 1.5),
                        children: <TextSpan>[
                      for (var i in test2) _displayWord(context, i)
                    ]))
              ]),
        ));
  }
}
