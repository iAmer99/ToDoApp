import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/shared/widgets/colored_circles.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/utils/size_config.dart';

class SyncScreen extends StatelessWidget {
 static const String routeName = "/sync_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ColoredCircles(),
          Align(
            alignment: Alignment.center,
            child: Container(
              child: SvgPicture.asset(
                "assets/svg/name.svg",
                alignment: Alignment.center,
                color: mainColor,
                width: 36.5 * imageSizeMultiplier,
                height: 36.5 * imageSizeMultiplier,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10 * heightMultiplier ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 3 * widthMultiplier,),
                  Text("Syncing", style: TextStyle(
                    color: mainColor,
                    fontSize: 3.6 * textMultiplier
                  ),),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
