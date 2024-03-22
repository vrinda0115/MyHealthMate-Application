import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uipages/components/buttons.dart';
import 'package:uipages/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _gender;
  final List<String> _genderOptions = ['Male', 'Female'];
  final _formKey = GlobalKey<FormState>(); // Add a form key

  @override
  void initState() {
    super.initState();
    // Fetch user data when the profile page is initialized
    getUserInfo().then((userData) {
      setState(() {
        _firstNameController.text = userData['first name'] ?? '';
        _lastNameController.text = userData['last name'] ?? '';
        _ageController.text = userData['age']?.toString() ?? '';
        _gender = userData['gender'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign the form key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyTextBox(
                sectionName: 'First Name',
                controller: _firstNameController,
                onPressed: () {
                  setState(() {
                    _firstNameController.text = '';
                  });
                },
              ),
              MyTextBox(
                sectionName: 'Last Name',
                controller: _lastNameController,
                onPressed: () {
                  setState(() {
                    _lastNameController.text = '';
                  });
                },
              ),
              MyTextBox(
                sectionName: 'Age',
                controller: _ageController,
                onPressed: () {
                  setState(() {
                    _ageController.text = '';
                  });
                },
              ),
              SizedBox(height: 20),
              /* ElevatedButton(
                
                onPressed: () {
                  _updateUserProfile();
                },
                child: Text('Save'),
              ), */

              MyButton(onTap: _updateUserProfile, text: "Save")

            ],
          ),
        ),
      ),
    );
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
        return userData;
      } else {
        throw Exception('No user signed in.');
      }
    } catch (e) {
      print("Error retrieving user info: $e");
      throw e;
    }
  }

  void showUpdateAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Data Updated'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
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

          var userDoc = querySnapshot.docs.first;

          // Update the specified fields in the user document
          await userDoc.reference.update({
            'first name': _firstNameController.text,
            'last name': _lastNameController.text,
            'age': int.parse(_ageController.text),
          });

          // Show alert to indicate successful update
          showUpdateAlert(context, 'User data updated successfully');
        } else {
          throw Exception('No user signed in.');
        }
      } catch (e) {
        print("Error updating user profile: $e");
        showUpdateAlert(context, 'Failed to update user data');
      }
    }
  }
}
