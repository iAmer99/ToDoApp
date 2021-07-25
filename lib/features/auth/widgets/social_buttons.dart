import 'package:flutter/material.dart';
import 'package:todo/utils/size_config.dart';

class SocialButtons extends StatelessWidget {
  final String type;
  final Function facebook;
  final Function twitter;
  final Function google;

  const SocialButtons({required this.type, required this.facebook, required this.twitter, required this.google});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 10 * widthMultiplier),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.black26,
                height: 0.2 * heightMultiplier,
                width: 30 * widthMultiplier,
              ),
              SizedBox(
                width: 2.5 * widthMultiplier,
              ),
              Text(
                "OR",
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 2.5 * textMultiplier),
              ),
              SizedBox(
                width: 2.5 * widthMultiplier,
              ),
              Container(
                color: Colors.black26,
                height: 0.2 * heightMultiplier,
                width: 30 * widthMultiplier,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 1 * heightMultiplier,
        ),
        Text(
          "$type using social media",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 2 * textMultiplier,
          ),
        ),
        SizedBox(
          height: 2 * heightMultiplier,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding:
            EdgeInsets.only(bottom: 2 * heightMultiplier),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    facebook();
                  },
                  child: Image.asset(
                    'assets/images/fb.png',
                    height: 8 * heightMultiplier,
                    width: 8 * heightMultiplier,
                  ),
                ),
                SizedBox(
                  width: 5 * widthMultiplier,
                ),
                GestureDetector(
                  onTap: (){
                    twitter();
                  },
                  child: Image.asset(
                    'assets/images/twitter.png',
                    height: 8 * heightMultiplier,
                    width: 8 * heightMultiplier,
                  ),
                ),
                SizedBox(
                  width: 5 * widthMultiplier,
                ),
                GestureDetector(
                  onTap: (){
                    google();
                  },
                  child: Image.asset(
                    'assets/images/google.png',
                    height: 8 * heightMultiplier,
                    width: 8 * heightMultiplier,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
