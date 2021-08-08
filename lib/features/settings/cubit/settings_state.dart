abstract class SettingsStates {}

class SettingsInitialState extends SettingsStates {}

abstract class LogoutStates extends SettingsStates {}

class LogoutLoadingState extends LogoutStates {}

class LogoutSuccessState extends LogoutStates {}

class LogoutErrorState extends LogoutStates {
  final String errorMsg;

  LogoutErrorState(this.errorMsg);
}