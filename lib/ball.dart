import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  final double ballX;
  final double ballY;
  final bool hasGameStarted;
  final bool isGameOver;

  MyBall(
      {required this.ballX,
      required this.ballY,
      required this.hasGameStarted,
      required this.isGameOver});

  @override
  Widget build(BuildContext context) {
    return hasGameStarted
        ? Container(
            alignment: Alignment(ballX, ballY),
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: isGameOver ? Colors.deepPurple[300] : Colors.deepPurple,
                shape: BoxShape.circle,
              ),
            ),
          )
        : Container(
            alignment: Alignment(ballX, ballY),
            child: AvatarGlow(
              endRadius: 60.0,
              child: Material(
                elevation: 8,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurple[100],
                  radius: 7,
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
