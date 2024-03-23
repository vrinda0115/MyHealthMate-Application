import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  
  final String sector;
  final int experience;

  DoctorCard({
    required this.firstName,
    required this.lastName,
    
    required this.sector,
    required this.experience,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Adjust the width as needed
      height: 150, // Set a fixed height to control the vertical size
      margin: EdgeInsets.only(left: 25.0, bottom: 10),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 25),
            // Doctor name
            Text(
              '$firstName $lastName',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 25),
            // Doctor title and sector
            Text(
              '$sector',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // Doctor experience
            Text(
              'Experience: $experience years' ,
              textAlign: TextAlign.center,
            ),
            
          ],
        ),
      ),
    );
  }
}
