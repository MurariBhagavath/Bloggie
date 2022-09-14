import 'package:bloggiee/screens/add_blog_screen.dart';
import 'package:bloggiee/screens/helper_screen.dart';
import 'package:bloggiee/screens/home_screen.dart';
import 'package:bloggiee/screens/landing_screen.dart';
import 'package:bloggiee/screens/liked_blogs.dart';
import 'package:bloggiee/screens/login_screen.dart';
import 'package:bloggiee/screens/my_blogs_screen.dart';
import 'package:bloggiee/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bloggiee/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: HelperScreen(),
      routes: {
        'login': (context) => LoginScreen(),
        'signup': (context) => SignUpScreen(),
        'home': (context) => HomeScreen(),
        'landing': (context) => LandingScreen(),
        'helper': (context) => HelperScreen(),
        'add-blog': (context) => AddBlogScreen(),
        'my-blogs': (context) => MyBlogsScreen(),
        'liked-blogs': (context) => LikedBlogsScreen(),
      },
    );
  }
}
