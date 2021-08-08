import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:todo/core/session_management.dart';
import 'package:todo/features/settings/cubit/settings_state.dart';
import 'package:todo/features/settings/repository/settings_repository.dart';
import 'package:image_picker/image_picker.dart';

class SettingsCubit extends Cubit<SettingsStates> {
  SettingsCubit() : super(SettingsInitialState());

  static SettingsCubit get(BuildContext context) =>
      BlocProvider.of<SettingsCubit>(context);
  SettingsRepository repository = SettingsRepository();

  void logout() async {
    emit(LogoutLoadingState());
    final res = await repository.logout();
    res.fold(
      (error) => emit(LogoutErrorState(error!)),
      (r) async{
        SessionManagement.logout();
       // await LocalDataBase.db.delete("Tasks");
        DefaultCacheManager().emptyCache();
        emit(LogoutSuccessState());
      },
    );
  }
  Future<void> pickImage(ImageSource source) async{
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);
    if(image != null){
      SessionManagement.cacheImage(image.path);
      emit(UpdatedOfflineImageState());
      if(FirebaseAuth.instance.currentUser != null){
        emit(UploadingImageLoadingState());
       final res = await repository.uploadImage(File(image.path));
       res.fold((error) => emit(UploadingImageErrorState(error!)),
               (_) => emit(UploadingImageSuccessState()),
       );
      }
    }
  }
}
