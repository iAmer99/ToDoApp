import 'package:flutter/material.dart';
import 'package:todo/features/tasks/widgets/dayTasks.dart';
import 'package:todo/features/tasks/models/tasks_model.dart';
import 'package:todo/utils/size_config.dart';

class DayContentForCalendar extends StatelessWidget {
  final List<Task>? tasks;

  const DayContentForCalendar({required this.tasks});
  @override
  Widget build(BuildContext context) {
    return tasks!.isNotEmpty?  DayTasks(tasks: tasks) : Center(
      child: Text("No Tasks" , style: TextStyle(
        fontSize: 2 * textMultiplier
      ),),
    );
  }
}
