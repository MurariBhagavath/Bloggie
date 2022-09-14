import 'dart:developer';

import 'package:bloggiee/main.dart';
import 'package:bloggiee/widgets/my_button.dart';
import 'package:bloggiee/widgets/my_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  String? email;
  String? password;
  String? name;
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  void signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      final docUser = db.collection('users').doc(credential.user!.uid);

      final user = {
        'name': name,
        'email': email,
        'uid': credential.user!.uid,
      };
      await docUser.set(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    Navigator.pushNamed(context, 'login');
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
              'SignUp',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Spacer(),
          MyInput(width: width, controller: nameController, hintText: 'Name'),
          SizedBox(height: 32),
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
              name = nameController.text;
              mailController.clear();
              passwordController.clear();
              nameController.clear();
              signUp();
            },
            title: 'SignUp',
          ),
          Spacer(),
        ],
      ),
    );
  }
}
