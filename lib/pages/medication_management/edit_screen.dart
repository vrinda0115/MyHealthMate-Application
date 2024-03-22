import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:uipages/components/custom_button.dart';
import 'package:uipages/components/custom_textfield.dart';
import 'package:uipages/pages/medication_management/messages.dart';

class EditScreen extends StatelessWidget {
  var nameController = TextEditingController();

  var  quantityController = TextEditingController();

  var daysController = TextEditingController();

  var notificationController = TextEditingController();
  QueryDocumentSnapshot<Object?> lem;
  EditScreen({
    Key? key,
    required this.lem,
  }) : super(key: key) {
    nameController = TextEditingController(text: "${lem["name"]}");
    quantityController = TextEditingController(text: "${lem["quantity"]}");
    daysController = TextEditingController(text: "${lem["days"]}");
    notificationController = TextEditingController(text: "${lem["notification"]}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFF8F8F6),
                        ),
                        child: Center(
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30, top: 15),
                  child: Text(
                    "Edit Reminders",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: CustomTextField(
                    backgroundColor: Color(0xFFF8F8F6),
                    title: "Name of the medication:",
                    controller: nameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: CustomTextField(
                            backgroundColor: Color(0xFFF8F8F6),
                            controller: quantityController,
                            title: "Quantity:",
                          ),
                        ),
                      ),
                      Expanded(
                        child: CustomTextField(
                          backgroundColor: Color(0xFFF8F8F6),
                          controller: daysController,
                          title: "For how many days:",
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: CustomTextField(
                    backgroundColor: Color(0xFFF8F8F6),
                    controller: notificationController,
                    title: "Notification:",
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: CustomButton(
                    backgroundColor: Color(0xFFD11B1B),
                    text: "Delete",
                    onTap: () async {
                      try {
                        await lem.reference.delete();
                        Navigator.of(context).pop();
                      } catch (e) {
                        Message.showError(context, "Unable to delete");
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: CustomButton(
                    text: "Save Changes",
                    onTap: () async {
                      try {
                        await lem.reference.update({
                          "name": nameController.text,
                          "notification": notificationController.text,
                          "email": FirebaseAuth.instance.currentUser!.email,
                          "quantity": quantityController.text,
                          "days": daysController.text,
                        });
                        Navigator.of(context).pop();
                      } catch (e) {
                        Message.showError(
                            context, "Changes could not be saved");
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
