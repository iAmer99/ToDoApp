import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/features/auth/login/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(BuildContext context)=> BlocProvider.of(context);

  void continueOffline(){
    emit(LoginOfflineState());
  }


  void needAccount(){
    emit(LoginToRegisterState());
  }


}