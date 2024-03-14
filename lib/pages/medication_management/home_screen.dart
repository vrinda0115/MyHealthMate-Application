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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                    child: TextField(
            
                    decoration: InputDecoration(
                      
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      hintText: 'search',
                    ),
                  ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    "hello,",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 30,
                  ),
                  child: Text(
                    "${FirebaseAuth.instance.currentUser!.email}",
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    "Daily Review",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                      future: getReminders(),
                      builder: (context,
                          AsyncSnapshot<List<QueryDocumentSnapshot>> docs) {
                        if (docs.hasData && docs.data!.length > 0) {
                          return ListView(
                            physics: BouncingScrollPhysics(),
                            children: [
                              ...docs.data!.map(
                                (lem) => GestureDetector(
                                  onTap: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditScreen(lem: lem),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    padding:
                                        EdgeInsets.only(left: 15, right: 15),
                                    alignment: Alignment.centerLeft,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color(0xFFF8F8F6),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 15),
                                          child: Image.asset(
                                            "image/pilula.png",
                                            height: 30,
                                          ),
                                        ),
                                        Expanded(
                                            child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: Text(
                                                  "${lem["name"]}",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(),
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
                                        )),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Image.asset(
                                            "image/vector.png",
                                            height: 30,
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
                      }),
                ),
                Spacer(),
                MyButton(onTap: () {
                  navigateToAddScreen(context);}, text: 'Add')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
