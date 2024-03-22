import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uipages/components/buttons.dart';
import 'package:uipages/components/custom_textfield.dart';
import 'package:uipages/components/text_box.dart';
import 'package:uipages/components/textfield.dart';
import 'package:uipages/pages/medication_management/database.dart';
import 'package:uipages/pages/medication_management/add_screen.dart';
import 'package:uipages/pages/medication_management/edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void navigateToAddScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 25),
            child: Center(
              child: MyTextField(
                hintText: "search",
                obsecureText: false,
                controller: null,
              ),
            ),
          ),
          SizedBox(height: 25),
          SizedBox(
            height: 50,
            width: 50,
            child: Image.asset('lib/icons/drugs.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15,left: 30),
            child: Text(
              "Daily Review",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: FutureBuilder(
                    future: getReminders(),
                    builder: (context, AsyncSnapshot<List<QueryDocumentSnapshot>> docs) {
                      if (docs.hasData && docs.data!.isNotEmpty) {
                        return ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            ...docs.data!.map(
                              (lem) => GestureDetector(
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EditScreen(lem: lem),
                                    ),
                                  );
                                  setState(() {});
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  alignment: Alignment.centerLeft,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color(0xFFF8F8F6),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(height: 25,),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 5),
                                              child: Text(
                                                "${lem["name"]}",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(),
                                              child: Text(
                                                "${lem["notification"]}",
                                                style: TextStyle(
                                                  color: Color(0xFF9B9B9B),
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Column(
                        children: [Text("There are no reminders")],
                      );
                    }
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: MyButton(
              onTap: () {
                navigateToAddScreen(context);
              },
              text: 'Add',
            ),
          ),
        ],
      ),
    );
  }
}
