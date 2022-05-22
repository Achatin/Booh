import 'package:flutter/material.dart';

import 'constants.dart';

class Tile extends StatelessWidget {
  final value;
  const Tile({Key? key, required this.value}) : super(key: key);

  Image? determineTile() {
    switch (value) {
      case 0: return null;
      case 1: return Image.asset('assets/images/white_tile.png');
      case 2: return Image.asset('assets/images/green_tile.png');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: determineTile(),
    );
  }
}
