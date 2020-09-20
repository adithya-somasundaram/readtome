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


  _testDictionary(){
    var _testEntries = ["a", "aloud", "and", "active", "author", "at", "benefit", 
    "confirms", "chair", "department", "found", "from", "greatest", "involvement",
    "learning", "memory", "of", "participants", "professor", "psychology", "researchers",
    "recall", "read", "study", "says", "the", "that", "to", "themselves", "this",
    "university", "word", "was", "when"];

    var _testResults = {
      "a" : "1",
      "aloud":"singular of many louds",
      "and" : "&&",
      "active" : "me when I finally get back to running",
      "author" : "me writing this dictionary",
      "at" : "@",
      "benefit" : "benefit definition here",
      "confirms" : "I confirm this is the definition of confirm",
      "chair" : "Elephants cannot fit in most chairs :(",
      "department" : "there are currently 0 elephants employed at departments worldwide",
      "found" : "Found the definition for found!",
      "from" : "to you, from me",
      "greatest" : "greater than greater = greatest",
      "involvement" : "Fun fact: the word 'involvement' has 11 letters",
      "learning" : "what you are doing right now",
      "memory" : "an elephant is good at this",
      "of" : "of course I will tell you the definition of of. The definition of of is of",
      "participants" : "those who participate.",
      "professor" : "a teacher except cooler",
      "psychology" : "psych!",
      "researchers"  : "Definition for researchers",
      "recall" : "I recall entering the definition of recall",
      "read" : "readtome",
      "study" : "what students love",
      "says" : "dog says woof aka hello",
      "the" : "Message goes here",
      "that" : "Insert definition of that here",
      "to" : "2 except not a number",
      "themselves":"yourselves",
      "this" : "no no that! this",
      "university" : "shout out to ucsc",
      "word" : "the word you selected is word",
      "was" : "Adithya was here.",
      "when" : "whenwhenwhen"
    };

    for(var k in _testEntries){
      if (_testResults[k] != dictionary["dictionary"][k[0]][k]){
        print('Test error at key: ' + k);
        return;
      }
    }
    print('Dictionary test cases pass!');
  }

  // loads dictionary.json file from assets
  Future<String> _loadDictionary() async{
    return await rootBundle.loadString("assets/dictionary.json");
  }

  // reads dictionary.json file
  Future _storeDictionary() async{
    String result = await _loadDictionary();
    dictionary = jsonDecode(result);

    // Uncomment below to run dictionary test
    // _testDictionary();
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

      /* following code queries an individual word, rather than read it from stored 
      dictionary, can replace previous line */
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