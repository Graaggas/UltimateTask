import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:ultimate_task/screens/home_screen/models/task.dart';
import 'package:ultimate_task/service/api_path.dart';
import 'package:ultimate_task/service/firestore_service.dart';

abstract class Database {
  Future<void> deleteTask(Task task);
  Future<void> createTask(Task task);
  Stream<List<Task>> tasksStream();
  Future<void> setTask(Task task);
}

class FirestoreDatabase implements Database {
  final String uid;

  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final _service = FireStoreService.instance;

  @override
  Future<void> deleteTask(Task task) =>
      _service.deleteData(path: APIpath.task(uid, task.id));

  @override
  Future<void> createTask(Task task) {
    return _service.setData(
      path: APIpath.task(uid, task.id),
      data: task.toMap(),
    );
  }

  @override
  Stream<List<Task>> tasksStream() => _service.collectionStream(
        path: APIpath.tasks(uid),
        builder: (data) => Task.fromMap(data),
      );
  @override
  Future<void> setTask(Task task) => _service.setData(
        path: APIpath.task(uid, task.id),
        data: task.toMap(),
      );
}
