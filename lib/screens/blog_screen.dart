import 'package:bloggiee/models/blog_model.dart';
import 'package:bloggiee/widgets/blog_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        Center(child: CircularProgressIndicator()));
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Logged Out!')));
                FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: Icon(Icons.logout_rounded)),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'add-blog');
              },
              icon: Icon(Icons.add_circle)),
        ],
      ),
      body: StreamBuilder<List<Blog>>(
        stream: readBlogs(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final blogs = snapshot.data!
                .where((element) => element.email != auth.currentUser!.email);

            if (blogs.isEmpty) {
              return Center(child: Text('Sorry! No blogs to show.'));
            } else {
              return ListView(
                children: blogs.map(buildBlog).toList(),
              );
            }
          } else {
            return Center(child: Text("Error has occoured!"));
          }
        }),
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
