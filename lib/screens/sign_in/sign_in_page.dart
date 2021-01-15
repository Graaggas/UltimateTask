import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_task/misc/constants.dart';
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
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Color(myBackgroundColor),
      // ),
      backgroundColor: Color(myBackgroundColor),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Color(myBackgroundColor),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildHeader(),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Text(
                      "Добро пожаловать!",
                      style: GoogleFonts.merriweatherSans(
                        textStyle: TextStyle(
                            color: Color(myBlackLightColor), fontSize: 32),
                      ),
                    ),
                    Text(
                      "Воспользуйтесь одним из методов аутентификации",
                      style: GoogleFonts.merriweatherSans(
                        textStyle: TextStyle(color: Colors.black, fontSize: 10),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton.icon(
                      elevation: 4,
                      color: Color(myBlueColor),
                      onPressed: () => _signInWithGoogle(context),
                      icon: SvgPicture.asset('assets\icons\search.png'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      label: Text(
                        "Google",
                        style: GoogleFonts.merriweatherSans(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    RaisedButton.icon(
                      elevation: 4,
                      color: Color(myAlmostWhiteColor),
                      onPressed: () => _signInWithEmail(context),
                      icon: SvgPicture.asset('assets\icons\search.png'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      label: Text(
                        "E-mail",
                        style: GoogleFonts.merriweatherSans(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //   child: Text(
              //     "Добро пожаловать!",
              //     style: GoogleFonts.merriweatherSans(
              //       textStyle: TextStyle(
              //           color: Color(myBlackLightColor), fontSize: 24),
              //     ),
              //   ),
              // ),
              // Expanded(
              //   child: Text(
              //     "Воспользуйтесь одним из методов аутентификации",
              //     style: GoogleFonts.merriweatherSans(
              //       textStyle: TextStyle(color: Colors.black, fontSize: 12),
              //     ),
              //   ),
              // ),
              // Expanded(
              //   child: ElevatedButton(
              //     onPressed: () {},
              //     child: Text("Google"),
              //   ),
              // ),
              // Expanded(
              //   child: ElevatedButton(
              //     onPressed: () {},
              //     child: Text("Email"),
              //   ),
              // ),
            ],
          );
    // : Stack(
    //     children: <Widget>[
    //       buildHeaderBlueLightCircle(),
    //       buildHeaderRedBox(),
    //       buildHeaderMintCircle(),
    //       buildHeaderBlueBox(),
    //       buildHeaderUltimate(),
    //       buildHeaderTask(),

    //       // Container(
    //       //   height: MediaQuery.of(context).size.height * 0.7,
    //       //   width: MediaQuery.of(context).size.width,
    //       //   child: BlueContainer(),
    //       // ),
    //       // Column(
    //       //   mainAxisAlignment: MainAxisAlignment.start,
    //       //   //crossAxisAlignment: CrossAxisAlignment.stretch,
    //       //   children: <Widget>[
    //       //     SizedBox(
    //       //       height: MediaQuery.of(context).size.height / 20,
    //       //     ),
    //       //     Row(
    //       //       mainAxisAlignment: MainAxisAlignment.center,
    //       //       children: [
    //       //         Text(
    //       //           "Добро пожаловать",
    //       //           style: TextStyle(
    //       //             fontSize: MediaQuery.of(context).size.height / 25,
    //       //             fontWeight: FontWeight.bold,
    //       //             color: Colors.white,
    //       //           ),
    //       //         ),
    //       //       ],
    //       //     ),
    //       //     SizedBox(
    //       //       height: 15,
    //       //     ),
    //       //     ElevatedButton(
    //       //       onPressed: () => _signInWithGoogle(context),
    //       //       child: Text('Войти с помощью Google'),
    //       //       style: ElevatedButton.styleFrom(
    //       //         primary: Colors.deepOrange[800],
    //       //         onPrimary: Colors.white,
    //       //         shape: RoundedRectangleBorder(
    //       //           borderRadius: BorderRadius.circular(32.0),
    //       //         ),
    //       //       ),
    //       //     ),
    //       //     ElevatedButton(
    //       //       onPressed:
    //       //           isLoading ? null : () => _signInWithEmail(context), //,
    //       //       child: Text('Войти с помощью email'),
    //       //       style: ElevatedButton.styleFrom(
    //       //         primary: Colors.amber,
    //       //         onPrimary: Colors.black,
    //       //         shape: RoundedRectangleBorder(
    //       //           borderRadius: BorderRadius.circular(32.0),
    //       //         ),
    //       //       ),
    //       //     ),
    //       //   ],
    //       // ),
    //     ],
    //   );
  }

  Expanded buildHeader() {
    return Expanded(
      flex: 5,
      child: Stack(
        children: <Widget>[
          buildHeaderBlueLightCircle(),
          buildHeaderRedBox(),
          buildHeaderMintCircle(),
          buildHeaderBlueBox(),
          buildHeaderUltimate(),
          buildHeaderTask(),
        ],
      ),
    );
  }

  Positioned buildHeaderTask() {
    return Positioned(
      child: Text(
        "Task",
        style: GoogleFonts.aclonica(
          textStyle: TextStyle(color: Color(myBackgroundColor), fontSize: 48),
        ),
      ),
      top: 100,
      left: 85,
    );
  }

  Positioned buildHeaderUltimate() {
    return Positioned(
      child: Text(
        "Ultimate",
        style: GoogleFonts.aclonica(
          textStyle: TextStyle(color: Color(myBackgroundColor), fontSize: 48),
        ),
      ),
      top: 50,
      left: 20,
    );
  }

  Positioned buildHeaderRedBox() {
    return Positioned(
      top: -150,
      right: -270,
      child: Transform.rotate(
        angle: pi / 2.1,
        child: Container(
          height: 400,
          width: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: Color(myRedColor),
          ),
        ),
      ),
    );
  }

  Positioned buildHeaderBlueBox() {
    return Positioned(
      top: -300,
      left: -200,
      child: Transform.rotate(
        angle: pi / 7,
        child: Container(
          height: 500,
          width: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(125),
            color: Color(myBlueColor),
          ),
        ),
      ),
    );
  }

  Positioned buildHeaderMintCircle() {
    return Positioned(
      top: -20,
      right: 20,
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          //borderRadius: BorderRadius.circular(125),
          color: Color(myMintColor),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Positioned buildHeaderBlueLightCircle() {
    return Positioned(
      top: -100,
      right: -40,
      child: Container(
        height: 350,
        width: 350,
        decoration: BoxDecoration(
          //borderRadius: BorderRadius.circular(125),
          color: Color(myBlueLightColor),
          shape: BoxShape.circle,
        ),
      ),
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
