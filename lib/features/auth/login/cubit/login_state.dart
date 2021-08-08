abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {}

class LoginErrorState extends LoginStates {
  final String errorMsg;

  LoginErrorState(this.errorMsg);
}

class NoInternetConnection extends LoginStates {}

class LoginOfflineState extends LoginStates {}

class LoginToRegisterState extends LoginStates {}

