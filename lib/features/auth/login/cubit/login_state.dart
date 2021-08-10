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

// Social Login States

abstract class FacebookLoginStates extends LoginStates{}

class FacebookLoginLoadingState extends FacebookLoginStates {}
class FacebookLoginSuccessState extends FacebookLoginStates {}
class FacebookLoginErrorState extends FacebookLoginStates {
  final String errorMsg;

  FacebookLoginErrorState(this.errorMsg);
}

abstract class GoogleLoginStates extends LoginStates{}

class GoogleLoginLoadingState extends GoogleLoginStates {}
class GoogleLoginSuccessState extends GoogleLoginStates {}
class GoogleLoginErrorState extends GoogleLoginStates {
  final String errorMsg;

  GoogleLoginErrorState(this.errorMsg);
}

abstract class TwitterLoginStates extends LoginStates{}

class TwitterLoginLoadingState extends TwitterLoginStates {}
class TwitterLoginSuccessState extends TwitterLoginStates {}
class TwitterLoginErrorState extends TwitterLoginStates {
  final String errorMsg;

  TwitterLoginErrorState(this.errorMsg);
}

