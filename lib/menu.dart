import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'game.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _db = FirebaseDatabase.instance.ref();
  String nickname = 'achatin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 140, 92),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.home, size: 40),
    
              GestureDetector(
                onTap: () async {
    
                  final _players = await _db.child('players').get();
    
                  for (int i = 0; i < _players.children.length; i++) {
                    if (_players.children.elementAt(i).key == nickname) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GameScreen(ref: _players.children.elementAt(i).ref)));
                    }
                  }
    
                },
                child: const Icon(Icons.border_all_rounded, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}