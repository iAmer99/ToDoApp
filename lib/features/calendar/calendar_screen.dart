import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/features/tasks/cubit/task_cubit.dart';
import 'package:todo/features/tasks/cubit/task_state.dart';
import 'package:todo/features/tasks/widgets/calendar_widgets/day_content.dart';
import 'package:todo/shared/widgets/colored_circles.dart';
import 'package:todo/utils/size_config.dart';

class CalendarScreen extends StatelessWidget {
  static const String routeName = "/calendar_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return Stack(
            children: [
              ColoredCircles(),
              orientation == Orientation.portrait
                  ? SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildCalendar(orientation),
                          _buildTasks(orientation),
                        ],
                      ),
                    )
                  : SafeArea(
                      child: Row(
                      children: [
                        _buildCalendar(orientation),
                        _buildTasks(orientation)
                      ],
                    )),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTasks(Orientation orientation) {
    return BlocBuilder<TaskCubit, TaskStates>(
      buildWhen: (prev, current)=> current is CalendarTasksStates,
      builder: (context, state){
        final cubit = TaskCubit.get(context);
       if(state is CalendarTasksLoadingState){
         return CircularProgressIndicator();
       }else if(state is CalendarTasksErrorState){
         return Center(
           child: Text(state.errorMsg, style: TextStyle(
               fontSize: 2 * textMultiplier
           ),),
         );
       }
       else{
         return Expanded(
           child: Align(
             alignment: orientation == Orientation.landscape
                 ? Alignment.centerRight
                 : Alignment.topCenter,
             child: DayContentForCalendar(tasks: cubit.dayFilteredTasks),
           ),
         );
       }
      },
    );
  }

  Widget _buildCalendar(Orientation orientation) {
    return BlocBuilder<TaskCubit, TaskStates>(
      buildWhen: (prev, current)=> current is CalendarTasksStates,
     builder: (context, state){
        final cubit = TaskCubit.get(context);
        return Expanded(
          child: Container(
            width:
            orientation == Orientation.landscape ? 50 * heightMultiplier : null,
            alignment:
            orientation == Orientation.landscape ? Alignment.topLeft : null,
            child: CalendarDatePicker(
                initialDate: cubit.calendarInitialDate,
                firstDate: DateTime(DateTime.now().year - 20),
                lastDate: DateTime(DateTime.now().year + 30),
                onDateChanged: (DateTime date) {
                  cubit.getDayFilteredTasks(date);
                }),
          ),
        );
     },
    );
  }
}
