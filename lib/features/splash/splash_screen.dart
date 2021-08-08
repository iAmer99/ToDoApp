import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/core/session_management.dart';
import 'package:todo/features/auth/login/login_screen.dart';
import 'package:todo/features/bottomBarScreen/bottomBar_screen.dart';
import 'package:todo/features/onBoarding/onBoarding_screen.dart';
import 'package:todo/shared/widgets/white_circles.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/utils/size_config.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/splash_screen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    Timer(Duration(seconds: 1), () {
      _controller.forward();
      Timer(Duration(seconds: 2), () {
        if (FirebaseAuth.instance.currentUser != null || SessionManagement.isGuest()) {
          Navigator.of(context, rootNavigator: true)
              .pushReplacementNamed(BottomBarScreen.routeName);
        } else if(SessionManagement.sawOnBoarding()){
          Navigator.of(context, rootNavigator: true)
              .pushReplacementNamed(LoginScreen.routeName);
           }else{
          Navigator.of(context, rootNavigator: true)
              .pushReplacementNamed(OnBoardingScreen.routeName);
        }
      });
    });
  }


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: mainColor,
      body: Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          WhiteCircles(),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                child: SvgPicture.asset(
                  "assets/svg/name.svg",
                  alignment: Alignment.center,
                  width: 36.5 * imageSizeMultiplier,
                  height: 36.5 * imageSizeMultiplier,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
