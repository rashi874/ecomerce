import 'package:flutter/material.dart';

class MainTexts extends StatelessWidget {
  final String text;
  final double tsize;

  const MainTexts({super.key, required this.text, required this.tsize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: tsize, fontWeight: FontWeight.bold),
    );
  }
}
