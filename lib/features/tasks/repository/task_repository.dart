import 'dart:io';

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

  Future<void> sync() async {
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
        });
      if (isLocalBeforeServer) syncToLocal(lastUpdate);
    } else if (SessionManagement.getLastChangeDate() != null &&
        lastUpdate == null) {
      await LocalDataBase.getTasks().then((tasks) {
        syncToServer(tasks);
      });
    } else if (SessionManagement.getLastChangeDate() == null &&
        lastUpdate != null) {
      syncToLocal(lastUpdate);
    }
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

  void syncToLocal(String lastServerUpdate) async {
    await LocalDataBase.db.delete('Tasks');
    _userCollection
        .doc('${_auth.currentUser!.uid}')
        .collection('Tasks')
        .get()
        .then((snapshot) async {
      snapshot.docs.forEach((element) async{
        await LocalDataBase.insertToDB(
            Task.fromMap(element.data()));
      });
    });
    SessionManagement.saveLastChangeDate(lastServerUpdate);
  }

  Future<File> getImageFile() async{
    return await DefaultCacheManager().getSingleFile(_auth.currentUser!.photoURL!);
  }
}
