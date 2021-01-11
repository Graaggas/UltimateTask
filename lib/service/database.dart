import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

abstract class Database {
  Future<void> createTask(Map<String, dynamic> taskData);
}

class FirestoreDatabase implements Database {
  final String uid;
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  Future<void> createTask(Map<String, dynamic> taskData) async {
    final path = '/users/$uid/tasks/task_abc';
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(taskData);
  }
}
