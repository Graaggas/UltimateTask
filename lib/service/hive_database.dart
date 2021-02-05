import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:ultimate_task/screens/home_screen/models/task.dart';

class HiveDatabase extends ChangeNotifier {
  List<Task> _tasks = [];
  String _boxName = "taskBox";

  void addTaskHive(Task task) async {
    var box = await Hive.openBox<Task>(_boxName);
    await box.add(task);

    _tasks = box.values.toList();
    notifyListeners();

    print("/HIVE_DATABASE/ task added with id:${task.id}");
    // print("/HIVE_DATABASE/ tasks contains:\n");
    // _tasks.forEach((element) {
    //   print("-- ${element.memo}");
    // });
    // box.clear();
    // notifyListeners();
  }

  void getTasksHive() async {
    var box = await Hive.openBox<Task>(_boxName);
    _tasks = box.values.toList();
    notifyListeners();
  }

  Task getOneTaskHive(int index) {
    return _tasks[index];
  }
}
