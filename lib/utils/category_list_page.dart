import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uipages/Doctor/doctor_pp.dart';



class CategoryListPage extends StatelessWidget {
  final String categoryName;

  CategoryListPage({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors - $categoryName'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('doctors')
            .where('sector', isEqualTo: categoryName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final doctorDocs = snapshot.data?.docs ?? [];
          if (doctorDocs.isEmpty) {
            return Center(
              child: Text('No doctors found for $categoryName'),
            );
          }
          return ListView.builder(
            itemCount: doctorDocs.length,
            itemBuilder: (context, index) {
              final doctorData = doctorDocs[index].data() as Map<String, dynamic>;
              final doctorEmail = doctorData['email']; // Extracting doctor's email

              return GestureDetector(
                onTap: () {
                  // Navigate to the doctor profile page when tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoctorProfilePage(doctorEmail: doctorEmail))
                  );
                },
                child: ListTile(
                  title: Text('${doctorData['first name']} ${doctorData['last name']}'),
                  subtitle: Text('Sector: ${doctorData['sector'] ?? ''}'),
                  // Add more fields as needed
                ),
              );
            },
          );
        },
      ),
    );
  }
}
