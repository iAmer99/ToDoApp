import 'package:flutter/material.dart';
import 'package:todo/features/auth/login/login_screen.dart';
import 'package:todo/features/auth/register/register_screen.dart';
import 'package:todo/features/bottomBarScreen/bottomBar_screen.dart';
import 'package:todo/features/calendar/calendar_screen.dart';
import 'package:todo/features/home/home_screen.dart';
import 'package:todo/features/onBoarding/onBoarding_screen.dart';
import 'package:todo/features/splash/presentation/splash_screen.dart';
import 'package:todo/transitions/routes/fade_route.dart';
import 'package:todo/transitions/routes/slide_route.dart';

Route<dynamic>? generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.routeName:
      return FadeRoute(page: SplashScreen());

    case OnBoardingScreen.routeName:
      return FadeRoute(page: OnBoardingScreen());

    case RegisterScreen.routeName:
      return FadeRoute(page: RegisterScreen());

    case LoginScreen.routeName:
      return FadeRoute(page: LoginScreen());

    case HomeScreen.routeName:
      return FadeRoute(page: HomeScreen());

    case BottomBarScreen.routeName:
      return FadeRoute(page: BottomBarScreen());

    case CalendarScreen.routeName:
      return SlideLeftRoute(page: CalendarScreen());
  }
}
