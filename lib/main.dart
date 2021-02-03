import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_task/landing_page.dart';
import 'package:ultimate_task/screens/home_screen/tasks/color_circle_bloc.dart';
import 'package:ultimate_task/service/auth.dart';
import 'package:ultimate_task/service/database.dart';

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

//  ++ Сохранение при редактировании
//++ при сохранении дата изменения меняется
//++ снэкбар
// ++ dismissable
//++ выбор даты окончания
//++ придумать, где отображать дату окончания
//++ сортировка списка
//TODO анимация
//TODO "крестик" без сохранения вызывает диалоговое окно
//TODO сделать alertDialog красивым
//TODO поменять значки в edit_task
//TODO удалить из удаленных все задачи скопом

//++ !!!!! НЕ РАБОТАЕТ СОХРАНЕНИЕ ДАТЫ ЗАВЕРШЕНИЯ! НУЖНО ДЕЛАТЬ ОБНОВЛЕНИЕ ТАСКА В БАЗЕ
