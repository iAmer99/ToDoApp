import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:todo/core/session_management.dart';
import 'package:todo/features/auth/login/login_screen.dart';
import 'package:todo/features/auth/register/register_screen.dart';
import 'package:todo/features/settings/cubit/settings_cubit.dart';
import 'package:todo/features/settings/cubit/settings_state.dart';
import 'package:todo/features/sync/sync_screen.dart';
import 'package:todo/shared/widgets/colored_button.dart';
import 'package:todo/shared/widgets/colored_circles.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/utils/helper_functions.dart';
import 'package:todo/utils/size_config.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = "/settings_screen";

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: BlocConsumer<SettingsCubit, SettingsStates>(
        listener: (context, state) {
          if (state is LogoutErrorState)
            showErrorDialog(context, state.errorMsg);
          if (state is LogoutSuccessState)
            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (route) => false);
        },
        builder: (context, state) {
          return Scaffold(
            body: ModalProgressHUD(
              inAsyncCall: state is LogoutLoadingState,
              child: Stack(
                children: [
                  ColoredCircles(),
                  SafeArea(
                    child: BackButton(),
                  ),
                  SessionManagement.isGuest()
                      ? _buildGuestSettings(orientation, context)
                      : _buildUserSettings(orientation, context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserSettings(Orientation orientation, BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsStates>(
        builder: (context, state) {
          final cubit = SettingsCubit.get(context);
      return Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: orientation == Orientation.portrait
                          ? 25 * heightMultiplier
                          : 20 * widthMultiplier),
                  child: _buildCircleAvatar(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3 * heightMultiplier),
                child: Text(
                  SessionManagement.getName(),
                  style: TextStyle(fontSize: 3.6 * textMultiplier),
                ),
              ),
              /*    SizedBox(height: orientation == Orientation.portrait
                  ? 10 * heightMultiplier : 10 * widthMultiplier ,), */
            ],
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  // alignment: Alignment.bottomCenter,
                  // height: double.infinity,
                  width: double.infinity,
                  // margin: EdgeInsets.only(left: 2 * widthMultiplier),
                  padding: EdgeInsets.only(
                      top: 2 * widthMultiplier,
                      bottom: 2 * widthMultiplier,
                      left: 2 * widthMultiplier),
                  decoration: BoxDecoration(color: mainColor),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamedAndRemoveUntil(SyncScreen.routeName,
                                  (Route<dynamic> route) => false);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.sync,
                              color: secondaryColor,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Sync Now",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 3.6 * textMultiplier),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      GestureDetector(
                        onTap: () {
                          cubit.logout();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: secondaryColor,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Logout",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 3.6 * textMultiplier),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          )
        ],
      );
    });
  }

  Column _buildGuestSettings(Orientation orientation, BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(
                top: orientation == Orientation.portrait
                    ? 25 * heightMultiplier
                    : 20 * widthMultiplier),
            child: _buildCircleAvatar(),
          ),
        ),
        SizedBox(
          height: orientation == Orientation.portrait
              ? 10 * heightMultiplier
              : 10 * widthMultiplier,
        ),
        Container(
          child: ColoredButton(
              text: "Register",
              function: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamedAndRemoveUntil(RegisterScreen.routeName,
                        (Route<dynamic> route) => false);
              }),
          height: 8 * heightMultiplier,
          width: 40 * widthMultiplier,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (Route<dynamic> route) => false);
          },
          child: Text(
            "Already have an account? Login",
            style: TextStyle(fontSize: 2 * textMultiplier),
          ),
        ),
      ],
    );
  }

  CircleAvatar _buildCircleAvatar() {
    return CircleAvatar(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.black45),
          ),
          Icon(
            Icons.add_a_photo,
            color: Colors.white,
          )
        ],
      ),
      backgroundImage: AssetImage('assets/images/default_profile_pic.jpg'),
      radius: 15 * imageSizeMultiplier,
    );
  }
}
