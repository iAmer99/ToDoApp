import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/session_management.dart';
import 'package:todo/features/auth/register/cubit/register_state.dart';
import 'package:todo/features/auth/register/repository/register_repository.dart';
import 'package:todo/utils/helper_functions.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(BuildContext context) => BlocProvider.of(context);

  final RegisterRepository repository = RegisterRepository();

  void continueOffline() {
    emit(RegisterOfflineState());
  }

  void haveAccount() {
    emit(RegisterToLoginState());
  }

  Future<void> register(String email, String password, String name) async {
    emit(RegisterLoadingState());
    checkInternetConnection().then((internet) async{
      if(internet != null && internet ){
        final res = await repository.register(email, password, name);
        res.fold(
              (error) => emit(RegisterErrorState(error!)),
              (_) {
            SessionManagement.createLoggedInSession(name);
            emit(RegisterSuccessState());
          },
        );
      } else{
        emit(NoInternetConnection());
      }
    });
  }
}
