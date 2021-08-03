import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/features/add_task/cubit/addTask_cubit.dart';
import 'package:todo/features/add_task/cubit/addTask_states.dart';
import 'package:todo/utils/size_config.dart';

class MySwitcher extends StatefulWidget {
  const MySwitcher({Key? key}) : super(key: key);

  @override
  _MySwitcherState createState() => _MySwitcherState();
}

class _MySwitcherState extends State<MySwitcher> {
  bool _switch = false;
  @override
  Widget build(BuildContext context) {
    final cubit = AddTaskCubit.get(context);
    return BlocBuilder<AddTaskCubit, AddTaskStates>(
      bloc: cubit,
      builder: (context, state) {
        return SwitchListTile(
          value: _switch,
          onChanged: (bool newValue) {
            setState(() {
              _switch = newValue;
            });
            cubit.enableNotification(newValue);
          },
          title: Row(
            children: [
              Icon(
                Icons.notification_important_rounded,
                color: Colors.black.withOpacity(0.4),
              ),
              SizedBox(
                width: 2 * widthMultiplier,
              ),
              Text(
                "Enable Notification",
                style: TextStyle(
                    color: Colors.black.withOpacity(0.4)),
              )
            ],
          ),
        );
      },
    );
  }
}
