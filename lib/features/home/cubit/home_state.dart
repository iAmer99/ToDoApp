import 'package:equatable/equatable.dart';
import 'package:todo/shared/models/tasks_model.dart';

abstract class HomeStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitialState extends HomeStates {}

class HomeLoading extends HomeStates {}

class HomeOffline extends HomeStates {}

class HomeSuccessState extends HomeStates {
  final List<Task> tasks;

  HomeSuccessState(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class HomeErrorState extends HomeStates {
  final String errorMsg;

  HomeErrorState(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];
}

class HomeEmptyState extends HomeStates {}


