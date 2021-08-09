abstract class TaskStates {}

class TaskInitialState extends TaskStates {}

class TaskLoadingState extends TaskStates {}

class TaskSuccessState extends TaskStates {}

class TaskErrorState extends TaskStates {
  final String errorMsg;

  TaskErrorState(this.errorMsg);
}

class TaskDoneChecked extends TaskStates {}

// Sync States

abstract class TaskSyncStates extends TaskStates {}

class TaskSyncLoadingState extends TaskSyncStates {}

class TaskSyncSuccessState extends TaskSyncStates {}

class TaskSyncErrorState extends TaskSyncStates {
  final String errorMsg;

  TaskSyncErrorState(this.errorMsg);
}

class NoInternetConnection extends TaskSyncStates {}

// calendar states

abstract class CalendarTasksStates extends TaskStates {}

class CalendarTasksInitialState extends CalendarTasksStates {}

class CalendarTasksLoadingState extends CalendarTasksStates {}

class CalendarTasksSuccessState extends CalendarTasksStates {}

class CalendarTasksEmptyState extends CalendarTasksStates {}

class CalendarTasksErrorState extends CalendarTasksStates {
  final String errorMsg;

  CalendarTasksErrorState(this.errorMsg);
}