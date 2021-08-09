import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:todo/core/session_management.dart';
import 'package:todo/features/auth/login/cubit/login_cubit.dart';
import 'package:todo/features/auth/register/register_screen.dart';
import 'package:todo/features/bottomBarScreen/bottomBar_screen.dart';
import 'package:todo/features/sync/sync_screen.dart';
import 'package:todo/shared/widgets/myContainer.dart';
import 'package:todo/features/auth/widgets/auth_textFormField.dart';
import 'package:todo/shared/widgets/myDivider.dart';
import 'package:todo/features/auth/widgets/social_buttons.dart';
import 'package:todo/shared/widgets/colored_button.dart';
import 'package:todo/shared/widgets/colored_circles.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/utils/helper_functions.dart';
import 'package:todo/utils/size_config.dart';

import '../validators.dart';
import 'cubit/login_state.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/login_screen";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginToRegisterState)
            Navigator.of(context, rootNavigator: true)
                .pushReplacementNamed(RegisterScreen.routeName);
          if(state is LoginErrorState) showErrorDialog(context, state.errorMsg);
          if(state is LoginSuccessState) Navigator.of(context, rootNavigator: true)
              .pushReplacementNamed(SyncScreen.routeName);
          if(state is NoInternetConnection) noInternetToast(context);
        },
        builder: (context, state) {
          final LoginCubit cubit = LoginCubit.get(context);
          return ModalProgressHUD(
            inAsyncCall: state is LoginLoadingState,
            child: GestureDetector(
              onTap: () => closeKeyboard(context),
              child: Scaffold(
                body: Stack(
                  alignment: Alignment.center,
                  children: [
                    ColoredCircles(),
                    SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/name.svg',
                              color: mainColor,
                              height: 20 * imageSizeMultiplier,
                              width: 20 * imageSizeMultiplier,
                            ),
                            SizedBox(
                              height: 5 * heightMultiplier,
                            ),
                            Text(
                              "Welcome Back!",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 3 * textMultiplier),
                            ),
                            SizedBox(
                              height: 5 * heightMultiplier,
                            ),
                            MyContainer(
                                child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  AuthFormField(
                                    controller: _emailController,
                                    isPassword: false,
                                    myIcon: Icon(Icons.email),
                                    myFocusNode: _emailFocusNode,
                                    label: "Email",
                                    hint: "Enter your Email",
                                    nextFocusNode: _passwordFocusNode,
                                    myValidator: (value) =>
                                        isValidEmail(context, value),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  MyDivider(),
                                  AuthFormField(
                                      controller: _passwordController,
                                      isPassword: true,
                                      myIcon: Icon(Icons.lock),
                                      myFocusNode: _passwordFocusNode,
                                      label: "Password",
                                      hint: "Enter your password",
                                      myValidator: (value) =>
                                          isValidPassword(context, value),
                                      keyboardType: TextInputType.text,
                                      onComplete: () {
                                        closeKeyboard(context);
                                        if (_formKey.currentState!.validate()) {
                                          cubit.login(_emailController.text, _passwordController.text);
                                        }
                                      })
                                ],
                              ),
                            )),
                            SizedBox(
                              height: 5 * heightMultiplier,
                            ),
                            Container(
                              height: 8 * heightMultiplier,
                              width: 75 * widthMultiplier,
                              child: ColoredButton(
                                  text: "Login",
                                  function: () {
                                    closeKeyboard(context);
                                    if (_formKey.currentState!.validate()) {
                                      cubit.login(_emailController.text, _passwordController.text);
                                    }
                                  }),
                            ),
                            SizedBox(
                              height: 1 * heightMultiplier,
                            ),
                            TextButton(
                              onPressed: () {
                                cubit.needAccount();
                              },
                              child: Text(
                                "Don't have an account? Register",
                                style: TextStyle(fontSize: 2 * textMultiplier),
                              ),
                            ),
                            SocialButtons(
                                type: "Login",
                                facebook: () {},
                                twitter: () {},
                                google: () {}),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: 1 * heightMultiplier,
                                    right: 2 * widthMultiplier,
                                    left: 2 * widthMultiplier),
                                child: TextButton(
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Continue as a guest",
                                        style: TextStyle(
                                            fontSize: 2 * textMultiplier),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 2 * textMultiplier,
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    SessionManagement.createGuestSession();
                                    Navigator.of(context, rootNavigator: true)
                                        .pushReplacementNamed(
                                        BottomBarScreen.routeName);
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
