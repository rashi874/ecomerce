import 'package:flutter/material.dart';

class Orcontinuetext extends StatelessWidget {
  const Orcontinuetext({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "- OR Continue with -",
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }
}
