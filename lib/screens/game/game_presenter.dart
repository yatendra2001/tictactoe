import 'dart:async';

import 'package:tictactoe/repositories/ai/utils.dart';

import '../../repositories/repositories.dart';

class GamePresenter {
  // callbacks into our UI
  void Function(int idx) showMoveOnUi;
  void Function(int winningPlayer) showGameEnd;

  Ai _aiPlayer = Ai();

  GamePresenter(this.showMoveOnUi, this.showGameEnd) {
    _aiPlayer = Ai();
  }

  void onHumanPlayed(List<int> board) async {
    // evaluate the board after the human player
    int evaluation = Utils.evaluateBoard(board);
    if (evaluation != Ai.noWinner) {
      onGameEnd(evaluation);
      return;
    }

    // calculate the next move, could be an expensive operation
    int aiMove =
        await Future(() => _aiPlayer.play(board: board, currentPlayer: Ai.ai));

    // do the next move
    board[aiMove] = Ai.ai;

    // evaluate the board after the AI player move
    evaluation = Utils.evaluateBoard(board);
    if (evaluation != Ai.noWinner) {
      onGameEnd(evaluation);
    } else {
      showMoveOnUi(aiMove);
    }
  }

  void onGameEnd(int winner) {
    showGameEnd(winner);
  }
}
