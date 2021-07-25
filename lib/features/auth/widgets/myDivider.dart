import 'package:flutter/material.dart';
import 'package:todo/utils/size_config.dart';

class MyDivider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10 * widthMultiplier),
      child: Divider(thickness: 0.2 * heightMultiplier,),
    );
  }
}
