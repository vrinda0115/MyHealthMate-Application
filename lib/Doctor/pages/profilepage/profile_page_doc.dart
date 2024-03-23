import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uipages/components/buttons.dart';
import 'package:uipages/components/text_box.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({Key? key}) : super(key: key);

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sectorController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _trainingYearsController =
      TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch doctor data when the profile page is initialized
    getDoctorInfo().then((doctorData) {
      setState(() {
        _firstNameController.text = doctorData['first name'] ?? '';
        _lastNameController.text = doctorData['last name'] ?? '';
        _ageController.text = doctorData['age']?.toString() ?? '';
        _sectorController.text = doctorData['sector'] ?? '';
        _experienceController.text =
            doctorData['doctor experience']?.toString() ?? '';
        _trainingYearsController.text =
            doctorData['years of training']?.toString() ?? '';
        _licenseController.text = doctorData['license'] ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: Text('Doctor Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
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
              MyTextBox(
                sectionName: 'Sector',
                controller: _sectorController,
                onPressed: () {
                  setState(() {
                    _sectorController.text = '';
                  });
                },
              ),
              MyTextBox(
                sectionName: 'Doctor Experience',
                controller: _experienceController,
                onPressed: () {
                  setState(() {
                    _experienceController.text = '';
                  });
                },
              ),
              MyTextBox(
                sectionName: 'Years of Training',
                controller: _trainingYearsController,
                onPressed: () {
                  setState(() {
                    _trainingYearsController.text = '';
                  });
                },
              ),
              MyTextBox(
                sectionName: 'License',
                controller: _licenseController,
                onPressed: () {
                  setState(() {
                    _licenseController.text = '';
                  });
                },
              ),
              SizedBox(height: 20),
              MyButton(onTap: _updateDoctorProfile, text: "Save")
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> getDoctorInfo() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        CollectionReference<Map<String, dynamic>> doctorsCollection =
            FirebaseFirestore.instance.collection('doctors');

        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await doctorsCollection
                .where(
                  "email",
                  isEqualTo: currentUser.email,
                )
                .get();

        var doctorData = querySnapshot.docs.first.data();
        return doctorData;
      } else {
        throw Exception('No user signed in.');
      }
    } catch (e) {
      print("Error retrieving doctor info: $e");
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

  Future<void> _updateDoctorProfile() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        CollectionReference<Map<String, dynamic>> doctorsCollection =
            FirebaseFirestore.instance.collection('doctors');

        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await doctorsCollection
                .where(
                  "email",
                  isEqualTo: currentUser.email,
                )
                .get();

        var doctorDoc = querySnapshot.docs.first;

        // Update the specified fields in the doctor document
        await doctorDoc.reference.update({
          'first name': _firstNameController.text,
          'last name': _lastNameController.text,
          'age': int.parse(_ageController.text),
          'sector': _sectorController.text,
          'doctor experience': int.parse(_experienceController.text),
          'years of training': int.parse(_trainingYearsController.text),
          'license': _licenseController.text,
        });

        // Show alert to indicate successful update
        showUpdateAlert(context, 'Doctor data updated successfully');
      } else {
        throw Exception('No user signed in.');
      }
    } catch (e) {
      print("Error updating doctor profile: $e");
      showUpdateAlert(context, 'Failed to update doctor data');
    }
  }
}
