import 'package:flutter/material.dart';
import 'package:tic_tac_toe/ui/theme/color.dart';
import 'package:tic_tac_toe/utils/game_logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String lastValue = "X";
  bool gameOver = false;

  int turn = 0;

  String result = "";

  List<int> scoreBoard = [0, 0, 0, 0, 0, 0, 0, 0];

  Game game = Game();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    game.board = Game.initGameBoard();
    print(game.board);
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: MainColor.primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "It´s $lastValue turn".toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: boardWidth,
              height: boardWidth,
              child: GridView.count(
                crossAxisCount: Game.boardLenght ~/ 3,
                padding: const EdgeInsets.all(16),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: List.generate(Game.boardLenght, (index) {
                  return InkWell(
                    onTap: gameOver
                        ? null
                        : () {
                            if (game.board![index] == "") {
                              setState(() {
                                game.board![index] = lastValue;
                                turn++;
                                gameOver = game.winnerCheck(
                                    lastValue, index, scoreBoard, 3);

                                if (gameOver) {
                                  result =
                                      lastValue == "X" ? "X Wins" : "O Wins";
                                } else if (turn == 9) {
                                  result = "Draw";
                                  gameOver = true;
                                }

                                if (lastValue == "X") {
                                  lastValue = "O";
                                } else {
                                  lastValue = "X";
                                }
                              });
                            }
                          },
                    child: Container(
                      width: Game.blockSize,
                      height: Game.blockSize,
                      decoration: BoxDecoration(
                        color: MainColor.secondaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          game.board![index],
                          style: TextStyle(
                            color: game.board![index] == "X"
                                ? Colors.blue
                                : Colors.black,
                            fontSize: 64,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              result,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    game.board = Game.initGameBoard();
                    lastValue = "X";
                    gameOver = false;
                    turn = 0;
                    result = "";
                    scoreBoard = [0, 0, 0, 0, 0, 0, 0, 0];
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Restart"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    MainColor.primaryColorDark,
                  ),
                ))
          ],
        ));
  }
}
