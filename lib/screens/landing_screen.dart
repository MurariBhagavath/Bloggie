import 'package:bloggiee/widgets/my_button.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          Text(
            'Bloggie',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          MyButton(
              width: width,
              onTap: () {
                Navigator.pushNamed(context, 'signup');
              },
              title: 'SignUp'),
          SizedBox(height: 54),
          MyButton(
              width: width,
              onTap: () {
                Navigator.pushNamed(context, 'login');
              },
              title: 'Login'),
          Spacer(),
        ],
      ),
    );
  }
}
