import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';

class Entry extends StatefulWidget {
  Entry({Key key, this.title, this.message}) : super(key: key);

  final String title;
  final String message;

  @override
  _EntryState createState() => _EntryState();
}

class _EntryState extends State<Entry> {

  var dictionary;
  bool _select = false;

  // displays definition of clickable words
  _showDefinition(BuildContext context, String word) {
    if(_select){
      if (!isAlpha(word)) {
        while (!isAlpha(word[0])) {
          word = word.substring(1);
        }
        while (!isAlpha(word[word.length - 1])) {
          word = word.substring(0, word.length - 1);
        }
      }
      var def = dictionary['dictionary'][word.toLowerCase()[0]][word.toLowerCase()];
      if (def != null){
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text(word), content: Text(def));
          }
        );
      }
    }
  }

  // generates words displayed on screen. Makes non-empty words clickable
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

  Future<String> _loadDictionary() async{
    return await rootBundle.loadString("assets/dictionary.json");
  }

  Future _storeDictionary() async{
    String result = await _loadDictionary();
    dictionary = jsonDecode(result);
  }

  @override
  void initState(){
    super.initState();
    _storeDictionary();
  }

  @override
  Widget build(BuildContext context) {
    // split words from other words, including whitespaces
    var _text = widget.message.split(RegExp(r"((?<=\s)|(?=\s))"));
    
    return Scaffold(
        appBar: AppBar(
          // set title
          title: Text(widget.title),
        ),
        body: Container(
          // add padding for text
          padding: EdgeInsets.all(15),
          child: Column(
            // set start point for text
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RichText(
                    text: TextSpan(
                        // set text style
                        style: TextStyle(color: Colors.black, fontSize: 20, height: 1.5),
                        children: <TextSpan>[
                      for (var i in _text) _displayWord(context, i),
                    ])),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: SwitchListTile(
                      title: Text("Display definition on tap: "),
                      value: _select,
                      onChanged: (val) {
                        setState(() {
                          _select = val;
                        });
                      }
                    )
                  )
                ),
              ]),
        ));
  }
}