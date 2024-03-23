import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uipages/Doctor/pages/Appointment_Details_page.dart';
import 'package:uipages/components/drawerdoc.dart';

class HomePageDoctor extends StatefulWidget {
  const HomePageDoctor({Key? key}) : super(key: key);

  @override
  State<HomePageDoctor> createState() => _HomePageDoctorState();
}

class _HomePageDoctorState extends State<HomePageDoctor> {
  late Map<String, dynamic> userData = {};
  late List<Map<String, dynamic>> bookedAppointments = [];

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchBookedAppointments();
  }

  Future<void> fetchUserInfo() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && mounted) {
        final usersCollection =
            FirebaseFirestore.instance.collection('doctors');
        final querySnapshot = await usersCollection
            .where('email', isEqualTo: currentUser.email)
            .get();
        if (querySnapshot.docs.isNotEmpty && mounted) {
          final userDataMap = querySnapshot.docs.first.data();
          setState(() {
            userData = {
              'firstName': userDataMap['first name'] ?? '',
              'lastName': userDataMap['last name'] ?? '',
            };
          });
        }
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> fetchBookedAppointments() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && mounted) {
        final appointmentsCollection =
            FirebaseFirestore.instance.collection('Appointments');
        final querySnapshot = await appointmentsCollection
            .where('email', isEqualTo: currentUser.email)
            .orderBy('year')
            .orderBy('month')
            .orderBy('day')
            .orderBy('hour')
            .orderBy('minute')
            .get();
        if (querySnapshot.docs.isNotEmpty && mounted) {
          final List<Map<String, dynamic>> appointmentsData = querySnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          setState(() {
            bookedAppointments = appointmentsData;
          });
        }
      }
    } catch (e) {
      print('Error fetching booked appointments: $e');
    }
  }

  void _navigateToAppointmentDetailsPage(BuildContext context, String appointmentId, Map<String, dynamic> appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentDetailsPage(appointmentId: appointmentId, appointment: appointment),
      ),
    );
  }

  void _deleteAppointment(BuildContext context, String appointmentId) async {
    try {
      final appointmentsCollection = FirebaseFirestore.instance.collection('Appointments');
      await appointmentsCollection.doc(appointmentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment deleted successfully.'),
          backgroundColor: Colors.green,
        ),
      );
      // You might want to refresh the list of appointments after deletion
      fetchBookedAppointments();
    } catch (error) {
      print('Error deleting appointment: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting appointment. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: Text(
          'Hello, ${userData['firstName'] ?? 'User'} ${userData['lastName'] ?? ''}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const MyDrawerDoc(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Center(
                child: Image.asset(
                  'lib/icons/doctor.png',
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Booked Appointments',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              if (bookedAppointments.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'No appointments booked yet.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: bookedAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = bookedAppointments[index];
                    final appointmentDateTime = DateTime(
                      appointment['year'],
                      appointment['month'],
                      appointment['day'],
                      appointment['hour'],
                      appointment['minute'],
                    );
                    return GestureDetector(
                      onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppointmentDetailsPage(
                                  appointment: appointment, appointmentId: '',)),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text('Date: ${_formatDateTime(appointmentDateTime)}'),
                          subtitle: Text('Patient Email: ${appointment['booked_by']}'),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
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
}
