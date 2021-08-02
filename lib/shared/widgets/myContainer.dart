import 'package:flutter/material.dart';
import 'package:todo/utils/size_config.dart';

class MyContainer extends StatelessWidget {
  final Widget child;

  const MyContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
    //  margin: EdgeInsets.symmetric(horizontal: 2 * widthMultiplier ),
     padding: EdgeInsets.only(bottom: 1 * heightMultiplier, top: 1.5 * heightMultiplier),
      width: 83 * widthMultiplier,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      child: child,
    );
  }
}
