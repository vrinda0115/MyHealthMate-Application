import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uipages/components/drawerdoc.dart';

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
                    style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                  ),
        ),
        drawer: const MyDrawerDoc(),
        body:  SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height:25 ),
                Center(child: Image.asset('lib/icons/doctor.png', height: 100,width: 100,)),
                
              ],
            ),
          ),
        ),

    );
  }
}