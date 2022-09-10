import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameOverScreen extends StatelessWidget {
  final bool isGameOver;
  final Function() onResetGame;

  GameOverScreen({required this.isGameOver, required this.onResetGame});

  static var gameFont = GoogleFonts.pressStart2p(
      textStyle: TextStyle(
          color: Colors.deepPurple[600], letterSpacing: 0, fontSize: 28));

  @override
  Widget build(BuildContext context) {
    return isGameOver
        ? Stack(
            children: [
              Container(
                alignment: Alignment(0, -0.3),
                child: Text(
                  'GAME OVER',
                  style: gameFont,
                ),
              ),
              Container(
                alignment: Alignment(0, -0.1),
                child: GestureDetector(
                  onTap: onResetGame,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.deepPurple,
                      child: Text(
                        'PLAY AGAIN',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container();
  }
}
