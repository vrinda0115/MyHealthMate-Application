import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uipages/components/custom_search_field.dart';
import 'package:uipages/components/drawer.dart';
import 'package:uipages/pages/details_page.dart';
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
  late List<String> searchResults = [];
  late List<String> allDoctorNames = [];
  late List<String> allCategories = [];
   bool showSearchResults = false; // Flag to track if search results should be shown

  @override
  void initState() {
    super.initState();
    fetchDoctorData();
    // Reset search results to empty list when initializing the page
    searchResults = [];
  }

  Future<void> fetchDoctorData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> doctorsSnapshot =
          await FirebaseFirestore.instance.collection('doctors').get();
      setState(() {
        allDoctorNames = doctorsSnapshot.docs
            .map<String>((doc) => doc['first name'] + " " + doc['last name'])
            .toList();
        allCategories = doctorsSnapshot.docs
            .map<String>((doc) => doc['sector'])
            .toSet()
            .toList();
        searchResults = List.from(allDoctorNames); // Copy allDoctorNames initially
      });
    } catch (e) {
      print('Error fetching doctor data: $e');
    }
  }

  void navigateToDetailsPage(String details) {
    setState(() {
      showSearchResults = false; // Hide search results when navigating to details page
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(name: details),
      ),
    );
  }

  void performSearch(String query) {
  setState(() {
    if (query.isEmpty) {
      // If query is empty, show all doctors
      searchResults = List.from(allDoctorNames);
    } else {
      // Filter doctors by name
      List<String> matchingDoctors = allDoctorNames.where((name) =>
          name.toLowerCase().contains(query.toLowerCase())).toList();
      
      // Filter categories
      List<String> matchingCategories = allCategories.where((category) =>
          category.toLowerCase().contains(query.toLowerCase())).toList();

      // Combine matching doctors and categories into a single list
      searchResults = [...matchingDoctors, ...matchingCategories];
      showSearchResults = true; // Show search results when user performs a search
    }
  });
}



  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        CollectionReference<Map<String, dynamic>> usersCollection =
            FirebaseFirestore.instance.collection('users');

        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await usersCollection
                .where(
                  "email",
                  isEqualTo: currentUser.email,
                )
                .get();

        var userData = querySnapshot.docs.first.data();
        String firstName = userData['first name'] ?? '';
        String lastName = userData['last name'] ?? '';
        int age = userData['age'] ?? 0;
        String email = currentUser.email ?? '';

        return {
          'firstName': firstName,
          'lastName': lastName,
          'age': age,
          'email': email,
        };
      } else {
        throw Exception('No user signed in.');
      }
    } catch (e) {
      print("Error retrieving user info: $e");
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: FutureBuilder<Map<String, dynamic>>(
          future: getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return Text('Loading...');
            }
            Map<String, dynamic> userData = snapshot.data!;
            String firstName = userData['firstName'] ?? 'User';
            String lastName = userData['lastName'] ?? '';
            return Text(
              'Hello, $firstName $lastName',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
      drawer: MyDrawer(),
      body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
               constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
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
                      child: CustomSearchField(
                        onChanged: performSearch,
                        searchResults: searchResults,
                        onResultTap: navigateToDetailsPage,
                        showResults: showSearchResults,
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
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
        ),
    );
  }
}
