import 'package:flutter/material.dart';
import 'package:todo/features/home/widgets/dayTasks.dart';
import 'package:todo/shared/models/tasks_model.dart';
import 'package:todo/utils/size_config.dart';

class DayContentForCalendar extends StatelessWidget {
  final List<Task> tasks;

  const DayContentForCalendar({required this.tasks});
  @override
  Widget build(BuildContext context) {
    return tasks.isNotEmpty?  DayTasks(tasks: tasks) : Padding(
      padding: EdgeInsets.symmetric(
         // vertical: 6 * heightMultiplier,
          horizontal: 7 * widthMultiplier),
      child: Text("No Tasks" , style: TextStyle(
        fontSize: 2 * textMultiplier
      ),),
    );
  }
}
