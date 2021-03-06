import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/features/edit/edit_screen.dart';
import 'package:todo/features/tasks/cubit/task_cubit.dart';
import 'package:todo/features/tasks/cubit/task_state.dart';
import 'package:todo/features/tasks/models/tasks_model.dart';
import 'package:todo/features/tasks/widgets/custom_slidable_action.dart';
import 'package:todo/shared/styles/styles.dart';
import 'package:todo/utils/helper_functions.dart';
import 'package:todo/utils/size_config.dart';

class TaskWidget extends StatelessWidget {
  final Task task;

  const TaskWidget({required this.task});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskStates>(
      builder: (context, state) {
        return Slidable(
          key: ValueKey("${task.id}"),
          actionPane: SlidableDrawerActionPane(),
          secondaryActions: [
            MySlideAction(
              title: "Delete",
              color: Colors.red,
              icon: Icons.delete_forever,
              isFirst: true,
              onPress: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text("Are you sure?"),
                          content: Text("Are you sure to delete this task?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  context.read<TaskCubit>().deleteTask(task.id);
                                },
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                )),
                          ],
                        ));
              },
            ),
            MySlideAction(
              title: "Edit",
              color: Colors.green,
              icon: Icons.edit,
              isFirst: false,
              onPress: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed(EditScreen.routeName, arguments: task);
              },
            )
          ],
          child: GestureDetector(
            onTap: () {
              context.read<TaskCubit>().checkDone(Task(
                  id: task.id,
                  time: task.time,
                  title: task.title,
                  date: task.date,
                  tzDateTime: task.tzDateTime,
                  notification: task.notification,
                  isDone: !task.isDone,
                  priority: task.priority));
            },
            child: Container(
              // margin: EdgeInsets.symmetric(vertical: 5 * heightMultiplier, horizontal: 7 * widthMultiplier),
              height: 13 * heightMultiplier,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.transparent),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.black12)),
                color: Colors.white,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 5 * widthMultiplier,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15)),
                        color: task.isDone
                            ? Colors.grey
                            : getPriorityColor(task.priority),
                      ),
                    ),
                    Checkbox(
                      value: task.isDone,
                      onChanged: (bool? value) {
                        context.read<TaskCubit>().checkDone(Task(
                            id: task.id,
                            time: task.time,
                            title: task.title,
                            date: task.date,
                            tzDateTime: task.tzDateTime,
                            notification: task.notification,
                            isDone: value ?? task.isDone,
                            priority: task.priority));
                      },
                      shape: CircleBorder(),
                    ),
                    Container(
                      child: Text(
                        task.title,
                        style: task.isDone ? doneTaskStyle() : null,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      width: 45 * widthMultiplier,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5 * widthMultiplier),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          task.time,
                          style: task.isDone ? doneTaskStyle() : null,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
