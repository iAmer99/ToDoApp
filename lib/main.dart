import 'package:flutter/material.dart';
import 'package:todo/core/bloc_observer.dart';
import 'package:todo/core/session_management.dart';
import 'package:todo/features/splash/splash_screen.dart';
import 'package:todo/transitions/routes.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/utils/helper_functions.dart';
import 'package:todo/utils/size_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/bottomBarScreen/bottomBar_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await SessionManagement.init();
  runApp(MyApp());
}

final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) =>
            OrientationBuilder(builder: (context, orientation) {
              init(constraints, orientation);
              changeStatusBarColor();
              return MaterialApp(
                title: 'TODO',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primaryColor: mainColor,
                  primarySwatch: mainColorSwatch,
                  scaffoldBackgroundColor: secondaryColor,
                ),
                onGenerateRoute: generateRoutes,
                initialRoute: SplashScreen.routeName,
                navigatorObservers: [routeObserver],
              );
            }));
  }
}
