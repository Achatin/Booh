// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:boo/menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'dart:math';

import 'tile.dart';
import 'constants.dart';
import 'seeker.dart';
import 'moves.dart';

class GameScreen extends StatefulWidget {
  final ref;
  const GameScreen({Key? key, required this.ref})
      : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState(ref: ref);
}

class Player {
  String character = 'assets/images/skeleton.png';
  int position = 22;
  List possibleMoves = [17, 21, 23, null];
}

class Game {
  int gems = 0;
  List<int> tiles = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1];
  Player player = Player();
}

class _GameScreenState extends State<GameScreen> {
  final ref;
  bool isTickerStarted = false;
  _GameScreenState({required this.ref});

  var game = Game();

  void onJoin() async {
    final _gems = await ref.child('board/gems').get();
    setState(() {
      game.gems = int.parse(_gems.value.toString());
      for (int i = 0; i < game.tiles.length; i++) {
        var rng = Random();
        int tileValue = rng.nextInt(2)+1;
        game.tiles[i] = tileValue;
      }
    });
  }

  // S T A R T   T I C K E R
  void startTicker() {
    if (isTickerStarted == false) {
      onJoin();
      Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        int index = game.tiles.indexOf(0);
        if (index >= 0) {
          setState(() {

            var rng = Random();
            int tileValue = rng.nextInt(2)+1;
            game.tiles[index] = tileValue;

            game.player.possibleMoves[0] = ([0, 5, 10, 15, 20].contains(game.player.position) || game.tiles[game.player.position - 1] == 0) ? null : game.player.position - 1;
            game.player.possibleMoves[1] = ([0, 1, 2, 3, 4].contains(game.player.position) || game.tiles[game.player.position - 5] == 0) ? null : game.player.position - 5;
            game.player.possibleMoves[2] = ([4, 9, 14, 19, 24].contains(game.player.position) || game.tiles[game.player.position + 1] == 0) ? null : game.player.position + 1;
            game.player.possibleMoves[3] = ([20, 21, 22, 23, 24].contains(game.player.position) || game.tiles[game.player.position + 5] == 0) ? null : game.player.position + 5;
          
          });
        }
      });
      setState(() {
        isTickerStarted = true;
      });
    }
  }

  void onAllyJoin() async {
    // get ally's character
  }

  void update() {

    // *GEMS* && *ALLY POSITION* FROM DB
    /*ref.child('board/gems').onValue.listen((DatabaseEvent event) {
      if (game.gems != event.snapshot.value) {
        setState(() async {
          game.gems = int.parse(event.snapshot.value.toString());
        });
      }
    });*/
  }

  void moveSeeker(int index) {
    setState(() {
      game.player.position = index;

      game.gems += game.tiles[index];
      ref.child('board/').update({'gems': game.gems});

      game.tiles[index] = 0;


      game.player.possibleMoves[0] = ([0, 5, 10, 15, 20].contains(game.player.position) || game.tiles[game.player.position - 1] == 0) ? null : game.player.position - 1;
      game.player.possibleMoves[1] = ([0, 1, 2, 3, 4].contains(game.player.position) || game.tiles[game.player.position - 5] == 0) ? null : game.player.position - 5;
      game.player.possibleMoves[2] = ([4, 9, 14, 19, 24].contains(game.player.position) || game.tiles[game.player.position + 1] == 0) ? null : game.player.position + 1;
      game.player.possibleMoves[3] = ([20, 21, 22, 23, 24].contains(game.player.position) || game.tiles[game.player.position + 5] == 0) ? null : game.player.position + 5;

    });
  }

  @override
  Widget build(BuildContext context) {
    startTicker();

    update();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 140, 92),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // TOP BAR
            Text("${game.gems} Gems",
                style: GoogleFonts.dosis(
                    textStyle: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w100,
                        color: txtColor)
                )
            ),

            // GRID
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
                itemCount: 25,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5),
                itemBuilder: (context, index) {
                  if (index == game.player.position) {
                    return Seeker(avatar: game.player.character);
                  } else if (game.player.possibleMoves.contains(index)) {
                    return Moves(
                      function: () {
                        moveSeeker(index);
                      },
                    );
                  } else {
                    return Tile(value: game.tiles[index]);
                  }
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: const Icon(Icons.home, size: 40)
                ),
                const Icon(Icons.border_all_rounded, size: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
