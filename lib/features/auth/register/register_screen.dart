import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:todo/core/session_management.dart';
import 'package:todo/features/auth/login/login_screen.dart';
import 'package:todo/features/auth/register/cubit/register_cubit.dart';
import 'package:todo/features/auth/register/cubit/register_state.dart';
import 'package:todo/features/sync/sync_screen.dart';
import 'package:todo/shared/widgets/myContainer.dart';
import 'package:todo/features/auth/widgets/auth_textFormField.dart';
import 'package:todo/shared/widgets/myDivider.dart';
import 'package:todo/features/auth/widgets/social_buttons.dart';
import 'package:todo/features/bottomBarScreen/bottomBar_screen.dart';
import 'package:todo/shared/widgets/colored_button.dart';
import 'package:todo/shared/widgets/colored_circles.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/utils/helper_functions.dart';
import 'package:todo/utils/size_config.dart';

import '../validators.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = "/register_screen";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterToLoginState)
            Navigator.of(context, rootNavigator: true)
                .pushReplacementNamed(LoginScreen.routeName);
          if (state is RegisterSuccessState)
            Navigator.of(context, rootNavigator: true)
                .pushReplacementNamed(SyncScreen.routeName);
          if (state is RegisterErrorState)
            showErrorDialog(context, state.errorMsg);
          if(state is NoInternetConnection) noInternetToast(context);
        },
        builder: (context, state) {
          final RegisterCubit cubit = RegisterCubit.get(context);
          return ModalProgressHUD(
            inAsyncCall: state is RegisterLoadingState,
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
                            /*  Text(
                          "Let's help you meet up your tasks",
                          style: TextStyle(
                              color: Colors.black54, fontSize: 3 * textMultiplier),
                        ),
                        SizedBox(
                          height: 5 * heightMultiplier,
                        ), */
                            MyContainer(
                                child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  AuthFormField(
                                    controller: _nameController,
                                    isPassword: false,
                                    myIcon: Icon(Icons.person),
                                    myFocusNode: _nameFocusNode,
                                    label: "Name",
                                    hint: "Enter your full name",
                                    nextFocusNode: _emailFocusNode,
                                    myValidator: (value) =>
                                        isValidName(context, value),
                                    keyboardType: TextInputType.name,
                                  ),
                                  MyDivider(),
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
                                    nextFocusNode: _confirmPasswordFocusNode,
                                    myValidator: (value) =>
                                        isValidPassword(context, value),
                                    keyboardType: TextInputType.text,
                                  ),
                                  MyDivider(),
                                  AuthFormField(
                                      controller: _confirmPasswordController,
                                      isPassword: true,
                                      myIcon: Icon(Icons.password),
                                      myFocusNode: _confirmPasswordFocusNode,
                                      label: "Confirm Password",
                                      hint: "Enter your password again",
                                      myValidator: (value) => confirmPassword(
                                          context,
                                          _passwordController.text,
                                          value),
                                      keyboardType: TextInputType.text,
                                      onComplete: () {
                                        closeKeyboard(context);
                                        if (_formKey.currentState!.validate()) {
                                          cubit.register(
                                              _emailController.text,
                                              _passwordController.text,
                                              _nameController.text);
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
                                  text: "Register",
                                  function: () {
                                    closeKeyboard(context);
                                    if (_formKey.currentState!.validate()) {
                                      cubit.register(
                                          _emailController.text,
                                          _passwordController.text,
                                          _nameController.text);
                                    }
                                  }),
                            ),
                            SizedBox(
                              height: 1 * heightMultiplier,
                            ),
                            TextButton(
                              onPressed: () {
                                cubit.haveAccount();
                              },
                              child: Text(
                                "Already have an account? Login",
                                style: TextStyle(fontSize: 2 * textMultiplier),
                              ),
                            ),
                            SocialButtons(
                                type: "Register",
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
