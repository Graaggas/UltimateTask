import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_task/misc/show_alert_dialog.dart';
import 'package:ultimate_task/screens/home_screen/models/task.dart';
import 'package:ultimate_task/service/auth.dart';
import 'package:ultimate_task/service/database.dart';

class TasksPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context, String user) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Вы действительно хотите выйти из учетной записи "$user"?',
      cancelActionText: 'Отмена',
      defaultActionText: 'Выход',
    );
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _createTask(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await database.createTask(
      Task(name: "test0ыфыв1", rating: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Ultimate Task'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _confirmSignOut(context, auth.currentUser.email),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createTask(context),
      ),
      body: _buildContexts(context),
    );
  }

  Widget _buildContexts(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Task>>(
      stream: database.tasksStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final tasks = snapshot.data;
          final children = tasks.map((e) => Text(e.name)).toList();
          return ListView(children: children);
        }
        if (snapshot.hasError) {
          return Center(child: Text('StreamBuilder Error'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
