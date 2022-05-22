import 'package:flutter/material.dart';

import 'constants.dart';

class Moves extends StatelessWidget {
  final function;
  const Moves({Key? key, this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: function,
        child: Container(
          decoration: BoxDecoration(
            //border: Border.all(color: voidBlue, width: 3),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: voidBlue,
                offset: Offset(1.1, 4.0),
                blurRadius: 8.0,
              ),
            ],
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
