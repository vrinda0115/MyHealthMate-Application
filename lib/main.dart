import 'package:flutter/material.dart';
//import 'package:uipages/pages/auth_page.dart';
import 'package:uipages/pages/doctor_user.dart';
import 'package:uipages/pages/firebase_api.dart';
// ignore: unused_import
import 'pages/Auth/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future base( ) async {
  WidgetsFlutterBinding.ensureInitialized();
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseOptions firebaseOptions = const FirebaseOptions(
    apiKey: 'AIzaSyDLvw2H3qZsXt0p-2AjLBJwjfuw7f5zCW0',
    appId: '1:602192321200:android:d27bc5b32a073836337975',
    messagingSenderId: '602192321200',
    projectId: 'authfirebase-3a86d',
    storageBucket: 'authfirebase-3a86d.appspot.com',
  );
  await Firebase.initializeApp(options: firebaseOptions);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DoctorOrUser(),
    );
  }
}
