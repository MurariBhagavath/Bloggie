import 'dart:ffi';

import 'package:flutter/material.dart';

class MyUser {
  MyUser(
      {required this.uid, required this.name, required this.email, this.liked});

  final String email;
  final String name;
  final String uid;
  final List? liked;

  Map<String, dynamic> toJson() =>
      {'uid': uid, 'name': name, 'email': email, 'liked': liked};

  static MyUser fromJson(Map<String, dynamic> json) => MyUser(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
        liked: json['liked'],
      );
}
