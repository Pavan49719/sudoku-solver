import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sudoku/sudoku_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MyHomePage(
                    title: "Sudoku Solver",
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: Image.asset('images/pic1.jpeg'),
                ),
                Expanded(
                  flex: 2,
                  child: Image.asset('images/pic3.jpeg'),
                ),
                Expanded(
                  flex: 2,
                  child: Image.asset('images/pic2.jpeg'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
