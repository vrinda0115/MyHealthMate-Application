import 'package:flutter/material.dart';
//import 'package:uipages/pages/auth_page.dart';
import 'package:uipages/pages/doctor_user.dart';
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
