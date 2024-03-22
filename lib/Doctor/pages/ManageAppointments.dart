import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uipages/Doctor/pages/add_appointment.dart';
import 'package:uipages/Doctor/pages/edit_appointment.dart';
import 'package:intl/intl.dart';
import 'package:uipages/components/drawerdoc.dart';

class AppointmentManagementPage extends StatelessWidget {
  const AppointmentManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: Text('Appointment Management'),
      ),
      drawer: MyDrawerDoc(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('Appointments')
                      .get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final appointments = snapshot.data!.docs;
                    if (appointments.isEmpty) {
                      return Center(child: Text('No Appointments'));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointmentData =
                            appointments[index].data() as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditAppointmentPage(
                                    appointmentData: appointmentData),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 15),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xFFF8F8F6),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date: ${appointmentData["day"]} / ${appointmentData["month"]} / ${appointmentData["year"]}",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        "Time: ${appointmentData["hour"] ?? 0}:${appointmentData["minute"] ?? 0}",
                                        style: TextStyle(
                                            color: Color(0xFF9B9B9B),
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            // Add Appointments Button
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: MaterialButton(
                onPressed: () => 
                // Navigate to the page for adding appointments
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAppointmentPage(),
                  ),
                ),
                color: Colors.deepPurple[300],
                child: const Text(
                  'Add Appointment',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
