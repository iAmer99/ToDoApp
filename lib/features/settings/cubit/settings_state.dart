abstract class SettingsStates {}

class SettingsInitialState extends SettingsStates {}

abstract class LogoutStates extends SettingsStates {}

class LogoutLoadingState extends LogoutStates {}

class LogoutSuccessState extends LogoutStates {}

class LogoutErrorState extends LogoutStates {
  final String errorMsg;

  LogoutErrorState(this.errorMsg);
}

abstract class UploadingImageStates extends SettingsStates {}

class UploadingImageLoadingState extends UploadingImageStates{}

class UploadingImageSuccessState extends UploadingImageStates{}

class UploadingImageErrorState extends UploadingImageStates{
  final String errorMsg;

  UploadingImageErrorState(this.errorMsg);
}

class UpdatedOfflineImageState extends SettingsStates{}