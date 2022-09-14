import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Blog {
  Blog({
    required this.id,
    required this.content,
    required this.description,
    required this.email,
    required this.title,
    required this.timestamp,
    required this.edited,
    required this.likes,
  });

  final String id;
  final String title;
  final String description;
  final String email;
  final DateTime timestamp;
  final String content;
  final bool edited;
  final List<dynamic> likes;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'email': email,
        'timestamp': timestamp,
        'content': content,
        'edited': edited,
        'likes': likes,
      };

  static Blog fromJson(Map<String, dynamic> json) => Blog(
        id: json['id'],
        content: json['content'],
        description: json['description'],
        email: json['email'],
        title: json['title'],
        timestamp: (json['timestamp'] as Timestamp).toDate(),
        edited: json['edited'],
        likes: json['likes'],
      );
}
