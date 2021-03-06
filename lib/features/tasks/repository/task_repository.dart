import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as FireStorage;
import 'package:path/path.dart' as Path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:todo/core/local/database.dart';
import 'package:todo/core/session_management.dart';
import 'package:todo/features/tasks/models/tasks_model.dart';

class TaskRepository {
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Task>> sync() async {
    List<Task> returnedTasks = [];
    DocumentSnapshot? lastUpdateOnServerDoc =
        await _userCollection.doc('${_auth.currentUser!.uid}').get();
    Map? lastUpdateMap =
        lastUpdateOnServerDoc.data() as Map?;
    String? lastUpdate = lastUpdateMap != null ? lastUpdateMap['last_update'] : null;
    if (SessionManagement.getLastChangeDate() != null && lastUpdate != null) {
      bool isLocalAfterServer =
          DateTime.parse(SessionManagement.getLastChangeDate()!)
              .isAfter(DateTime.parse(lastUpdate));
      bool isLocalBeforeServer =
          DateTime.parse(SessionManagement.getLastChangeDate()!)
              .isBefore(DateTime.parse(lastUpdate));
      if (isLocalAfterServer)
        await LocalDataBase.getTasks().then((tasks) {
          syncToServer(tasks);
          returnedTasks = tasks;
        });
      if (isLocalBeforeServer) returnedTasks = await syncToLocal(lastUpdate);
    } else if (SessionManagement.getLastChangeDate() != null &&
        lastUpdate == null) {
      await LocalDataBase.getTasks().then((tasks) {
        syncToServer(tasks);
        returnedTasks = tasks;
      });
    } else if (SessionManagement.getLastChangeDate() == null &&
        lastUpdate != null) {
      returnedTasks = await syncToLocal(lastUpdate);
    }
    return returnedTasks;
  }

  void syncToServer(List<Task> tasks) async {
    await _userCollection
        .doc('${_auth.currentUser!.uid}')
        .collection('Tasks')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    if (tasks.isNotEmpty) {
      tasks.forEach((task) {
        _userCollection
            .doc('${_auth.currentUser!.uid}')
            .collection('Tasks')
            .doc('${task.id}')
            .set(task.toMap());
      });
    }
    await _userCollection
        .doc('${_auth.currentUser!.uid}')
        .set({'last_update': SessionManagement.getLastChangeDate()});
  }

  Future<List<Task>> syncToLocal(String lastServerUpdate) async {
    await LocalDataBase.db.delete('Tasks');
    List<Task> tasks= [];
   tasks = await _userCollection
        .doc('${_auth.currentUser!.uid}')
        .collection('Tasks')
        .get()
        .then((snapshot) async {
      snapshot.docs.forEach((element) async{
        await LocalDataBase.insertToDB(
            Task.fromMap(element.data()));
      });
      return snapshot.docs.map((element){
        return Task.fromMap(element.data());
      }).toList();
    });
    SessionManagement.saveLastChangeDate(lastServerUpdate);
    return tasks;
  }

  Future<File> getImageFile() async{
    if(_auth.currentUser!.photoURL!.contains("twimg.com")){
      String lastUrlPart = "_normal.jpg";
      String picUrl = _auth.currentUser!.photoURL!;
      picUrl = picUrl.substring(0, picUrl.indexOf(lastUrlPart));
      return await DefaultCacheManager().getSingleFile("$picUrl.jpg");
    }else if(_auth.currentUser!.photoURL!.contains("facebook.com")){
      return await DefaultCacheManager().getSingleFile("${_auth.currentUser!.photoURL!}?width=800&height=800");
    }
    else{
      return await DefaultCacheManager().getSingleFile(_auth.currentUser!.photoURL!);
    }
  }
  final FireStorage.FirebaseStorage storage = FireStorage.FirebaseStorage.instance;

  void uploadPickedImage() async{
    String fileName = Path.basename(SessionManagement.getImage());
    await storage.ref('uploads/${_auth.currentUser!.uid}/$fileName').putFile(
        File(SessionManagement.getImage()));
    final String imageUrl = await storage.ref(
        'uploads/${_auth.currentUser!.uid}/$fileName').getDownloadURL();
    _auth.currentUser!.updatePhotoURL(imageUrl);
  }
}
