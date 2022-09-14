import 'package:flutter/material.dart';

class MyInput extends StatelessWidget {
  const MyInput({
    Key? key,
    required this.width,
    required this.controller,
    required this.hintText,
    this.hidden,
    this.value,
  }) : super(key: key);

  final double width;
  final TextEditingController controller;
  final String hintText;
  final bool? hidden;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32),
      width: width / 1.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: hidden ?? false,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          fillColor: Color(0xffebecf0),
          filled: true,
        ),
      ),
    );
  }
}
