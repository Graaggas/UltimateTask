import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_task/screens/home_screen/home-page.dart';
import 'package:ultimate_task/screens/sign_in/sign_in_page.dart';
import 'package:ultimate_task/service/auth.dart';

class LandingPage extends StatelessWidget {
  static const routeName = '/landingPage';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        //* если подключился к данным
        if (snapshot.connectionState == ConnectionState.active) {
          //* получаем данные о пользователе
          final User user = snapshot.data;

          print('~ uid is ${user?.uid}');

          if (user == null) {
            //Navigator.of(context).pushNamed(SignInPage.routeName, arguments: auth);

            return SignInPage.create(context);
          } else {
            // Navigator.of(context).pushNamed(HomeScreen.routeName);
            // return HomeScreen();
            return HomePage();
          }
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
