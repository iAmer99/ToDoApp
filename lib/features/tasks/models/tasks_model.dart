import 'package:todo/utils/helper_functions.dart';

class Task {
  final int? id;
  final String title;
  final Priority priority;
  final String date;
  final String time;
  final bool notification;
  final bool isDone;

  Task({
    this.id,
    required this.title,
    required this.priority,
    required this.date,
    required this.time,
    required this.notification,
    required this.isDone,
  });

  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      if(id != null) "id" : id,
      "title": title,
      "date": date,
      "time": time,
      "priority": getPriorityText(priority),
      "done": isDone ? 1 : 0,
      "notification": notification ? 1 : 0
    };
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        id: map["id"],
        title: map["title"],
        priority: getPriority(map["priority"]),
        date: map["date"],
        time: map["time"],
        notification: map["notification"] == 1 ? true : false,
        isDone: map["done"] == 1 ? true : false);
  }
}

enum Priority { Important, Normal, Low }
