import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ultimate_task/screens/home_screen/models/task.dart';

abstract class Database {
  Future<void> createTask(Task task);
}

class FirestoreDatabase implements Database {
  final String uid;
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  Future<void> createTask(Task task) async {
    final path = '/users/$uid/tasks/task_abc';
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(task.toMap());
  }
}
