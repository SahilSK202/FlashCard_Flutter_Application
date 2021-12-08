import 'dart:io';

import 'package:flashcard_app/flashcard_view.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

import 'flashcard.dart';

class QuestionScreen extends StatefulWidget {
  final heading;
  const QuestionScreen({Key? key, this.heading}) : super(key: key);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  String _heading = "";

  List<List<dynamic>> _data = [];
  List<Flashcard> _flashcards = [];

  int _currentIndex = 0;
  bool _isFront = true;

  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  void initState() {
    super.initState();

    _loadCSV();

    // _getFlashcards();
  }

  Future<bool> _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/data/data.csv");
    setState(() {
      _data = CsvToListConverter().convert(_rawData);
      _data.forEach((element) {
        if (element[0].toString() == _heading) {
          _flashcards.add(Flashcard(
              question: element[1].toString(), answer: element[2].toString()));
        }
      });
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _heading = ModalRoute.of(context)!.settings.arguments as String;

    return _flashcards.length <= 1
        ? new Scaffold(
            appBar: new AppBar(
              title: new Text(_heading),
              backgroundColor: Colors.red[700],
            ),
            body: Center(
              child: Text("Data Not Found :("),
            ),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                  automaticallyImplyLeading: true,
                  title: Text(_heading),
                  elevation: 0.00,
                  // backgroundColor: Colors.greenAccent[400],
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context, false),
                  )), //AppBar
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      height: 400,
                      child: FlipCard(
                        key: cardKey,

                        direction: _currentIndex % 2 == 0
                            ? FlipDirection.VERTICAL
                            : FlipDirection.HORIZONTAL, // default
                        front: Container(
                          child: TextButton(
                            onPressed: () => onCardClick(false),
                            child: FlashcardView(
                                title: 'Question ${_currentIndex + 1}',
                                text: _flashcards[_currentIndex].question),
                            style: ButtonStyle(
                                splashFactory: NoSplash.splashFactory),
                          ),
                        ),
                        back: Container(
                          child: TextButton(
                            onPressed: () => onCardClick(true),
                            child: FlashcardView(
                                title: 'Answer',
                                text: _flashcards[_currentIndex].answer),
                            style: ButtonStyle(
                                splashFactory: NoSplash.splashFactory),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton.icon(
                          onPressed: showPreviousCard,
                          label: Text(
                            'Prev',
                            style: TextStyle(color: Colors.black),
                          ),
                          icon: Icon(Icons.fast_rewind_rounded),
                        ),
                        OutlinedButton.icon(
                          onPressed: showNextCard,
                          label: Text(
                            'Next',
                            style: TextStyle(color: Colors.black),
                          ),
                          icon: Icon(Icons.fast_forward_rounded),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }

  void showNextCard() {
    setState(() {
      if (!_isFront) {
        _isFront = true;
        cardKey.currentState!.toggleCard();
      }
      sleep(new Duration(milliseconds: 500));
      _currentIndex =
          (_currentIndex + 1 < _flashcards.length) ? _currentIndex + 1 : 0;
    });
  }

  void showPreviousCard() {
    setState(() {
      if (!_isFront) {
        _isFront = true;
        cardKey.currentState!.toggleCard();
      }

      sleep(new Duration(milliseconds: 500));
      _currentIndex =
          (_currentIndex - 1 >= 0) ? _currentIndex - 1 : _flashcards.length - 1;
    });
  }

  void onCardClick(bool val) {
    setState(() {
      _isFront = val;
      cardKey.currentState!.toggleCard();
    });
  }
}
