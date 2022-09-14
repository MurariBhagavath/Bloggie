import 'package:bloggiee/main.dart';
import 'package:bloggiee/models/blog_model.dart';
import 'package:bloggiee/screens/add_blog_screen.dart';
import 'package:bloggiee/screens/blog_screen.dart';
import 'package:bloggiee/screens/update-blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class BlogCard extends StatefulWidget {
  const BlogCard({super.key, required this.self, required this.blog});
  final Blog blog;
  final bool self;
  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard>
    with SingleTickerProviderStateMixin {
  bool _isFavorite = false;
  String? likesCount;
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance.collection('blogs');

  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 200), vsync: this, value: 1.0);

  Future<void> checkLiked() async {
    final doc = await db.doc(widget.blog.id).get();
    final blog = doc.data();
    final List<dynamic> likes = blog!['likes'];

    if (likes.contains(auth.currentUser!.uid)) {
      setState(() {
        likesCount = likes.length.toString();
        _isFavorite = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLiked();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color.fromARGB(238, 196, 241, 252),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text(widget.blog.email[0].toUpperCase()),
              radius: 25,
            ),
            trailing: widget.self
                ? PopupMenuButton(onSelected: (value) {
                    if (value == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UpdateBlogScreen(blog: widget.blog)));
                    }
                  }, itemBuilder: (context) {
                    return [
                      PopupMenuItem(child: Text('Edit'), value: 0),
                      PopupMenuItem(
                          child: Text('Delete'),
                          onTap: () {
                            db.doc(widget.blog.id).delete();
                          }),
                    ];
                  })
                : GestureDetector(
                    onTap: () async {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                      _controller
                          .reverse()
                          .then((value) => _controller.forward());
                      final blog = db.doc(widget.blog.id);
                      final doc = await blog.get();
                      List likes = doc.get('likes');

                      if (!_isFavorite) {
                        if (likes.contains(auth.currentUser!.uid)) {
                          blog.update({
                            'likes':
                                FieldValue.arrayRemove([auth.currentUser!.uid])
                          });
                        }
                      } else {
                        blog.update({
                          'likes':
                              FieldValue.arrayUnion([auth.currentUser!.uid])
                        });
                      }
                    },
                    child: ScaleTransition(
                      scale: Tween(begin: 0.7, end: 1.0).animate(
                          CurvedAnimation(
                              parent: _controller, curve: Curves.easeOut)),
                      child: _isFavorite
                          ? const Icon(
                              Icons.favorite,
                              size: 30,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite,
                              size: 30,
                              color: Colors.grey,
                            ),
                    ),
                  ),
            title: Text(widget.blog.email),
            subtitle: Row(children: [
              fromISO(widget.blog.timestamp),
              Text(widget.blog.edited ? " (Edited)" : "",
                  style: Theme.of(context).textTheme.bodySmall),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              widget.blog.title + " • " + widget.blog.description,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(widget.blog.content),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget fromISO(DateTime date) {
    return Text(date.hour.toString() +
        ":" +
        date.minute.toString() +
        " " +
        date.day.toString() +
        "-" +
        date.month.toString() +
        "-" +
        date.year.toString());
  }
}
