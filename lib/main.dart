import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_task/landing_page.dart';
import 'package:ultimate_task/screens/home_screen/tasks/color_circle_bloc.dart';
import 'package:ultimate_task/service/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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

// TODO ++ Сохранение при редактировании
//TODO при сохранении дата изменения меняется
//TODO снэкбар
//TODO ++ dismissable
//TODO выбор даты окончания
//TODO придумать, где отображать дату окончания
//TODO сортировка списка
//TODO анимация
//TODO "крестик" без сохранения вызывает диалоговое окно
