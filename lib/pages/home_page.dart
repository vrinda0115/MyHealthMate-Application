import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:uipages/components/buttons.dart';
import 'package:uipages/agora/index.dart';
import 'package:uipages/read%20data/get_user_name.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void indexPage() {
    IndexPage;
  }

  //document IDs
  List<String> docIDs = [];

  //get docIDs
  Future getDocId() async {
    await FirebaseFirestore.instance
    .collection('users')
    .orderBy('first name', descending: false)
    .get()
    .then(
          (snapshot) => snapshot.docs.forEach((document) {
            print(document.reference);
            docIDs.add(document.reference.id);
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  //Logged in message
                  Text(
                    "Logged in as ${user!.email!}",
                    style: const TextStyle(fontSize: 20),
                  ),
              
                  //const SizedBox(
                    //height: 50,
                  //),
                  //Button way to go to agora index page
                  //MyButton(
                    //text: "Way to agora vc",
                    //onTap: indexPage,
                  //),
                     SizedBox(
                       child: FutureBuilder(
                        future: getDocId(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: docIDs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: GetUserName(documentId: docIDs[index]),
                                    tileColor: Colors.deepPurple[100],
                                  ),
                                );
                              },
                          );
                        },
                                           ),
                     ),
                
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
