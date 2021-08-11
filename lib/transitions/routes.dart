import 'package:flutter/material.dart';
import 'package:todo/features/add_task/add_task_screen.dart';
import 'package:todo/features/auth/login/login_screen.dart';
import 'package:todo/features/auth/register/register_screen.dart';
import 'package:todo/features/bottomBarScreen/bottomBar_screen.dart';
import 'package:todo/features/calendar/calendar_screen.dart';
import 'package:todo/features/edit/edit_screen.dart';
import 'package:todo/features/home/home_screen.dart';
import 'package:todo/features/onBoarding/onBoarding_screen.dart';
import 'package:todo/features/settings/settings_screen.dart';
import 'package:todo/features/splash/splash_screen.dart';
import 'package:todo/features/sync/sync_screen.dart';
import 'package:todo/features/tasks/models/tasks_model.dart';
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

    case SettingsScreen.routeName:
      return FadeRoute(page: SettingsScreen());

    case SyncScreen.routeName:
      return FadeRoute(page: SyncScreen());

    case AddTaskScreen.routeName:
      return SlideTopRoute(page: AddTaskScreen());
      
    case EditScreen.routeName:
      final data = settings.arguments as Task;
      return SlideLeftRoute(page: EditScreen(task: data,));
  }
}
