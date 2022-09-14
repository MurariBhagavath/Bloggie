import 'package:bloggiee/main.dart';
import 'package:bloggiee/models/blog_model.dart';
import 'package:bloggiee/widgets/my_button.dart';
import 'package:bloggiee/widgets/my_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddBlogScreen extends StatefulWidget {
  const AddBlogScreen({super.key});

  @override
  State<AddBlogScreen> createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final contentController = TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    descController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add blog'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 32),
              MyInput(
                  width: width, controller: titleController, hintText: 'Title'),
              SizedBox(height: 16),
              MyInput(
                  width: width,
                  controller: descController,
                  hintText: 'Description'),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                width: width / 1.2,
                height: height / 2,
                decoration: BoxDecoration(
                  color: Color(0xffebecf0),
                ),
                child: TextField(
                  textInputAction: TextInputAction.done,
                  controller: contentController,
                  maxLines: 25,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color(0xffebecf0),
                    hintText: 'Content',
                    // labelText: 'Content',
                  ),
                ),
              ),
              SizedBox(height: 16),
              MyButton(width: width, onTap: () => addBlog(), title: 'Add blog'),
            ],
          ),
        ),
      ),
    );
  }

  void addBlog() async {
    showDialog(
        context: context,
        builder: ((context) => Center(child: CircularProgressIndicator())));
    var email = auth.currentUser!.email;
    final db = FirebaseFirestore.instance.collection('blogs').doc();
    final blog = Blog(
      id: db.id,
      content: contentController.text,
      description: descController.text,
      email: email!,
      title: titleController.text,
      timestamp: new DateTime.now(),
      edited: false,
      likes: [],
    );
    await db.set(blog.toJson());
    contentController.clear();
    titleController.clear();
    descController.clear();
    navigatorKey.currentState!.pop(context);
    navigatorKey.currentState!.pop(context);
  }
}
