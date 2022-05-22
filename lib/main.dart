// ignore_for_file: avoid_print

import 'package:boo/menu.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom,
  ]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _app = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 140, 92),
        body: FutureBuilder(
              future: _app,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('You have an error! ${snapshot.error.toString()}');
                  return const Text('Something went wrong :(');
                } else if (snapshot.hasData) {
                  return HomePage();
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
      ));
  }
}