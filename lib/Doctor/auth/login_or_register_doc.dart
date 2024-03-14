import 'package:flutter/material.dart';
import 'package:uipages/pages/Auth/loginpage.dart';
import 'package:uipages/Doctor/auth/registerpage_doc.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {

  //initially show login page
  bool showLoginPage = true;
  
  //togggle betwen login or register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
  } else {
    return RegisterPage(
      onTap: togglePages,
    );
  }
}
}