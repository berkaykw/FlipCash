import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String? hint_text;
  final Icon? prefix_icon;
  final TextEditingController controller;

  const CustomTextfield({
    super.key,
    this.hint_text,
    this.prefix_icon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Tema renklerini al
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.white70 : Colors.grey;
    final borderColor = isDark ? Colors.white : Colors.black87;

    return TextField(
      style: TextStyle(color: textColor),
      controller: controller,
      decoration: InputDecoration(
        hintText: hint_text,
        hintStyle: TextStyle(color: hintColor),
        prefixIcon: prefix_icon,
        prefixIconColor: textColor,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
