import 'package:flutter/material.dart';
import 'package:todo/utils/size_config.dart';

class ColoredCircles extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Image.asset(
        'assets/images/colored_circle.png',
        height: 31 * heightMultiplier,
        width: 75 * imageSizeMultiplier,
        fit: BoxFit.fill,
      ),
    );
  }
}
