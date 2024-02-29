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
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, bottom: 25),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.deepPurple[100],
        ),
        child: Column(
          children: [
            //Picture of Doctor
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                doctorImagePath,
                height: 100,
              ),
            ),

            SizedBox(
              height: 5,
            ),
            //doctor name
            Text(
              doctorName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            SizedBox(
              height: 5,
            ),
            //doctor title
            Text(doctorTitle),
          ],
        ),
      ),
    );
  }
}
