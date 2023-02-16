
import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamController<String> _streamController;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<String>();
    // Future.delayed(Duration(milliseconds: 350), () {
    //   _sendNext();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
              ),
              // HSYNumberWheelText(
              //   text: '2323.43',
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   // animatedFirst: false,
              //   onAnimation: (String old) {
              //     return _streamController;
              //   },
              //   textHeights: 50.0,
              //   textStyle: TextStyle(
              //     color: Colors.white,
              //     fontSize: 24,
              //   ),
              // ),
              SizedBox(
                height: 80,
              ),
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  child: Text('clicke me'),
                  color: Colors.amber,
                  width: 100,
                  height: 100,
                ),
                onTap: () {
                  _sendNext();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendNext() {
    num next = (Random().nextInt(1000)).toDouble() +
        (Random().nextDouble().toDouble());
    _streamController.sink.add(next.toString());
  }
}
