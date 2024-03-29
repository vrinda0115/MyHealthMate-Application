import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uipages/components/square_tile.dart';
import 'package:uipages/components/textfield.dart';
import 'package:uipages/components/buttons.dart';
import 'package:uipages/provider/google_sign_in.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});


  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();
  final docexperienceController = TextEditingController();
  final licenceController = TextEditingController();
  final sector = TextEditingController();
  final yearsoftraining = TextEditingController();
  
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose(); 
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    docexperienceController.dispose();
    licenceController.dispose();
    sector.dispose();
    yearsoftraining.dispose();
    super.dispose();
  }

  //Authenticate User
  //sign user Up method
  void signUserUp() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    //error
    //try creating user
    try {
      //check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text);
      } else 
      {
        //show error message, passwords dont match
        showErrorMessage("Passswords don't match");
      }
    if (context.mounted) {
      //pop the loading circle
      Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
      //pop the loading circle
      Navigator.pop(context);
      }
      //Show error message 
      showErrorMessage(e.code);
    }

    // add user details
    addUserDetails(
      firstNameController.text.trim(),
      lastNameController.text.trim(),
      emailController.text.trim(),
      int.parse(ageController.text.trim()),
      int.parse(docexperienceController.text.trim()),
      licenceController.text.trim(),
      sector.text.trim(),
      int.parse(yearsoftraining.text.trim()),
    );
  }

  Future addUserDetails(String firstName,String lastName,String email,int age, int dExperience, String licence, String sector, int yearsOfTraining) async {
    await FirebaseFirestore.instance.collection('doctors').add({
      'first name' : firstName,
      'last name' : lastName,
      'email' : email,
      'age' : age,
      'doctor experience' : dExperience,
      'licence' : licence,
      'sector' : sector,
      'years of training' : yearsOfTraining,
    });
  }


  //error message to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return  AlertDialog(
          backgroundColor: Colors.deepPurple,
          title:Center(child: Text(message,
          style: const TextStyle(color: Colors.white),),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
            
                //logo
                const Icon(
                  Icons.lock,
                  size: 50,
                ),
            
                const SizedBox(height: 5),
            
                //Lets create an account for you
                Text(
                  'Lets create an account for you!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
            

                const SizedBox(height: 5),
                
                //First Name textfield
                MyTextField(
                  controller: firstNameController,
                  hintText: 'First Name',
                  obsecureText: false,
                ),

                const SizedBox(height: 5),
                
                //Last Name textfield
                MyTextField(
                  controller: lastNameController,
                  hintText: 'Last Name',
                  obsecureText: false,
                ),
                const SizedBox(height: 5),
                
                //Age textfield
                MyTextField(
                  controller: ageController,
                  hintText: 'Age',
                  obsecureText: false,
                ),

                const SizedBox(height: 5),

                //sector 
                MyTextField(
                controller: sector, 
                hintText: 'Speciality',
                obsecureText: false),

                const SizedBox(height: 5),
                //license 
                MyTextField(controller: licenceController, 
                hintText: 'Licence',
                obsecureText: false),

                const SizedBox(height: 5),
                //years of training 
                MyTextField(controller: yearsoftraining, 
                hintText: 'Years Of Training',
                obsecureText: false),

                const SizedBox(height: 5),
                //years of experience 
                MyTextField(controller: docexperienceController, 
                hintText: 'Years of Experience',
                obsecureText: false),

                const SizedBox(height: 5),
                
                //username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'email',
                  obsecureText: false,
                ),
            
                const SizedBox(height: 5),
            
                //password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'password',
                  obsecureText: true,
                ),
            
                const SizedBox(
                  height: 5,
                ),

                //Confirm password textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm password',
                  obsecureText: true,
                ),
            
                const SizedBox(
                  height: 5,
                ),
            
                //signin button
                MyButton(
                  text: "Sign Up",
                  onTap: signUserUp,
                ),
            
                //const SizedBox(
                  //height: 15,
                //),
            
                //or continue with
                //Padding(
                  //padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  //child: Row(
                    //children: [
                      //Expanded(
                        //child: Divider(
                          //thickness: 0.5,
                          //color: Colors.grey[400],
                        //),
                      //),
                      //Padding(
                        //padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        //child: Text(
                          //'Or continue with',
                          //style: TextStyle(color: Colors.grey[700]),
                        //),
                      //),
                      //Expanded(
                        //child: Divider(
                          //thickness: 0.5,
                          //color: Colors.grey[400],
                        //),
                      //),
                    //],
                  //),
                //),
            
                //const SizedBox(
                  //height: 10,
                //),
            
                //google sign in button
                 //Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //children: [
                    //google button
                    //SquareTile(
                      //imagePath: 'lib/image/google.png',
                      //onTap: () => AuthService().signInWithGoogle(),
                    //),
            
                    //const SizedBox(
                      //width: 10,
                    //)
                  //],
                //),
            
                const SizedBox(
                  height: 10,
                ),
            
                //not a member? register now
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already havean Account?',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
