import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/features/add_task/add_task_screen.dart';
import 'package:todo/features/calendar/calendar_screen.dart';
import 'package:todo/features/home/home_screen.dart';
import 'package:todo/features/tasks/cubit/task_cubit.dart';
import 'package:todo/features/tasks/cubit/task_state.dart';

class BottomBarScreen extends StatefulWidget {
  static const String routeName = "/bottomBar_screen";

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedPage = 0;

  void onPageChange(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskCubit()..getTasks(),
      child: BlocBuilder<TaskCubit, TaskStates>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                _selectedPage == 0
                    ? HomeScreen()
                    : WillPopScope(
                        onWillPop: () async {
                          onPageChange(0);
                          return false;
                        },
                        child: CalendarScreen(),
                      )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed(AddTaskScreen.routeName);
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Calendar',
                ),
              ],
              currentIndex: _selectedPage,
              onTap: (int index) {
                onPageChange(index);
                if (index == 1) {
                  TaskCubit.get(context).emit(CalendarTasksInitialState());
                }
              },
            ),
          );
        },
      ),
    );
  }
}
