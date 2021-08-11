import 'package:sqflite/sqflite.dart';
import 'package:todo/features/tasks/models/tasks_model.dart';

class LocalDataBase {
  static late Database db;

  static Future<void> openDataBase() async {
    db = await openDatabase('database.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, priority TEXT, date TEXT,time TEXT, tzDateTime TEXT, done INTEGER, notification INTEGER)');
    });
  }

  static Future<int> insertToDB(Task task) async {
    return await db.insert("Tasks", task.toMap());
  }

  static Future<List<Task>> getTasks() async {
    List<Map<String, Object?>> listOfMaps = await db.query("Tasks");
    List<Task> tasks = listOfMaps.map((map) {
      return Task.fromMap(map);
    }).toList();
    return tasks;
  }

  static Future<void> deleteFromDB(int id) async {
    await db.delete("Tasks", where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateTask(Task task) async{
    await db.update("Tasks", task.toMap(), where: 'id = ?', whereArgs: [task.id] ).then((value){
    });
  }
}
