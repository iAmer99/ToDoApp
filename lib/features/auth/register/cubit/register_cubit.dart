import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/features/auth/register/cubit/register_state.dart';

class RegisterCubit extends Cubit <RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());


  static RegisterCubit get(BuildContext context)=> BlocProvider.of(context);

  void continueOffline(){
    emit(RegisterOfflineState());
  }


  void haveAccount(){
    emit(RegisterToLoginState());
  }

}