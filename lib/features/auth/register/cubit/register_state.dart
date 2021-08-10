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

// Social Register States

abstract class FacebookRegisterStates extends RegisterStates{}

class FacebookRegisterLoadingState extends FacebookRegisterStates {}
class FacebookRegisterSuccessState extends FacebookRegisterStates {}
class FacebookRegisterErrorState extends FacebookRegisterStates {
  final String errorMsg;

  FacebookRegisterErrorState(this.errorMsg);
}

abstract class GoogleRegisterStates extends RegisterStates{}

class GoogleRegisterLoadingState extends GoogleRegisterStates {}
class GoogleRegisterSuccessState extends GoogleRegisterStates {}
class GoogleRegisterErrorState extends GoogleRegisterStates {
  final String errorMsg;

  GoogleRegisterErrorState(this.errorMsg);
}

abstract class TwitterRegisterStates extends RegisterStates {}

class TwitterRegisterLoadingState extends TwitterRegisterStates {}
class TwitterRegisterSuccessState extends TwitterRegisterStates {}
class TwitterRegisterErrorState extends TwitterRegisterStates {
  final String errorMsg;

  TwitterRegisterErrorState(this.errorMsg);
}
