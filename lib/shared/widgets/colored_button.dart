import 'package:flutter/material.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/utils/size_config.dart';

class ColoredButton extends StatelessWidget {
  final String text;
  final void Function() function;

  const ColoredButton({required this.text, required this.function});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      child: Text(text, style: TextStyle(
        color: Colors.white,
        fontSize: 3.6 * textMultiplier
      ),),
      style: ElevatedButton.styleFrom(
          primary: mainColor,
          onPrimary: Colors.grey[500],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          )),
    );
  }
}
