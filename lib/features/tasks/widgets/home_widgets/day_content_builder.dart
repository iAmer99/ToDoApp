import 'package:flutter/material.dart';
import 'package:todo/features/tasks/models/tasks_model.dart';
import 'package:todo/utils/size_config.dart';

import 'package:todo/features/tasks/widgets/dayTasks.dart';
import 'noTasks.dart';

class DayContentBuilder extends StatelessWidget {
  final List<Task>? tasks;

  const DayContentBuilder({required this.tasks});
  @override
  Widget build(BuildContext context) {
    return tasks!.isNotEmpty?  DayTasks(tasks: tasks) : Padding(
      padding: EdgeInsets.symmetric(
          vertical: 6 * heightMultiplier,
          horizontal: 7 * widthMultiplier),
      child: NoTasks(),
    );
  }
}
