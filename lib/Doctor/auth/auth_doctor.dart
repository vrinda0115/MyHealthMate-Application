import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uipages/Doctor/auth/login_or_register_doc.dart';
import 'package:uipages/Doctor/pages/home_page.dart';
//import 'package:uipages/pages/home_page.dart';
import 'package:uipages/pages/home_page1.dart';

class AuthPageDoc extends StatelessWidget {
  const AuthPageDoc({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          
          //user is logged in
          if (snapshot.hasData){
            return const HomePageDoctor();
          }
          //user is Not logged in
          else{
            return  const LoginOrRegisterPage();
          }

        },
      ),
    );
  }
}