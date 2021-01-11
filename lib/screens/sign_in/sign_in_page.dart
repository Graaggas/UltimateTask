import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_task/misc/show_exception_dialog.dart';
import 'package:ultimate_task/screens/sign_in/email_sign_in_page.dart';
import 'package:ultimate_task/screens/sign_in/sign_in_manager.dart';
import 'package:ultimate_task/service/auth.dart';

class SignInPage extends StatelessWidget {
  final SignInManager manager;
  final bool isLoading;
  static const routeName = '/signInPage';

  const SignInPage({Key key, this.manager, this.isLoading}) : super(key: key);

  //? Метод создания виджета, в дереве выше вызывается не сам виджет, а метод, описанные ниже.
  //? Сам метод create получает через провайдер переменную аутентификации,
  //? возвращает через провайдер SignInPage (с помощью Consumer передаем в контруктор bloc).
  //? Таким образом данный виджет SignInPage встает в дерево виджетов.
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoadingNotifier, __) => Provider<SignInManager>(
          create: (_) =>
              SignInManager(auth: auth, isLoading: isLoadingNotifier),
          //* consumer помогает прокинуть данные в конструктор
          child: Consumer<SignInManager>(
            child: SignInPage(),
            builder: (_, manager, __) => SignInPage(
              manager: manager,
              isLoading: isLoadingNotifier.value,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } catch (e) {
      //print("~~~~~~> " + e.toString());
      showExceptionAlertDialog(
        context,
        title: 'Ошибка аутентификации',
        exception: e,
      );
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ultimate Task"),
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Colors.grey[300],
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            // padding: const EdgeInsets.all(8.0),
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: BlueContainer(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Добро пожаловать",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () => _signInWithGoogle(context),
                    child: Text('Войти с помощью Google'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrange[800],
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        isLoading ? null : () => _signInWithEmail(context), //,
                    child: Text('Войти с помощью email'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}

class BlueContainer extends StatelessWidget {
  const BlueContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[300],
        borderRadius: BorderRadius.only(
          bottomLeft: const Radius.circular(70),
          bottomRight: const Radius.circular(70),
        ),
      ),
    );
  }
}
