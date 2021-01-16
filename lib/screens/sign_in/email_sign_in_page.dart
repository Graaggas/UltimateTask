import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ultimate_task/misc/constants.dart';
import 'package:ultimate_task/screens/sign_in/email_sign_in_form_change_notifier.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          'Sign in',
          style: GoogleFonts.alice(
            textStyle: TextStyle(color: Colors.black, fontSize: 24),
          ),
        ),
        elevation: 0,
        backgroundColor: Color(myBackgroundColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: EmailSignInFormChangeNotifier.create(context),
        ),
      ),
      backgroundColor: Color(myBackgroundColor),
    );
  }
}
