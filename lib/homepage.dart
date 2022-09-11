import 'dart:async';

import 'package:brick_breaker/GameObject/ball.dart';
import 'package:brick_breaker/GameObject/my_brick.dart';
import 'package:brick_breaker/GameObject/player.dart';
import 'package:brick_breaker/cover_screen.dart';
import 'package:brick_breaker/game_over_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  double ballY = 0;
  double ballX = 0;
  double ballXIncrements = 0.02;
  double ballYIncrements = 0.01;

  double playerX = -0.2;
  double playerWidth = 0.4;

  bool hasGameStarted = false;
  bool isGameOver = false;

  var ballXDirection = Direction.LEFT;
  var ballYDirection = Direction.DOWN;

  static double firstBrickX = -1 + wallGap;
  static double firstBrickY = -0.9;
  static double brickWidth = 0.4;
  static double brickHeight = 0.08;
  static double brickGap = 0.05;
  static int numberOfBricksInRow = 3;
  static double wallGap = 0.5 *
      (2 -
          numberOfBricksInRow * brickWidth -
          (numberOfBricksInRow - 1) * brickGap);
  bool brickBroken = false;

  List myBricks = [
    [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false],
    [
      firstBrickX + 0 * (brickWidth + brickGap),
      firstBrickY + brickHeight + brickGap,
      false
    ],
    [
      firstBrickX + 1 * (brickWidth + brickGap),
      firstBrickY + brickHeight + brickGap,
      false
    ],
    [
      firstBrickX + 2 * (brickWidth + brickGap),
      firstBrickY + brickHeight + brickGap,
      false
    ],
  ];

  void startGame() {
    if (!hasGameStarted) {
      hasGameStarted = true;
      Timer.periodic(const Duration(milliseconds: 10), (timer) {
        moveBall();

        updateDirection();

        if (isPlayerDead()) {
          timer.cancel();
          isGameOver = true;
        }

        checkForBrokenBricks();
      });
    }
  }

  void checkForBrokenBricks() {
    for (int i = 0; i < myBricks.length; i++) {
      if (ballX >= myBricks[i][0] &&
          ballX <= myBricks[i][0] + brickWidth &&
          ballY <= myBricks[i][1] + brickHeight &&
          myBricks[i][2] == false) {
        setState(() {
          myBricks[i][2] = true;

          double leftSideDist = (myBricks[i][0] - ballX).abs();
          double rightSideDist = (myBricks[i][0] + brickWidth - ballX).abs();
          double topSideDist = (myBricks[i][0] - ballY).abs();
          double bottomSideDist = (myBricks[i][0] + brickHeight - ballY).abs();

          String min = findMin(
              [leftSideDist, rightSideDist, topSideDist, bottomSideDist]);
          switch (min) {
            case 'left':
              ballXDirection = Direction.LEFT;
              break;
            case 'right':
              ballXDirection = Direction.RIGHT;
              break;
            case 'top':
              ballYDirection = Direction.UP;
              break;
            case 'bottom':
              ballYDirection = Direction.DOWN;
              break;
          }
        });
      }
    }
  }

  String findMin(List numberList) {
    double currentMin = numberList.first;
    for (int i = 0; i < numberList.length; i++) {
      if (numberList[i] < currentMin) {
        currentMin = numberList[i];
      }
    }

    if ((currentMin - numberList[0]).abs() < 0.01) {
      return 'left';
    } else if ((currentMin - numberList[1]).abs() < 0.01) {
      return 'right';
    } else if ((currentMin - numberList[2]).abs() < 0.01) {
      return 'top';
    } else if ((currentMin - numberList[3]).abs() < 0.01) {
      return 'bottom';
    }

    return 'bottom';
  }

  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    }

    return false;
  }

  void moveBall() {
    setState(() {
      // move horizontally
      if (ballXDirection == Direction.LEFT) {
        ballX -= ballXIncrements;
      } else if (ballXDirection == Direction.RIGHT) {
        ballX += ballXIncrements;
      }

      // move vertically
      if (ballYDirection == Direction.DOWN) {
        ballY += ballYIncrements;
      } else if (ballYDirection == Direction.UP) {
        ballY -= ballYIncrements;
      }
    });
  }

  void updateDirection() {
    setState(() {
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth) {
        ballYDirection = Direction.UP;
      } else if (ballY <= -1) {
        ballYDirection = Direction.DOWN;
      }

      if (ballX >= 1) {
        ballXDirection = Direction.LEFT;
      } else if (ballX <= -1) {
        ballXDirection = Direction.RIGHT;
      }
    });
  }

  void moveLeft() {
    setState(() {
      if (!(playerX <= -1)) {
        playerX -= 0.05;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (!(playerX + playerWidth >= 1)) {
        playerX += 0.05;
      }
    });
  }

  void resetGame() {
    setState(() {
      playerX = -0.2;
      ballX = 0;
      ballY = 0;
      isGameOver = false;
      hasGameStarted = false;
      myBricks = [
        [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false],
        [
          firstBrickX + 0 * (brickWidth + brickGap),
          firstBrickY + brickHeight + brickGap,
          false
        ],
        [
          firstBrickX + 1 * (brickWidth + brickGap),
          firstBrickY + brickHeight + brickGap,
          false
        ],
        [
          firstBrickX + 2 * (brickWidth + brickGap),
          firstBrickY + brickHeight + brickGap,
          false
        ],
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
      },
      child: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 0) {
            moveRight();
          }
          if (details.delta.dx < 0) {
            moveLeft();
          }
        },
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.deepPurple[100],
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Stack(
                children: [
                  // tap to play
                  CoverScreen(
                      hasGameStarted: hasGameStarted, isGameOver: isGameOver),

                  // game over screen
                  GameOverScreen(
                    isGameOver: isGameOver,
                    onResetGame: resetGame,
                  ),

                  // ball
                  MyBall(
                    ballX: ballX,
                    ballY: ballY,
                    hasGameStarted: hasGameStarted,
                    isGameOver: isGameOver,
                  ),

                  // player
                  Player(playerX: playerX, playerWidth: playerWidth),

                  // bricks
                  MyBrick(
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickX: myBricks[0][0],
                    brickY: myBricks[0][1],
                    brickBroken: myBricks[0][2],
                  ),
                  MyBrick(
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickX: myBricks[1][0],
                    brickY: myBricks[1][1],
                    brickBroken: myBricks[1][2],
                  ),
                  MyBrick(
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickX: myBricks[2][0],
                    brickY: myBricks[2][1],
                    brickBroken: myBricks[2][2],
                  ),
                  MyBrick(
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickX: myBricks[3][0],
                    brickY: myBricks[3][1],
                    brickBroken: myBricks[3][2],
                  ),
                  MyBrick(
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickX: myBricks[4][0],
                    brickY: myBricks[4][1],
                    brickBroken: myBricks[4][2],
                  ),
                  MyBrick(
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickX: myBricks[5][0],
                    brickY: myBricks[5][1],
                    brickBroken: myBricks[5][2],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
