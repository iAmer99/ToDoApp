abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  final String errorMsg;

  RegisterErrorState(this.errorMsg);
}

class NoInternetConnection extends RegisterStates {}

class RegisterOfflineState extends RegisterStates {}

class RegisterToLoginState extends RegisterStates {}
