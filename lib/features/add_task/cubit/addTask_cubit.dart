import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/local/database.dart';
import 'package:todo/core/local_notification.dart';
import 'package:todo/core/session_management.dart';
import 'package:todo/features/add_task/cubit/addTask_states.dart';
import 'package:todo/features/tasks/models/tasks_model.dart';
import 'package:timezone/timezone.dart' as tz;

DateTime _now = DateTime.now();

class AddTaskCubit extends Cubit<AddTaskStates> {
  AddTaskCubit() : super(AddTaskInitialState());

  static AddTaskCubit get(BuildContext context) =>
      BlocProvider.of<AddTaskCubit>(context);

  DateTime initialDate = DateTime(_now.year, _now.month, _now.day);
  TimeOfDay initialTime = TimeOfDay.now();
  String _dateString =
      DateTime(_now.year, _now.month, _now.day).toIso8601String();
  String _timeString = "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";
  DateTime _dateTime = _now;
  TimeOfDay _timeOfDay = TimeOfDay.now();
  Priority? _priority;
  bool notification = false;

  void changeDateOfTask(DateTime dateTime) {
    _dateString = dateTime.toIso8601String();
    initialDate = dateTime;
    _dateTime = dateTime;
  }

  void changeTimeOfTask(TimeOfDay timeOfDay) {
    _timeString = "${timeOfDay.hour}:${timeOfDay.minute}";
    initialTime = timeOfDay;
    _timeOfDay = timeOfDay;
  }

  void choosePriority(Priority? priority) {
    _priority = priority;
  }

  void enableNotification(bool value) {
    notification = value;
  }

  void addTask({
    required String title,
  }) async {
    emit(AddTaskLoadingState());
    DateTime _notificationDate =
    DateTime(_dateTime.year, _dateTime.month, _dateTime.day, _timeOfDay.hour, _timeOfDay.minute);
    tz.TZDateTime _timeZonedDateTime = tz.TZDateTime.from(_notificationDate, tz.local);
    await LocalDataBase.insertToDB(Task(
            title: title,
            priority: _priority!,
            date: _dateString,
            time: _timeString,
            tzDateTime: _timeZonedDateTime.toIso8601String(),
            notification: notification,
            isDone: false))
        .then((id) {
      if(notification) LocalNotification.scheduleAlarm(id, title, _timeZonedDateTime);
      SessionManagement.saveLastChangeDate(DateTime.now().toIso8601String());
      emit(AddTaskSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(AddTaskErrorState("Something went wrong!"));
    });
  }
}
