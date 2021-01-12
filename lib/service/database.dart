import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ultimate_task/screens/home_screen/models/task.dart';
import 'package:ultimate_task/service/api_path.dart';
import 'package:ultimate_task/service/firestore_service.dart';

abstract class Database {
  Future<void> createTask(Task task);
  Stream<List<Task>> tasksStream();
}

class FirestoreDatabase implements Database {
  final String uid;
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final _service = FireStoreService.instance;

  Future<void> createTask(Task task) => _service.setData(
        path: APIpath.task(uid, 'task002'),
        data: task.toMap(),
      );

  Stream<List<Task>> tasksStream() => _service.collectionStream(
        path: APIpath.tasks(uid),
        builder: (data) => Task.fromMap(data),
      );
}
