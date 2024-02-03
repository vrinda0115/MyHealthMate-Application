import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uipages/pages/home_page.dart';
import 'package:uipages/pages/loginpage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          
          //user is logged in
          if (snapshot.hasData){
            return HomePage();
          }
          //user is Not logged in
          else{
            return const LoginPage();
          }

        },
      ),
    );
  }
}