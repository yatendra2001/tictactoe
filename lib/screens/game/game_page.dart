import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tictactoe/app_init/app_init_bloc.dart';
import 'package:tictactoe/screens/widgets/field.dart';
import 'package:tictactoe/screens/game/game_presenter.dart';

import 'package:tictactoe/utils/assets_constants.dart';
import 'package:tictactoe/utils/theme_constants.dart';

import '../../repositories/repositories.dart';

class GamePage extends StatefulWidget {
  static const routeName = "/game-page";
  const GamePage({Key? key}) : super(key: key);

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  late List<int> board;
  late int _currentPlayer;

  late GamePresenter _presenter;

  GamePageState() {
    _presenter = GamePresenter(_movePlayed, _onGameEnd);
  }

  void _onGameEnd(int winner) {
    var title = "Game over!";
    var content = "You lose :(";
    switch (winner) {
      case Ai.human: // will never happen :)
        title = "Congratulations!";
        content = "You managed to beat an unbeatable AI!";
        break;
      case Ai.ai:
        title = "Game Over!";
        content = "You lose :(";
        break;
      default:
        title = "Draw!";
        content = "No winners here.";
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    setState(() {
                      reinitialize();
                      Navigator.of(context).pop();
                    });
                  },
                  child: const Text("Restart"))
            ],
          );
        });
  }

  void _movePlayed(int idx) {
    setState(() {
      board[idx] = _currentPlayer;

      if (_currentPlayer == Ai.human) {
        // switch to AI player
        _currentPlayer = Ai.ai;
        _presenter.onHumanPlayed(board);
      } else {
        _currentPlayer = Ai.human;
      }
    });
  }

  String getSymbolForIdx(int idx) {
    return Ai.symbols[board[idx]]!;
  }

  @override
  void initState() {
    super.initState();
    reinitialize();
  }

  void reinitialize() {
    _currentPlayer = Ai.human;
    // generate the initial board
    board = List.generate(9, (idx) => 0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Welcome to Tic Tac Toe",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: kColorGrey,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(homeScreenImage), fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: <Widget>[
                const Text(
                  "You're playing as X",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: kColorWhite,
                      fontSize: 20),
                ),
                const SizedBox(height: 50),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    // generate the widgets that will display the board
                    children: List.generate(9, (idx) {
                      return Field(
                          idx: idx,
                          onTap: _movePlayed,
                          playerSymbol: getSymbolForIdx(idx));
                    }),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    elevatedButtonWidget(
                        context: context,
                        text: "Repeat the game",
                        icon: const Icon(Icons.replay),
                        callback: () {
                          setState(() {
                            reinitialize();
                          });
                        }),
                    elevatedButtonWidget(
                        context: context,
                        text: "Logout",
                        icon: const Icon(Icons.logout),
                        callback: () {
                          BlocProvider.of<AppInitBloc>(context)
                              .add(AuthLogoutRequested());
                        }),
                  ],
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton elevatedButtonWidget(
      {required BuildContext context,
      required String text,
      required Icon icon,
      required VoidCallback callback}) {
    return ElevatedButton.icon(
        icon: icon,
        onPressed: callback,
        label: Text(text),
        style: ElevatedButton.styleFrom(
          primary: kColorGrey,
        ));
  }
}
