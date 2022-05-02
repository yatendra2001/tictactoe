import 'package:tictactoe/models/move.dart';

abstract class BaseAi {
  int play({required List<int> board, required int currentPlayer});
  int getBestScore({required List<int> board, required int currentPlayer});
  Move getBestMove({required List<int> board, required int currentPlayer});
}
