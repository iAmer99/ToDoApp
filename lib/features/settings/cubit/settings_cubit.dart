import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/local/database.dart';
import 'package:todo/core/session_management.dart';
import 'package:todo/features/settings/cubit/settings_state.dart';
import 'package:todo/features/settings/repository/settings_repository.dart';

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
        emit(LogoutSuccessState());
      },
    );
  }
}
