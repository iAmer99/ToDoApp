import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:todo/features/tasks/models/tasks_model.dart' as task;

class LocalNotification {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static late final String currentTimeZone;

  static init() async {
    tz.initializeTimeZones();
    currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    var initializationSettingsAndroid =
        AndroidInitializationSettings('todo_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int? id, String? title, String? body, String? payload) async {});
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
    });
  }

  static void scheduleAlarm(int id, String title, tz.TZDateTime tzDateTime) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'amer_todo_notifications',
      'amer_todo_notifications',
      'amer_todo_channel',
      playSound: true,
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound('tictac'),
      largeIcon: DrawableResourceAndroidBitmap('todo'),
    );

    IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        "It's a ToDo Time",
        title,
        tzDateTime,
        NotificationDetails(
            android: androidPlatformChannelSpecifics,
            iOS: iOSPlatformChannelSpecifics),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
    debugPrint("Scheduled $id");
  }

  static syncScheduledNotifications(List<task.Task> tasks) async {
    List<PendingNotificationRequest> requests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    List<task.Task> tasksWithNotification =
        tasks.where((task) => task.notification).toList();
    List<int> tasksWithNotificationIDs = [];
    tasksWithNotification.forEach((task) {
      tasksWithNotificationIDs.add(task.id!);
    });
    List<int> requestsIDs = [];
    requests.forEach((request) {
      requestsIDs.add(request.id);
    });
    List<int> idsToCancel = requestsIDs
        .where((element) => !tasksWithNotificationIDs.contains(element))
        .toList();
    List<int> idsToCreate = tasksWithNotificationIDs
        .where((element) => !requestsIDs.contains(element))
        .toList();
    List<task.Task> tasksToCreate =
    tasksWithNotification.where((task) => idsToCreate.contains(task.id)).toList();
    if (idsToCancel.isNotEmpty) {
      idsToCancel.forEach((id) {
        flutterLocalNotificationsPlugin.cancel(id);
        debugPrint("Sync Canceled $id");
      });
    }
    if (tasksToCreate.isNotEmpty) {
      tasksToCreate.forEach((task){
        if(tz.TZDateTime.parse(tz.local, task.tzDateTime).isAfter(DateTime.now()) ){
          scheduleAlarm(task.id!, task.title, tz.TZDateTime.parse(tz.local, task.tzDateTime));
          debugPrint("Sync Scheduled ${task.id}");
        }
      });
    }
  }

  static Future<void> cancel(int id) async{
    await flutterLocalNotificationsPlugin.cancel(id);
    debugPrint("Canceled $id");
  }
}
