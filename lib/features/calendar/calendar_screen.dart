import 'package:flutter/material.dart';
import 'package:todo/features/calendar/widgets/day_content.dart';
import 'package:todo/shared/widgets/colored_circles.dart';
import 'package:todo/utils/dummy_tasks.dart';
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

  Expanded _buildTasks(Orientation orientation) {
    return Expanded(
      child: Align(
        alignment: orientation == Orientation.landscape
            ? Alignment.centerRight
            : Alignment.center,
        child: DayContentForCalendar(tasks: tasks),
      ),
    );
  }

  Expanded _buildCalendar(Orientation orientation) {
    return Expanded(
      child: Container(
        width:
            orientation == Orientation.landscape ? 50 * heightMultiplier : null,
        alignment:
            orientation == Orientation.landscape ? Alignment.topLeft : null,
        child: CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 20),
            lastDate: DateTime(DateTime.now().year + 30),
            onDateChanged: (DateTime date) {}),
      ),
    );
  }
}
