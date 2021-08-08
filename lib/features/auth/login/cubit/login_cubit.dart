import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/session_management.dart';
import 'package:todo/features/auth/login/cubit/login_state.dart';
import 'package:todo/features/auth/login/repository/login_repository.dart';
import 'package:todo/utils/helper_functions.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(BuildContext context)=> BlocProvider.of(context);

  LoginRepository repository = LoginRepository();

  void continueOffline(){
    emit(LoginOfflineState());
  }


  void needAccount(){
    emit(LoginToRegisterState());
  }

  Future<void> login(String email, String password) async {
    emit(LoginLoadingState());
    checkInternetConnection().then((internet) async{
      if(internet != null && internet ){
        final res = await repository.login(email, password);
        res.fold(
              (error) => emit(LoginErrorState(error!)),
              (cred) {
            SessionManagement.createLoggedInSession(cred.user!.displayName!);
            emit(LoginSuccessState());
          },
        );
      }else{
        emit(NoInternetConnection());
      }
    });
  }


}