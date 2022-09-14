import 'dart:developer';

import 'package:bloggiee/models/blog_model.dart';
import 'package:bloggiee/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final auth = FirebaseAuth.instance;

  Future<MyUser?> readUser() async {
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return MyUser.fromJson(snapshot.data()!);
    } else {
      print('Not found user');
    }
  }

  Widget buildUser(MyUser user) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          CircleAvatar(
            child: Text(user.name[0],
                style: Theme.of(context).textTheme.headline3),
            radius: 50,
          ),
          SizedBox(height: 12),
          Text(
            user.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            user.email,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void logOut() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Logged Out!')));
    FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => logOut(), icon: Icon(Icons.logout_rounded)),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          FutureBuilder<MyUser?>(
            future: readUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data;
                return user == null ? Text('Loading') : buildUser(user);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Spacer(),
          ListTile(
            title: Text('My Blogs'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.pushNamed(context, 'my-blogs');
            },
          ),
          ListTile(
            title: Text('Liked Blogs'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.pushNamed(context, 'liked-blogs');
            },
          ),
          ListTile(
            title: Text('SignOut'),
            trailing: Icon(Icons.arrow_right),
            onTap: () => logOut(),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
