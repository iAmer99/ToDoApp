import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/session_management.dart';
import 'package:todo/features/auth/login/cubit/login_state.dart';
import 'package:todo/features/auth/login/repository/login_repository.dart';
import 'package:todo/features/auth/social_auth/facebook.dart';
import 'package:todo/features/auth/social_auth/google.dart';
import 'package:todo/features/auth/social_auth/twitter.dart';
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
              (cred) async{
            SessionManagement.createLoggedInSession(cred.user!.displayName!);
            if(cred.user!.photoURL != null){
              File image = await repository.getImageFile(cred.user!.photoURL!);
              SessionManagement.cacheImage(image.path);
            }
            emit(LoginSuccessState());
          },
        );
      }else{
        emit(NoInternetConnection());
      }
    });
  }

  Future<void> googleLogin() async{
    emit(GoogleLoginLoadingState());
    checkInternetConnection().then((internet) async{
      if(internet != null && internet){
        try{
          final UserCredential cred = await signInWithGoogle();
          SessionManagement.createLoggedInSession(cred.user!.displayName!);
          if(cred.user!.photoURL != null){
            print(cred.user!.photoURL);
            File image = await repository.getImageFile(cred.user!.photoURL!);
            SessionManagement.cacheImage(image.path);
          }
          emit(GoogleLoginSuccessState());
        }catch(error){
          debugPrint(error.toString());
          emit(GoogleLoginErrorState("Something went wrong!"));
        }
      }else {
        emit(NoInternetConnection());
      }
    });
  }

  Future<void> facebookLogin() async{
    emit(FacebookLoginLoadingState());
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
          emit(FacebookLoginSuccessState());
        }catch(error){
          debugPrint(error.toString());
          emit(FacebookLoginErrorState("Something went wrong!"));
        }
      }else{
        emit(NoInternetConnection());
      }
    });
  }

   Future<void> twitterLogin() async{
    emit(TwitterLoginLoadingState());
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
          emit(TwitterLoginSuccessState());
        }catch(error){
          debugPrint(error.toString());
          emit(TwitterLoginErrorState("Something went wrong!"));
        }
      }else{
        emit(NoInternetConnection());
      }
    });
  }

}