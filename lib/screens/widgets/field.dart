import 'package:flutter/material.dart';

import 'package:tictactoe/utils/theme_constants.dart';

class Field extends StatelessWidget {
  final int idx;
  final Function(int idx) onTap;
  final String playerSymbol;

  const Field({
    Key? key,
    required this.idx,
    required this.onTap,
    required this.playerSymbol,
  }) : super(key: key);
  void _handleTap() {
    // only send tap events if the field is empty
    if (playerSymbol == "") onTap(idx);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        margin: const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          color: kColorWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
            child: Text(playerSymbol,
                style: const TextStyle(fontSize: 50, color: kColorGrey))),
      ),
    );
  }
}
