import 'package:flutter/material.dart';
import 'package:ultimate_task/screens/home_screen/models/task.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskListTile({Key key, this.task, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.memo),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
