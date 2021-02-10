import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:provider/provider.dart';
import 'package:ultimate_task/landing_page.dart';
import 'package:ultimate_task/screens/home_screen/models/task.dart';

import 'package:ultimate_task/screens/home_screen/tasks/color_circle_bloc.dart';
import 'package:ultimate_task/service/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(TaskAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBase>.value(value: Auth()),
        Provider<ColorCircleBloc>.value(value: ColorCircleBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ultimate Task',
        // theme: ThemeData(primarySwatch: Colors.teal),
        home: LandingPage(),
      ),
    );
  }
}



//TODO придумать: при загрузке списка, если у задачи стоит вчерашний и более день, тогда поменять ему дату исполнения на сегодня.
