import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uipages/components/drawer.dart';
//import 'package:uipages/read%20data/get_user_name.dart';
import 'package:uipages/utils/category_card.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:uipages/utils/doctor_card.dart';

class HomePagee extends StatefulWidget {
  const HomePagee({Key? key}) : super(key: key);

  @override
  State<HomePagee> createState() => _HomePageeState();
}

class _HomePageeState extends State<HomePagee> {
  final user = FirebaseAuth.instance.currentUser;

  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(backgroundColor: Colors.deepPurple[100],
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(
          children: [
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              const Text('Hello',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18)),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                user!.email!,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
              ),
            ),
          ],
        ),
      ),
      actions: [
          IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
        ],
      ),
      drawer: MyDrawer(),
      
      body:  SafeArea(
        child: SizedBox(
          child: Column(
              children: [
               
                      //profile picture
                      //Container(
                          //padding: const EdgeInsets.all(12),
                          //decoration: BoxDecoration(
                            //color: const Color(0xffdcc7ff),
                            //borderRadius: BorderRadius.circular(12),
                          //),
                          //child: const Icon(Icons.person)),
                    //],
                  //),
                //),
          
                const SizedBox(
                  height: 25,
                ),
                //card-> how do you feel?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.pink[100],
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        //animation or picture
                        Container(
                            height: 100,
                            width: 100,
                            child: Image.asset('lib/icons/drugs.png')),
          
                        SizedBox(width: 25),
                        //how do yo feel + start button
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'How do you feel?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Fill your medical card right now!',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Colors.deepPurple[300],
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    )),
                                child: Center(
                                  child: Text('Get Started'),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          
                SizedBox(
                  height: 25,
                ),
          
                //search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        hintText: 'How can we help you?',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                //horizontal listview -> categories: dentist, surgeon etc.
                Container(
                  height: 80,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryCard(
                        categoryName: 'Dentist',
                        iconImagePath: 'lib/icons/tooth.png',
                      ),
                      CategoryCard(
                        categoryName: 'Surgeon',
                        iconImagePath: 'lib/icons/doctor.png',
                      ),
                      CategoryCard(
                        categoryName: 'Cardiologist',
                        iconImagePath: 'lib/icons/heart.png',
                      ),
                    ],
                  ),
                ),
          
                SizedBox(
                  height: 25,
                ),
                //doctor list
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Doctor list',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        'See all',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
          
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      DoctorCard(
                        doctorImagePath: 'lib/image/doctor1.jpg',
                        doctorName: 'Dr. Percy Jackson',
                        doctorTitle: 'NeuroLogist, 7 y.e.',
                      ),
                      DoctorCard(
                        doctorImagePath: 'lib/image/doctor2.jpg',
                        doctorName: 'Dr. Anabeth Chase',
                        doctorTitle: 'Pediatrician, 5 y.e.',
                      ),
                      DoctorCard(
                        doctorImagePath: 'lib/image/doctor3.jpg',
                        doctorName: 'Dr. Grover Underwood',
                        doctorTitle: 'Orthopedist, 7 y.e.',
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
        ),
      ),
      );
  }
}
