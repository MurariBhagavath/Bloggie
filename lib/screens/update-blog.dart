import 'dart:ui';

import 'package:bloggiee/main.dart';
import 'package:bloggiee/models/blog_model.dart';
import 'package:bloggiee/widgets/my_button.dart';
import 'package:bloggiee/widgets/my_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateBlogScreen extends StatefulWidget {
  const UpdateBlogScreen({super.key, required this.blog});
  final Blog blog;
  @override
  State<UpdateBlogScreen> createState() => _UpdateBlogScreenState();
}

class _UpdateBlogScreenState extends State<UpdateBlogScreen> {
  var titleController;
  var descController;
  var contentController;

  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController = new TextEditingController(text: widget.blog.title);
    descController = new TextEditingController(text: widget.blog.description);
    contentController = new TextEditingController(text: widget.blog.content);
  }

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
          title: Text('Update blog'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 32),
              MyInput(
                width: width,
                controller: titleController,
                hintText: 'Title',
              ),
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
              MyButton(
                  width: width,
                  onTap: () => updateBlog(),
                  title: 'Update Blog'),
            ],
          ),
        ),
      ),
    );
  }

  void updateBlog() async {
    var email = auth.currentUser!.email;
    if (widget.blog.id == null) {
    } else {
      final db =
          FirebaseFirestore.instance.collection('blogs').doc(widget.blog.id);

      await db.update({
        'title': titleController.text,
        'description': descController.text,
        'content': contentController.text,
        'edited': true,
      });
      contentController.clear();
      titleController.clear();
      descController.clear();
      navigatorKey.currentState!.pop(context);
    }
  }
}
