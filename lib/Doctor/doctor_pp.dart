import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoctorProfilePage extends StatefulWidget {
  final String doctorEmail;

  DoctorProfilePage({required this.doctorEmail});

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  late Stream<DocumentSnapshot> _doctorStream;
  late CollectionReference _appointmentsCollection;
  late String _currentUserEmail;

  @override
  void initState() {
    super.initState();
    _doctorStream = FirebaseFirestore.instance
        .collection('doctors')
        .where('email', isEqualTo: widget.doctorEmail)
        .snapshots()
        .map((snap) => snap.docs.first);

    // Reference to the appointments collection
    _appointmentsCollection = FirebaseFirestore.instance.collection('Appointments');

    // Get the current user's email
    _currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Profile'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: _doctorStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.data() == null) {
                  return Center(
                    child: Text('Doctor data not found.'),
                  );
                }

                final doctorData = snapshot.data!.data() as Map<String, dynamic>;

                return ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Text(
                      'Doctor Name: ${doctorData['first name']} ${doctorData['last name']}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Specialization: ${doctorData['sector'] ?? ''}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Experience: ${doctorData['doctor experience'] ?? ''} years',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Appointments:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    // Display list of appointments
                    StreamBuilder<QuerySnapshot>(
                      stream: _appointmentsCollection.where('email', isEqualTo: widget.doctorEmail).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No appointments'));
                        }

                        final appointments = snapshot.data!.docs;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: appointments.map((appointment) {
                            final data = appointment.data() as Map<String, dynamic>;
                            final appointmentDateTime = DateTime(
                              data['year'],
                              data['month'],
                              data['day'],
                              data['hour'],
                              data['minute'],
                            );
                            final appointmentDescription = data['description'];
                            final email = data['email'];

                            return Card(
                              elevation: 3,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text('Date: ${_formatDateTime(appointmentDateTime)}'),
                                subtitle: Text('Description: $appointmentDescription\nEmail: $email'),
                                onTap: () => _showBookAppointmentDialog(context, appointment.id),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}, ${_formatTime(dateTime)}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final amPm = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $amPm';
  }

  void _showBookAppointmentDialog(BuildContext context, String appointmentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Book Appointment'),
        content: Text('Are you sure you want to book this appointment?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              _bookAppointment(appointmentId);
              Navigator.of(context).pop();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<void> _bookAppointment(String appointmentId) async {
    try {
      final appointmentRef = _appointmentsCollection.doc(appointmentId);
      await appointmentRef.update({
        'booked_by': _currentUserEmail,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment booked successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      print('Error booking appointment: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error booking appointment. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
