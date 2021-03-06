import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/features/tasks/models/tasks_model.dart';

void changeStatusBarColor() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
  );
}

void closeKeyboard(BuildContext context) => FocusScope.of(context).unfocus();

Color getPriorityColor(Priority priority) {
  if (priority == Priority.Important) {
    return Colors.red;
  } else if (priority == Priority.Low) {
    return Colors.yellow;
  } else {
    return Colors.green;
  }
}

String getGreeting(DateTime dateTime) {
  if (dateTime.hour >= 4 && dateTime.hour < 12) {
    return "Good Morning!";
  } else if (dateTime.hour >= 12 && dateTime.hour < 18) {
    return "Good Afternoon!";
  } else {
    return "Good Evening!";
  }
}

void showErrorDialog(BuildContext context, String error) {
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Error occurred"),
          content: Text(error),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("Okay"))
          ],
        );
      });
}

Future<bool?> checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
}

void noInternetToast(BuildContext context) {
  /* Fluttertoast.showToast(
      msg: "No Internet Connection",
      backgroundColor: Colors.black,
      textColor: Colors.white,); */
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("No Internet Connection"),
    duration: Duration(seconds: 1, milliseconds: 500),
  ));
}

List<Task> orderTasks(List<Task> tasks) {
  int getBoolNum(bool value) {
    if (value) {
      return 1;
    } else {
      return 0;
    }
  }
  tasks.sort((a , b)=> a.time.compareTo(b.time));
  tasks.sort((a, b) {
    return getBoolNum(a.isDone).compareTo(getBoolNum(b.isDone));
  });
  List<Task> orderedTasks = tasks;
  return orderedTasks;
}

DateTime _dateTime = DateTime.now();

bool isToday(DateTime date) {
  if (date.day == _dateTime.day && isThisMonth(date) && isThisYear(date)) {
    return true;
  } else {
    return false;
  }
}

bool isTomorrow(DateTime date) {
  // This month
  if (date.day == _dateTime.day + 1 && isThisMonth(date) && isThisYear(date)) {
    return true;
  }
  // different month
  else if (_dateTime.day == 31 && date.day == 1 && isNextMonth(date)) {
    return true;
  } else if (_dateTime.day == 30 && date.day == 1 && isNextMonth(date)) {
    return true;
  }
  // And for February
  else if (_dateTime.day == 28 && date.day == 1 && isNextMonth(date)) {
    return true;
  } else if (_dateTime.day == 29 && date.day == 1 && isNextMonth(date)) {
    return true;
  } else {
    return false;
  }
}

bool isYesterday(DateTime date) {
  // This month
  if (date.day == _dateTime.day - 1 && isThisMonth(date) && isThisYear(date)) {
    return true;
  }
  // different month
  else if (date.day == 31 && _dateTime.day == 1 && isLastMonth(date)) {
    return true;
  } else if (date.day == 30 && _dateTime.day == 1 && isLastMonth(date)) {
    return true;
  }
  // And for February
  else if (date.day == 28 && _dateTime.day == 1 && isLastMonth(date)) {
    return true;
  } else if (date.day == 29 && _dateTime.day == 1 && isLastMonth(date)) {
    return true;
  } else {
    return false;
  }
}

bool isThisYear(DateTime date) {
  if (date.year == _dateTime.year) {
    return true;
  } else {
    return false;
  }
}

bool isNextYear(DateTime date) {
  if (date.year == _dateTime.year + 1) {
    return true;
  } else {
    return false;
  }
}

bool isLastYear(DateTime date) {
  if (date.year == _dateTime.year - 1) {
    return true;
  } else {
    return false;
  }
}

bool isThisMonth(DateTime date) {
  if (date.month == _dateTime.month && isThisYear(date)) {
    return true;
  } else {
    return false;
  }
}

bool isNextMonth(DateTime date) {
  if (date.month == _dateTime.month + 1 && isThisYear(date)) {
    return true;
  } else if (_dateTime.month == 12 && date.month == 1 && isNextYear(date)) {
    return true;
  } else {
    return false;
  }
}

bool isLastMonth(DateTime date) {
  if (date.month == _dateTime.month - 1 && isThisYear(date)) {
    return true;
  } else if (_dateTime.month == 1 && date.month == 12 && isLastYear(date)) {
    return true;
  } else {
    return false;
  }
}

String getPriorityText(Priority priority) {
  switch (priority) {
    case Priority.Important:
      return "Important";
    case Priority.Normal:
      return "Normal";
    case Priority.Low:
      return "Low";
    default:
      return "Normal";
  }
}

Priority getPriority(String value) {
  switch (value) {
    case "Important":
      return Priority.Important;
    case "Normal":
      return Priority.Normal;
    case "Low":
      return Priority.Low;
    default:
      return Priority.Normal;
  }
}
