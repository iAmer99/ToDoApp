abstract class EditStates {}

class EditInitialState extends EditStates {}

class EditLoadingState extends EditStates {}

class EditSuccessState extends EditStates {}

class EditErrorState extends EditStates {
  final String errorMsg;

  EditErrorState(this.errorMsg);
}

class CantCreateNotification extends EditStates {}