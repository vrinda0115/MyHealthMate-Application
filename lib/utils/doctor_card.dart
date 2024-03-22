import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String doctorImagePath;
  final String doctorName;
  final String doctorTitle;

  DoctorCard({
    required this.doctorImagePath,
    required this.doctorName,
    required this.doctorTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Adjust the width as needed
      height: 100, // Set a fixed height to control the vertical size
      margin: EdgeInsets.only(left: 25.0, bottom: 10),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            // Picture of Doctor
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                doctorImagePath,
                height: 100,
                width: 100
              ),
            ),
            SizedBox(height: 10),
            // Doctor name
            Text(
              doctorName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 5),
            // Doctor title
            Text(
              doctorTitle,
              textAlign: TextAlign.center,
            ),
            //SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
