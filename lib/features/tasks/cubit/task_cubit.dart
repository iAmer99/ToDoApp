import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/local/database.dart';
import 'package:todo/core/session_management.dart';
import 'package:todo/features/tasks/cubit/task_state.dart';
import 'package:todo/features/tasks/models/tasks_model.dart';
import 'package:todo/features/tasks/repository/task_repository.dart';
import 'package:todo/utils/helper_functions.dart';

class TaskCubit extends Cubit<TaskStates> {
  TaskCubit() : super(TaskInitialState());

  static TaskCubit get(BuildContext context) =>
      BlocProvider.of<TaskCubit>(context);

  final TaskRepository _repository = TaskRepository();

  List<Task>? allTasks;
  List<Task>? yesterdayTasks;
  List<Task>? todayTasks;
  List<Task>? tomorrowTasks;
  List<Task>? dayFilteredTasks;

  DateTime calendarInitialDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  Future<void> getTasks() async {
    emit(TaskLoadingState());
    await LocalDataBase.getTasks().then((value) {
      allTasks = value;
      todayTasks = orderTasks(allTasks!
          .where((element) => isToday(DateTime.parse(element.date)))
          .toList());
      tomorrowTasks = orderTasks(allTasks!
          .where((element) => isTomorrow(DateTime.parse(element.date)))
          .toList());
      yesterdayTasks = orderTasks(allTasks!
          .where((element) => isYesterday(DateTime.parse(element.date)))
          .toList());
      dayFilteredTasks = orderTasks(allTasks!.where((element) {
        return DateTime.parse(element.date) == calendarInitialDate;
      }).toList());
      emit(TaskSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(TaskErrorState(error.toString()));
    });
  }

  void getDayFilteredTasks(DateTime date) {
    emit(CalendarTasksLoadingState());
    try {
      dayFilteredTasks = allTasks != null
          ? orderTasks(allTasks!.where((element) {
              return DateTime.parse(element.date) == date;
            }).toList())
          : [];
      calendarInitialDate = date;
      emit(CalendarTasksSuccessState());
    } catch (error) {
      emit(CalendarTasksErrorState(error.toString()));
    }
  }

  void checkDone(Task task) async {
    await LocalDataBase.checkDone(task).then((value) {
      getTasks();
      emit(TaskDoneChecked());
      SessionManagement.saveLastChangeDate(DateTime.now().toIso8601String());
    }).catchError((error) {
      emit(TaskErrorState(error));
    });
  }

  void deleteTask(int? id) async {
    await LocalDataBase.deleteFromDB(id!).then((value) {
      getTasks();
      SessionManagement.saveLastChangeDate(DateTime.now().toIso8601String());
    }).catchError((error) {
      emit(TaskErrorState(error));
    });
  }

  void sync() async {
    emit(TaskSyncLoadingState());
    checkInternetConnection().then((internet) async {
      if (internet != null && internet) {
        try {
          if (SessionManagement.hasCachedImage() &&
              File(SessionManagement.getImage()).existsSync() &&
              FirebaseAuth.instance.currentUser!.photoURL == null) {
            _repository.uploadPickedImage();
          } else if (SessionManagement.hasCachedImage() &&
              !File(SessionManagement.getImage()).existsSync()) {
            await _repository.getImageFile().then((image) {
              SessionManagement.cacheImage(image.path);
            });
          }
          _repository.sync();
          emit(TaskSyncSuccessState());
        } on FirebaseException catch (error) {
          emit(TaskSyncErrorState(error.message!));
        } catch (e) {
          debugPrint(e.toString());
          emit(TaskSyncErrorState("Something went wrong!"));
        }
      } else {
        if (SessionManagement.hasCachedImage() &&
            !File(SessionManagement.getImage()).existsSync()) {
          SessionManagement.cachedImageDeleted();
        }
        emit(NoInternetConnection());
      }
    });
  }
}
