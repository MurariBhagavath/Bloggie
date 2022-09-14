import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    Key? key,
    required this.width,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final double width;
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 50,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 32),
        color: Colors.blue.shade600,
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
