import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/local/database.dart';
import 'package:todo/core/local_notification.dart';
import 'package:todo/core/session_management.dart';
import 'package:todo/features/edit/cubit/edit_states.dart';
import 'package:todo/features/tasks/models/tasks_model.dart';
import 'package:timezone/timezone.dart';

DateTime _now = DateTime.now();

class EditCubit extends Cubit<EditStates> {
  EditCubit() : super(EditInitialState());

  static EditCubit get(BuildContext context) => BlocProvider.of(context);

  DateTime initialDate = DateTime(_now.year, _now.month, _now.day);
  TimeOfDay initialTime = TimeOfDay.now();
  String _dateString =
      DateTime(_now.year, _now.month, _now.day).toIso8601String();
  String _timeString = "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";
  DateTime _dateTime = _now;
  TimeOfDay _timeOfDay = TimeOfDay.now();
  Priority _priority = Priority.Normal;
  bool notification = false;

  init(TZDateTime tzDateTime, Priority priority, bool notification) {
    initialDate = DateTime(tzDateTime.year, tzDateTime.month, tzDateTime.day);
    initialTime = TimeOfDay(hour: tzDateTime.hour, minute: tzDateTime.minute);
    _dateTime = DateTime(tzDateTime.year, tzDateTime.month, tzDateTime.day);
    _dateString = DateTime(tzDateTime.year, tzDateTime.month, tzDateTime.day)
        .toIso8601String();
    _timeOfDay = TimeOfDay(hour: tzDateTime.hour, minute: tzDateTime.minute);
    _priority = priority;
    this.notification = notification;
    _timeString = "${tzDateTime.hour}:${tzDateTime.minute}";
  }

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
    _priority = priority!;
  }

  void enableNotification(bool value) {
    notification = value;
  }

  void checkNotificationAbility() {
    DateTime _taskDateTime = DateTime(
        _dateTime.year, _dateTime.month, _dateTime.day, _timeOfDay.hour,
        _timeOfDay.minute);
    if (!_taskDateTime.isAfter(DateTime.now())){
      emit(CantCreateNotification());
    }
  }

  void saveChanges(int id, String title, bool done) {
    emit(EditLoadingState());
    DateTime _notificationDate = DateTime(_dateTime.year, _dateTime.month,
        _dateTime.day, _timeOfDay.hour, _timeOfDay.minute);
    TZDateTime _timeZonedDateTime = TZDateTime.from(_notificationDate, local);
    LocalDataBase.updateTask(Task(
            title: title,
            id: id,
            priority: _priority,
            date: _dateString,
            time: _timeString,
            notification: notification,
            isDone: done,
            tzDateTime: _timeZonedDateTime.toIso8601String()))
        .then((_) {
      if (notification && _notificationDate.isAfter(_now)) {
        LocalNotification.scheduleAlarm(id, title, _timeZonedDateTime);
      } else if (!notification) {
        LocalNotification.cancel(id);
      }
      SessionManagement.saveLastChangeDate(DateTime.now().toIso8601String());
      emit(EditSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(EditErrorState("Something went wrong!"));
    });
  }
}
