import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoverScreen extends StatelessWidget {
  final bool hasGameStarted;
  final bool isGameOver;

  CoverScreen({required this.hasGameStarted, required this.isGameOver});

  static var gameFont = GoogleFonts.pressStart2p(
      textStyle: TextStyle(
          color: Colors.deepPurple[600], letterSpacing: 0, fontSize: 28));

  @override
  Widget build(BuildContext context) {
    return hasGameStarted
        ? Container(
            alignment: Alignment(0, -0.5),
            child: Text(
              isGameOver ? '' : 'BRICK BREAKER',
              style: gameFont.copyWith(color: Colors.deepPurple[200]),
            ),
          )
        : Stack(
            children: [
              Container(
                alignment: Alignment(0, -0.5),
                child: Text(
                  'BRICK BREAKER',
                  style: gameFont,
                ),
              ),
              Container(
                alignment: Alignment(0, -0.1),
                child: Text(
                  'Tap to Play',
                  style: TextStyle(color: Colors.deepPurple[400]),
                ),
              )
            ],
          );
  }
}
