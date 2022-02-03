import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sudoku/sudoku_screen.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      title: 'Sudoku',
                    ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "images/splash.jpeg",
              height: 300,
              width: 300,
            ),
            const SizedBox(
              height: 32,
            ),
            Image.asset(
              "images/trf.png",
              height: 192,
              width: 192,
            ),
            Image.asset(
              "images/robodroid.jpg",
              height: 128,
              width: 256,
            ),
          ],
        ),
      ),
    );
  }
}
