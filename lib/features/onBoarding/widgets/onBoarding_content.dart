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
    return OrientationBuilder(
      builder: (context, orientation){
        return orientation == Orientation.portrait ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _svgPicture(),
            SizedBox(
              height: 3.6 * heightMultiplier,
            ),
            _title(),
            SizedBox(
              height: 2 * heightMultiplier,
            ),
            _description(),
          ],
        ) : Row(
          children: [
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: _title()),
                  Flexible(child: _description()),
                ],
              ),
            ),
            Flexible(child: _svgPicture()),
          ],
        );
      },
    );
  }


  Padding _description() {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 3.6 * widthMultiplier),
        child: Text(
          description,
          style: TextStyle(
              color: Colors.grey,
              fontSize: 2.2 * textMultiplier),
          textAlign: TextAlign.center,
        ),
      );
  }

  Text _title() {
    return Text(
        title,
        style: TextStyle(
            color: Colors.black,
            fontSize: 3.4 * textMultiplier,
            fontWeight: FontWeight.bold),
      );
  }

  SvgPicture _svgPicture() {
    return SvgPicture.asset(
      svg,
      height: 65 * imageSizeMultiplier,
      width: 65 * imageSizeMultiplier,
    );
  }

}
