import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uipages/pages/manage_medications.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions firebaseOptions = const FirebaseOptions(
    apiKey: 'AIzaSyDLvw2H3qZsXt0p-2AjLBJwjfuw7f5zCW0',
    appId: '1:602192321200:android:d27bc5b32a073836337975',
    messagingSenderId: '602192321200',
    projectId: 'authfirebase-3a86d',
    storageBucket: 'authfirebase-3a86d.appspot.com',
  );

  await Firebase.initializeApp(options: firebaseOptions);
  runApp(const ManageMedication());
}
