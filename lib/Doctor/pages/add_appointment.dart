import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uipages/components/time_picker.dart';

class AddAppointmentPage extends StatefulWidget {
  @override
  _AddAppointmentPageState createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  TextEditingController descriptionController = TextEditingController();
  final notificationController = TextEditingController();
  //current user
  User? currentUser = FirebaseAuth.instance.currentUser;

  //create timeoftheday variable
  TimeOfDay _timeOfDay = const TimeOfDay(hour: 8, minute: 30);

  //callback for handling time picking
  void _handleTimePicked(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        // Update _timeOfDay with the picked time
        _timeOfDay = value;
        // Convert selected time to string
        String pickedTime = value.format(context);

        // Set the selected time to the notificationController
        notificationController.text = pickedTime;

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Picked Time'),
              content: Text('You picked: ${value.format(context)}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: Text('Add Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 15,
            ),

            SizedBox(
                height: 50,
                width: 50,
                child: Image.asset('lib/icons/schedule.png')),
            // Time Picker
            SizedBox(
              height: 15,
            ),
            //Pick Time
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: MaterialButton(
                onPressed: () => _handleTimePicked(context),
                color: Colors.deepPurple[300],
                child: const Text(
                  'Pick Time ',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),

            SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: MaterialButton(
                onPressed: () => _selectDate(context),
                color: Colors.deepPurple[300],
                child: const Text(
                  'Pick Date ',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Optional Description Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                minLines: 3,
                maxLines: 5,
              ),
            ),

            SizedBox(height: 16),

            // Save Button
            ElevatedButton(
              onPressed: () {
                // Check if both time and date are selected
                if (_timeOfDay != null && selectedDate != null) {
                  // Extract the time and date components
                  int hour = _timeOfDay.hour;
                  int minute = _timeOfDay.minute;
                  int year = selectedDate.year;
                  int month = selectedDate.month;
                  int day = selectedDate.day;

                  // Get the description from the descriptionController
                  String description = descriptionController.text;

                  // Save the appointment to Firestore
                  FirebaseFirestore.instance.collection('Appointments').add({
                    'year': year,
                    'month': month,
                    'day': day,
                    'hour': hour,
                    'minute': minute,
                    'description': description,
                    'email': currentUser!.email,
                    // Add more fields as needed
                  }).then((value) {
                    // Show a success message or navigate back
                    print('Appointment saved successfully!');
                    // Navigate back to the previous screen
                    Navigator.pop(context);
                  }).catchError((error) {
                    // Show an error message
                    print('Failed to save appointment: $error');
                  });
                } else {
                  // Show an error message if time or date is not selected
                  print('Please select both time and date.');
                }
              },
              child: Text('Save Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
