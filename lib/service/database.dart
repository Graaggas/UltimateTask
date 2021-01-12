import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ultimate_task/screens/home_screen/models/task.dart';
import 'package:ultimate_task/service/api_path.dart';

abstract class Database {
  Future<void> createTask(Task task);
  Stream<List<Task>> tasksStream();
}

class FirestoreDatabase implements Database {
  final String uid;
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  Future<void> createTask(Task task) => _setData(
        path: APIpath.task(uid, 'task002'),
        data: task.toMap(),
      );

  Stream<List<Task>> tasksStream() {
    final path = APIpath.tasks(uid);
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => Task.fromMap(snapshot.data()))
        .toList());
  }

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }
}
