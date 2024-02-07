import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uipages/components/buttons.dart';
import 'package:uipages/agora/index.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser;

  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  void indexPage(){
    //show loading circle
    dynamic context;
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    const IndexPage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))],
      ),
      body:  SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(children:[

              const SizedBox(height: 10),
              //Logged in message
              Text("Logged in as ${user!.email!}",
              style: const TextStyle(fontSize: 20),
              ),
              
              const SizedBox(
                height: 10,
                ),
              //Button way to go to agora index page
              MyButton(
                text: "Way to Agora vc",
                onTap: indexPage,
                ),
                
            ],),
          ),
        ),
      )
    );
  }
}
