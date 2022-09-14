import 'package:bloggiee/models/blog_model.dart';
import 'package:bloggiee/widgets/blog_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikedBlogsScreen extends StatefulWidget {
  const LikedBlogsScreen({super.key});

  @override
  State<LikedBlogsScreen> createState() => _LikedBlogsScreenState();
}

class _LikedBlogsScreenState extends State<LikedBlogsScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liked Blogs')),
      body: StreamBuilder<List<Blog>>(
        stream: readBlogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final blogs = snapshot.data!
                .where((blog) => blog.likes.contains(auth.currentUser!.uid));

            if (blogs.isEmpty) {
              return Center(child: Text('No liked blogs!'));
            } else {
              return ListView(
                children: blogs.map(buildBlog).toList(),
              );
            }
          } else {
            return Center(child: Text('Sorr! Some error has occoured.'));
          }
        },
      ),
    );
  }

  Widget buildBlog(Blog blog) {
    return BlogCard(blog: blog, self: false);
  }

  Stream<List<Blog>> readBlogs() => FirebaseFirestore.instance
      .collection('blogs')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Blog.fromJson(doc.data())).toList());
}
