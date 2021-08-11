import 'package:flutter/material.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/utils/size_config.dart';

class ColoredButton extends StatelessWidget {
  final String text;
  final void Function() function;
  final Icon? icon;
  final Color? myColor;

  const ColoredButton({required this.text, required this.function, this.icon, this.myColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      child: icon != null ? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          SizedBox(width: 5,),
          Text(text, style: TextStyle(
              color: myColor ??  Colors.white,
              fontSize: 3.6 * textMultiplier
          ),)
        ],
      ) : Text(text, style: TextStyle(
        color: Colors.white,
        fontSize: 3.6 * textMultiplier
      ),),
      style: ElevatedButton.styleFrom(
          primary: myColor != null ? Colors.white : mainColor,
          onPrimary: myColor ?? secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          )),
    );
  }
}
