import 'package:flutter/material.dart';

class Seeker extends StatelessWidget {
  String avatar;
  Seeker({required this.avatar, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Image.asset(avatar),
    );
  }
}
