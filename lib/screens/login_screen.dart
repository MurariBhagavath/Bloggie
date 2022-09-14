import 'dart:developer';

import 'package:bloggiee/main.dart';
import 'package:bloggiee/widgets/my_button.dart';
import 'package:bloggiee/widgets/my_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? email;
  String? password;
  final auth = FirebaseAuth.instance;

  void signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);
      log(credential.user!.uid);
      Navigator.pushNamed(context, 'home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Spacer(),
          MyInput(width: width, controller: mailController, hintText: 'Email'),
          SizedBox(height: 32),
          MyInput(
              width: width,
              controller: passwordController,
              hintText: 'Password',
              hidden: true),
          Spacer(),
          MyButton(
            width: width,
            onTap: () {
              email = mailController.text;
              password = passwordController.text;
              passwordController.clear();
              mailController.clear();
              signIn();
            },
            title: 'Login',
          ),
          SizedBox(height: 6),
          Center(
              child: TextButton(
            onPressed: () {
              if (mailController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter email.")));
              } else {
                auth.sendPasswordResetEmail(email: mailController.text);
              }
            },
            child: Text('Forgot password?'),
          )),
          Spacer(),
        ],
      ),
    );
  }
}
