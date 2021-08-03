import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/features/tasks/cubit/task_cubit.dart';
import 'package:todo/features/tasks/cubit/task_state.dart';
import 'package:todo/features/tasks/models/tasks_model.dart';
import 'package:todo/shared/widgets/task_widget.dart';
import 'package:todo/utils/size_config.dart';

class DayTasks extends StatelessWidget {
  final List<Task>? tasks;

  const DayTasks({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskStates>(
      builder: (context, state) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: tasks!.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 0 * heightMultiplier,
                        horizontal: 7 * widthMultiplier),
                    child: TaskWidget(
                      id: tasks![index].id,
                      title: tasks![index].title,
                      time: tasks![index].time,
                      priority: tasks![index].priority,
                      isDone: tasks![index].isDone,
                      notification: tasks![index].notification,
                      date: tasks![index].date,
                    ),
                  ),
                  Divider(
                    color: Colors.transparent,
                  )
                ],
              );
            });
      },
    );
  }
}
