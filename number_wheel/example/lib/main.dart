import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:number_wheel/idler_wheel.dart';
import 'package:number_wheel/wheel_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueController _controller = ValueController();

  @override
  void initState() {
    super.initState();
    _update();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue,
                      Colors.white,
                      Colors.white,
                      Colors.white,
                      Colors.white,
                      Colors.white,
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 200,
                      margin: EdgeInsets.symmetric(horizontal: 24.0)
                          .copyWith(bottom: 50),
                      color: Colors.lightGreen,
                    );
                  },
                  itemCount: 100,
                ),
              ),
              // Stack(
              //   alignment: AlignmentDirectional.centerStart,
              //   fit: StackFit.expand,
              //   children: [
              //     Positioned(
              //       child: Container(
              //         decoration: BoxDecoration(
              //           gradient: LinearGradient(
              //             colors: [
              //               Colors.blue,
              //               Colors.white,
              //             ],
              //             begin: Alignment.topCenter,
              //             end: Alignment.bottomCenter,
              //           ),
              //         ),
              //       ),
              //     ),
              //     ListView.builder(
              //       shrinkWrap: true,
              //       physics: NeverScrollableScrollPhysics(),
              //       itemBuilder: (BuildContext context, int index) {
              //         return Container(
              //           height: 200,
              //           margin: EdgeInsets.symmetric(horizontal: 24.0)
              //               .copyWith(bottom: 50),
              //           color: Colors.lightGreen,
              //         );
              //       },
              //       itemCount: 100,
              //     ),
              //   ],
              // ),
            ],
          ),
        ),

        // home: Stack(
        //   alignment: AlignmentDirectional.centerStart,
        //   fit: StackFit.expand,
        //   children: [
        //     Positioned(
        //       child: Container(
        //         decoration: BoxDecoration(
        //           gradient: LinearGradient(
        //             colors: [
        //               Colors.blue,
        //               Colors.white,
        //             ],
        //             begin: Alignment.topCenter,
        //             end: Alignment.bottomCenter,
        //           ),
        //         ),
        //       ),
        //     ),
        //     ListView.builder(
        //       itemBuilder: (BuildContext context, int index) {
        //         return Container(
        //           height: 200,
        //           margin: EdgeInsets.symmetric(horizontal: 24.0)
        //               .copyWith(bottom: 50),
        //           color: Colors.lightGreen,
        //         );
        //       },
        //       itemCount: 100,
        //     ),
        //   ],
        // ),

        // home: Scaffold(
        //   backgroundColor: Colors.black,
        //   appBar: AppBar(
        //     title: const Text('Plugin example app'),
        //   ),
        //   body: Center(
        //     child: IdlerWheel(
        //       valueController: _controller,
        //       useSeparator: true,
        //     ),
        //   ),
        // ),
      ),
    );
  }

  void _update() {
    final news = double.parse(_controller.text) + 100.0;
    Future.delayed(
      Duration(seconds: 1),
      () {
        _controller.setText = news.toString();
        _update();
      },
    );
  }
}
