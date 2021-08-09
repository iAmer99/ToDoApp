import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/features/bottomBarScreen/bottomBar_screen.dart';
import 'package:todo/features/tasks/cubit/task_cubit.dart';
import 'package:todo/features/tasks/cubit/task_state.dart';
import 'package:todo/shared/widgets/colored_circles.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/utils/helper_functions.dart';
import 'package:todo/utils/size_config.dart';

class SyncScreen extends StatelessWidget {
  static const String routeName = "/sync_screen";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      TaskCubit()
        ..sync(),
      child: BlocConsumer<TaskCubit, TaskStates>(
        listener: (context, state) {
          final TaskCubit cubit = TaskCubit.get(context);
          if (state is TaskSyncSuccessState) Timer(Duration(seconds: 2), (){
            Navigator.of(
                context, rootNavigator: true).pushNamedAndRemoveUntil(
                BottomBarScreen.routeName, (route) => false);
          });
          if (state is TaskSyncErrorState) showDialog(
              context: context, builder: (ctx) {
            return AlertDialog(
              title: Text("Error occurred"),
              content: Text("${state.errorMsg}"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamedAndRemoveUntil(
                      BottomBarScreen.routeName, (route) => false);
                }, child: Text("Continue without sync")),
                TextButton(onPressed: () {
                  cubit.sync();
                }, child: Text("Try again")),
              ],
            );
          });
          if(state is NoInternetConnection){
            Timer(Duration(seconds: 1), (){
              noInternetToast(context);
              Navigator.of(
                  context, rootNavigator: true).pushNamedAndRemoveUntil(
                  BottomBarScreen.routeName, (route) => false);
            });
          }
        },
        builder: (context, state) {
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
                    padding: EdgeInsets.only(bottom: 10 * heightMultiplier),
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
        },
      ),
    );
  }
}
