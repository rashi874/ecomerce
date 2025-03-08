import 'package:flutter/material.dart';

class HederText extends StatelessWidget {
  final String text;
  const HederText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
    );
  }
}
