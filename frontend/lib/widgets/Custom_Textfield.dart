import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {

  final String? hint_text;
  final Icon? prefix_icon;
  final TextEditingController controller;
  final Color? prefixIcon_color;
  final Color? hintText_color;

  const CustomTextfield({
    super.key,
    this.hint_text,
    this.prefix_icon,
    this.prefixIcon_color,
    required this.controller,
    this.hintText_color,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: hintText_color),
        hintText: hint_text,
        prefixIcon: prefix_icon,
        prefixIconColor: prefixIcon_color,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
