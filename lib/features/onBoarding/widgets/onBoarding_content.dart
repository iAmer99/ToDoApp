import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/utils/size_config.dart';

class OnBoardingContent extends StatelessWidget {

  final String svg;
  final String title;
  final String description;

  const OnBoardingContent({ required this.svg, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          svg,
          height: 65 * imageSizeMultiplier,
          width: 65 * imageSizeMultiplier,
        ),
        SizedBox(
          height: 3.6 * heightMultiplier,
        ),
        Text(
          title,
          style: TextStyle(
              color: Colors.black,
              fontSize: 3.4 * textMultiplier,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 2 * heightMultiplier,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 3.6 * widthMultiplier),
          child: Text(
            description,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 2.2 * textMultiplier),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
