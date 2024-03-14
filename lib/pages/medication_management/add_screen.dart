import 'package:flutter/material.dart';
import 'package:uipages/components/buttons.dart';
import 'package:uipages/components/custom_button.dart';
import 'package:uipages/components/custom_textfield.dart';
import 'package:uipages/components/drawer.dart';
import 'package:uipages/components/textfield.dart';
import 'package:uipages/components/time_picker.dart';
import 'package:uipages/pages/medication_management/database.dart';

class AddScreen extends StatelessWidget {
  AddScreen({Key? key}) : super(key: key);

  //textEditing controllers
  final nameController = TextEditingController();

  final quantityController = TextEditingController();

  final daysController = TextEditingController();

  final notificationController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        //Add Reminder
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: Text(
                  "Add Reminder",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
        ),
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),

              
              // const Text(
              //   "Add Reminder",
              //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              // ),

              const SizedBox(
                height: 15,
              ),

              SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('lib/icons/drugs.png')),

              const SizedBox(
                height: 15,
              ),

              //Name Of the Medicine
              const SizedBox(
                child: Text(
                  "Name of the Medicine: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              MyTextField(
                  controller: nameController,
                  hintText: 'Ex: Crocine',
                  obsecureText: false),

              const SizedBox(
                height: 15,
              ),

              //Quantity
              SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('lib/icons/meds.png')),

              const Text(
                "Quantity: ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(
                height: 15,
              ),

              MyTextField(
                  controller: quantityController,
                  hintText: 'Ex: 10',
                  obsecureText: false),

              //Days
              const SizedBox(
                height: 15,
              ),

              SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('lib/icons/schedule.png')),

              const Text(
                "Days: ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(
                height: 15,
              ),

              MyTextField(
                  controller: daysController,
                  hintText: 'Ex: 5',
                  obsecureText: false),

              //Time picker
              const SizedBox(
                height: 15,
              ),

              SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('lib/icons/schedule.png')),

              const SizedBox(
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


                const SizedBox(
                height: 15,
              ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                   child: CustomButton(
                     text: "Done",
                     onTap: () async {
                       bool result = await addReminders(
                         context: context,
                         name: nameController.text,
                         quantity: quantityController.text,
                         days: daysController.text,
                         notification: notificationController.text,
                       );

                       if (result) {
                        if (context.mounted) {
                         Navigator.pop(context);
                       }
                       }
                     },
              ),
            )

            ],
          ),
        ),
      ),
    );
  }
}
