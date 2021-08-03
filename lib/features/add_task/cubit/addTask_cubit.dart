import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/local/database.dart';
import 'package:todo/core/session_management.dart';
import 'package:todo/features/add_task/cubit/addTask_states.dart';
import 'package:todo/features/tasks/models/tasks_model.dart';

DateTime _now = DateTime.now();

class AddTaskCubit extends Cubit<AddTaskStates> {
  AddTaskCubit() : super(AddTaskInitialState());

  static AddTaskCubit get(BuildContext context) =>
      BlocProvider.of<AddTaskCubit>(context);

  DateTime initialDate = DateTime(_now.year, _now.month, _now.day);
  TimeOfDay initialTime = TimeOfDay.now();
  String _date = DateTime(_now.year, _now.month, _now.day).toIso8601String();
  String _time = "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";
  Priority? _priority;
  bool notification = false;

  void changeDateOfTask(DateTime dateTime) {
    _date = dateTime.toIso8601String();
    initialDate = dateTime;
  }

  void changeTimeOfTask(TimeOfDay timeOfDay) {
    _time = "${timeOfDay.hour}:${timeOfDay.minute}";
    initialTime = timeOfDay;
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
    await LocalDataBase.insertToDB(Task(
            title: title,
            priority: _priority!,
            date: _date,
            time: _time,
            notification: notification,
            isDone: false))
        .then((_) {
      SessionManagement.saveLastChangeDate(DateTime.now().toIso8601String());
      emit(AddTaskSuccessState());
    }).catchError((error) {
      emit(AddTaskErrorState(error));
    });
  }
}
