import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePageDoctor extends StatefulWidget {
  const HomePageDoctor({super.key});

  @override
  State<HomePageDoctor> createState() => _HomePageDoctorState();
}

class _HomePageDoctorState extends State<HomePageDoctor> {
  final user = FirebaseAuth.instance.currentUser;

  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.deepPurple[100],
          title: 
          //Logged in message
                  Text(
                    user!.email!,
                    style: const TextStyle(fontSize: 16),
                  ),
        actions: [
          IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
        ],
        ),
        //body: ,

    );
  }
}