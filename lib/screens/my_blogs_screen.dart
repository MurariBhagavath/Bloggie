import 'package:bloggiee/models/blog_model.dart';
import 'package:bloggiee/widgets/blog_card.dart';
import 'package:bloggiee/widgets/my_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyBlogsScreen extends StatefulWidget {
  const MyBlogsScreen({super.key});

  @override
  State<MyBlogsScreen> createState() => _MyBlogsScreenState();
}

class _MyBlogsScreenState extends State<MyBlogsScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Blogs'),
      ),
      body: StreamBuilder<List<Blog>>(
        stream: readBlogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final blogs = snapshot.data!.where((blog) =>
                blog.email == FirebaseAuth.instance.currentUser!.email);
            if (blogs.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Oops! You dont have any. Add them'),
                  SizedBox(height: 16),
                  MyButton(
                      width: width,
                      onTap: () {
                        Navigator.pushReplacementNamed(context, 'add-blog');
                      },
                      title: 'Add Blog'),
                ],
              );
            } else {
              return ListView(
                children: blogs.map(buildBlog).toList(),
              );
            }
          } else {
            print(snapshot.error);
            return Center(child: Text("Error has occoured!"));
          }
        },
      ),
    );
  }

  Widget buildBlog(Blog blog) {
    return BlogCard(blog: blog, self: true);
  }

  Stream<List<Blog>> readBlogs() => FirebaseFirestore.instance
      .collection('blogs')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Blog.fromJson(doc.data())).toList());
}
