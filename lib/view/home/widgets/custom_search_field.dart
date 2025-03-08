import 'package:ecomerce/const/const_color.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(60, 200, 200, 200),
              spreadRadius: 4,
              blurRadius: 10,
              offset: Offset(1, 2), // changes position of shadow
            ),
          ],
        ),

        child: TextField(
          decoration: InputDecoration(
            hintText: "Search any Product..",
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: AppColors.kwhite, // Light gray background
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            suffixIcon: Icon(Icons.mic, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
