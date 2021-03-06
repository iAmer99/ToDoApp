import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/session_management.dart';
import 'package:todo/features/auth/register/register_screen.dart';
import 'package:todo/features/onBoarding/cubit/onBoarding_cubit.dart';
import 'package:todo/features/onBoarding/cubit/onBoarding_states.dart';
import 'package:todo/features/onBoarding/widgets/page_indicator.dart';
import 'package:todo/shared/widgets/colored_button.dart';
import 'package:todo/shared/widgets/colored_circles.dart';
import 'package:todo/utils/size_config.dart';

import 'widgets/onBoarding_content.dart';

class OnBoardingScreen extends StatefulWidget {
  static const routeName = "/onBoarding_screen";

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => OnBoardingCubit(),
      child: BlocBuilder<OnBoardingCubit, OnBoardingStates>(
        buildWhen: (prev, current) => current is OnBoardingInitialState,
        builder: (context, state) {
          final OnBoardingCubit cubit = OnBoardingCubit.get(context);
          return OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              return Scaffold(
                body: Stack(
                  alignment: Alignment.center,
                  children: [
                    ColoredCircles(),
                    PageView(
                      children: [
                        OnBoardingContent(
                          svg: 'assets/svg/onBoarding1.svg',
                          title: 'Arrange All Schedule',
                          description:
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eu nibh efficitur, feugiat magna ac, semper orci. Vestibulum viverra augue vel pellentesque volutpat.",
                        ),
                        OnBoardingContent(
                          svg: 'assets/svg/onBoarding2.svg',
                          title: 'Manage Your Tasks',
                          description:
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eu nibh efficitur, feugiat magna ac, semper orci. Vestibulum viverra augue vel pellentesque volutpat.",
                        ),
                        OnBoardingContent(
                          svg: 'assets/svg/onBoarding3.svg',
                          title: 'Reminders Made Simple',
                          description:
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eu nibh efficitur, feugiat magna ac, semper orci. Vestibulum viverra augue vel pellentesque volutpat.",
                        ),
                      ],
                      onPageChanged: (int index) => cubit.onPageChange(index),
                    ),
                    SizedBox(
                      height: 1.5 * heightMultiplier,
                    ),
                    Align(
                      child: Container(
                        child: PageIndicator(),
                        margin: EdgeInsets.only(
                          bottom: orientation ==
                              Orientation.portrait ? 15 * heightMultiplier : 24 * widthMultiplier),
                      ),
                      alignment: Alignment.bottomCenter,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin:
                        EdgeInsets.only(bottom: orientation ==
                            Orientation.portrait ? 5 * heightMultiplier : 5 * widthMultiplier),
                        child: ColoredButton(
                            text: "Get Started",
                            function: () {
                              SessionManagement.onSeenOnBoarding();
                              Navigator.of(context, rootNavigator: true)
                                  .pushReplacementNamed(
                                  RegisterScreen.routeName);
                            }),
                        height: orientation ==
                            Orientation.portrait ? 8 * heightMultiplier : 17 * widthMultiplier ,
                        width: orientation == Orientation.portrait ? 75 *
                            widthMultiplier : 65 * widthMultiplier,
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
