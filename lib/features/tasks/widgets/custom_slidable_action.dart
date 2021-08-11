import 'package:flutter/material.dart';
import 'package:todo/utils/size_config.dart';

class MySlideAction extends StatelessWidget {
  final bool isFirst;
  final IconData icon;
  final Color color;
  final String title;
  final Function onPress;

  const MySlideAction(
      {required this.isFirst,
      required this.icon,
      required this.color,
      required this.title,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    final Color estimatedColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.light
            ? Colors.black
            : Colors.white;
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Container(
        height: 13 * heightMultiplier,
        width: 20 * widthMultiplier,
        margin: EdgeInsets.symmetric(vertical: 0.5 * heightMultiplier),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                  child: Icon(
                icon,
                color: estimatedColor,
              )),
              Flexible(
                  child: Text(title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .caption!
                          .copyWith(color: estimatedColor))),
            ],
          ),
        ),
        decoration: BoxDecoration(
            color: color,
            borderRadius: isFirst
                ? BorderRadius.horizontal(left: Radius.circular(15))
                : BorderRadius.horizontal(right: Radius.circular(15))),
      ),
    );
  }
}
