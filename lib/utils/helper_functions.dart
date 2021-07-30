import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/shared/models/tasks_model.dart';

void changeStatusBarColor() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
  );
}

void closeKeyboard(BuildContext context) => FocusScope.of(context).unfocus();

Color getPriorityColor(Priority priority){
  if(priority == Priority.Important){
    return Colors.red;
  }else if(priority == Priority.Low){
    return Colors.yellow;
  }else {
    return Colors.green;
  }
}

String getGreeting(DateTime dateTime){
  if(dateTime.hour >= 4 && dateTime.hour < 12){
    return "Good Morning!";
  }else if(dateTime.hour >= 12 && dateTime.hour < 18){
    return "Good Afternoon!";
  }else{
    return "Good Evening!";
  }
}


DateTime _dateTime = DateTime.now();

bool isToday(DateTime date){
  if(date.day == _dateTime.day && isSameMonth(date) && isSameYear(date) ){
    return true;
  } else {
    return false;
  }
}
bool isTomorrow(DateTime date){
  // same month
  if(date.day == _dateTime.day + 1 && isSameMonth(date) && isSameYear(date)){
    return true;
  }
  // different month
  else if(_dateTime.day == 31 && date.day == 1 && isNextMonth(date)){
    return true;
  }else if(_dateTime.day == 30 && date.day == 1 && isNextMonth(date)){
    return true;
  }
  // And for February
  else if(_dateTime.day == 28 && date.day == 1 && isNextMonth(date)){
    return true;
  }else if(_dateTime.day == 29 && date.day == 1 && isNextMonth(date) ){
    return true;
  }else {
    return false;
  }
}

bool isSameYear(DateTime date){
  if(date.year == _dateTime.year){
    return true;
  }else {
    return false;
  }
}
bool isNextYear(DateTime date){
  if(date.year == _dateTime.year + 1){
    return true;
  }else {
    return false;
  }
}
bool isSameMonth(DateTime date){
  if(date.month == _dateTime.month && isSameYear(date)){
    return true;
  }else {
    return false;
  }
}
bool isNextMonth(DateTime date){
  if(date.month == _dateTime.month + 1 && isSameYear(date)){
    return true;
  }else if (_dateTime.month == 12 && date.month == 1 && isNextYear(date)){
    return true;
  }
  else {
    return false;
  }
}