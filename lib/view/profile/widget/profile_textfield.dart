import 'package:ecomerce/const/const_color.dart';
import 'package:flutter/material.dart';

class ProfileTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;

  const ProfileTextfield({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),

          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              fillColor: AppColors.kwhite,
              filled: true,
              // hintText: label,
              // labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.textfieldborder),
              ), // Optional: Adds a border
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),

                borderSide: BorderSide(color: AppColors.textfieldborder),
              ), // Optional: Adds a border

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),

                borderSide: BorderSide(color: AppColors.textfieldborder),
              ), // Optional: Adds a border
            ),
          ),
        ],
      ),
    );
  }
}
