import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/session_management.dart';
import 'package:todo/features/auth/register/cubit/register_state.dart';
import 'package:todo/features/auth/register/repository/register_repository.dart';
import 'package:todo/features/auth/social_auth/facebook.dart';
import 'package:todo/features/auth/social_auth/google.dart';
import 'package:todo/features/auth/social_auth/twitter2.dart';
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
            if(SessionManagement.hasCachedImage()){
              repository.uploadCachedImage(File(SessionManagement.getImage()));
            }
            emit(RegisterSuccessState());
          },
        );
      } else{
        emit(NoInternetConnection());
      }
    });
  }

  Future<void> googleRegister() async{
    emit(GoogleRegisterLoadingState());
    checkInternetConnection().then((internet) async{
      if(internet != null && internet){
        try{
          final UserCredential cred = await signInWithGoogle();
          SessionManagement.createLoggedInSession(cred.user!.displayName!);
          if(cred.user!.photoURL != null){
            File image = await repository.getImageFile(cred.user!.photoURL!);
            SessionManagement.cacheImage(image.path);
          }
          emit(GoogleRegisterSuccessState());
        }catch(error){
          debugPrint(error.toString());
          emit(GoogleRegisterErrorState("Something went wrong!"));
        }
      }else{
        emit(NoInternetConnection());
      }
    });
  }

  Future<void> facebookRegister() async{
    emit(FacebookRegisterLoadingState());
  checkInternetConnection().then((internet) async{
    if(internet != null && internet){
      try{
        final UserCredential cred = await signInWithFacebook();
        SessionManagement.createLoggedInSession(cred.user!.displayName!);
        if(cred.user!.photoURL != null){
          if(cred.user!.photoURL!.contains("facebook.com")){
            File image = await repository.getImageFile("${cred.user!.photoURL}?width=800&height=800");
            SessionManagement.cacheImage(image.path);
          }else{
            File image = await repository.getImageFile("${cred.user!.photoURL}");
            SessionManagement.cacheImage(image.path);
          }
        }
        emit(FacebookRegisterSuccessState());
      }catch(error){
        debugPrint(error.toString());
        emit(FacebookRegisterErrorState("Something went wrong!"));
      }
    }else{
      emit(NoInternetConnection());
    }
  });
  }

  Future<void> twitterRegister() async{
    emit(TwitterRegisterLoadingState());
    checkInternetConnection().then((internet) async{
      if(internet != null && internet){
        try{
          final UserCredential cred = await signInWithTwitter();
          SessionManagement.createLoggedInSession(cred.user!.displayName!);
          if(cred.user!.photoURL != null ){
            if(cred.user!.photoURL!.contains("twimg.com")){
              String lastUrlPart = "_normal.jpg";
              String picUrl = cred.user!.photoURL!;
              picUrl = picUrl.substring(0, picUrl.indexOf(lastUrlPart));
              File image = await repository.getImageFile("$picUrl.jpg");
              SessionManagement.cacheImage(image.path);
            }else{
              String picUrl = cred.user!.photoURL!;
              File image = await repository.getImageFile(picUrl);
              SessionManagement.cacheImage(image.path);
            }
          }
          emit(TwitterRegisterSuccessState());
        }catch(error){
          debugPrint(error.toString());
          emit(TwitterRegisterErrorState("Something went wrong!"));
        }
      }else{
        emit(NoInternetConnection());
      }
    });
  }

}
