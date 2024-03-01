import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uipages/components/textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<dynamic> passwordReset() async {
    try {
      await FirebaseAuth.instance
      .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
      context: context,
       builder: (context){
        return AlertDialog(
          content: Text('Password reset link sent! Please check your email'),
        );
      });

    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Enter your email and we will send you a password link!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),

          SizedBox(
            height: 10,
          ),
          //username textfield
          MyTextField(
            controller: emailController,
            hintText: 'email',
            obsecureText: false,
          ),

          SizedBox(
            height: 10,
          ),
          MaterialButton(
            onPressed:() async {
              await passwordReset();
            },
            child: Text('Reset Password'),
            color: Colors.deepPurple[200],
          )
        ],
      ),
    );
  }
}
