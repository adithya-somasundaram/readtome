import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';

class Entry extends StatefulWidget {
  Entry({Key key, this.title, this.message}) : super(key: key);

  // store passed in title and message for entry
  final String title;
  final String message;

  @override
  _EntryState createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  // vars for dictionary and on/off switch
  var dictionary;
  bool _select = false;

  // loads dictionary.json file from assets
  Future<String> _loadDictionary() async{
    return await rootBundle.loadString("assets/dictionary.json");
  }

  // reads dictionary.json file
  Future _storeDictionary() async{
    String result = await _loadDictionary();
    dictionary = jsonDecode(result);
  }

  // reads dictionary.json and returns inputted word
  Future<String> _queryWord(word) async {
    String result = await _loadDictionary();
    return jsonDecode(result)['dictionary'][word[0]][word];
  }

  // displays definition of clickable words
  _showDefinition(BuildContext context, String word) async {
    // check for definition if switch is on
    if(_select){
      // following if statement ignores leading and trailing, nonAlphabet characters
      if (!isAlpha(word)) {
        while (!isAlpha(word[0])) {
          word = word.substring(1);
        }
        while (!isAlpha(word[word.length - 1])) {
          word = word.substring(0, word.length - 1);
        }
      }

      // get definition from dictionary
      var def = dictionary['dictionary'][word.toLowerCase()[0]][word.toLowerCase()];

      // following code queries an individual word, rather than read it from stored dictionary, can replace previous line
      // var def  = await _queryWord(word.toLowerCase());

      // show popup text if definition is found
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
    // return textspan w/o onTap method if word is blank space
    if (word == " " || word == "\n" || word == "\r" || word == "\t") {
      return TextSpan(text: word);
    }

    // return textspan with word and onTap function
    return TextSpan(
        text: word,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _showDefinition(context, word);
          });
  }

  // init state reads and stores dictionary.json locally
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
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: RichText(
                      text: TextSpan(
                        // set text style
                        style: TextStyle(color: Colors.black, fontSize: 20, height: 1.5),
                        children: <TextSpan>[
                          // call display function for each word in entry message
                          for (var w in _text) _displayWord(context, w),
                        ]
                      )
                    )
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.lightGreen[100],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          // set position to bottom of screen
                          alignment: FractionalOffset.bottomCenter,
                          child: SwitchListTile(
                            
                            title: Text("Display definition on tap: "),
                            value: _select,
                            // set _select to new switch val
                            onChanged: (val) {
                              setState(() {
                                _select = val;
                              });
                            }
                          )
                        )
                      )
                    ]
                  )
                )
                // expanded and align used to position switch at bottom of screen
                
              ]
            ),
    ));
  }
}