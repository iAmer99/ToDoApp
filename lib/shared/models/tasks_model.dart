class Task{
  final String title;
  final Priority priority;
  final String date;
  final String time;
  final bool notification;
  final bool isDone;

  Task({
    required this.title,
    required this.priority,
    required this.date,
    required this.time,
    required this.notification,
    required this.isDone,
  });
}

enum Priority{
Important , Normal , Low
}