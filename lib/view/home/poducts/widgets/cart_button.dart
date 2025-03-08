import 'package:flutter/material.dart';

class GoToCartButton extends StatelessWidget {
  final VoidCallback onPressed;
  final List<Color> gradientcolors;
  final String text;
  final IconData icon;

  const GoToCartButton({
    super.key,
    required this.onPressed,
    required this.gradientcolors,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        GestureDetector(
          onTap: onPressed,
          // style: ElevatedButton.styleFrom(
          //   backgroundColor: Colors.blue, // Button color
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(30), // Rounded corners
          //   ),
          //   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          // ),
          child: Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(vertical: 6),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 2.0,
                  blurStyle: BlurStyle.inner,
                ),
              ],
              gradient: LinearGradient(
                colors: gradientcolors,
                //  gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0, // Adjust icon position
          child: Container(
            height: 42,
            width: 42,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              // color: Colors.blue, // White background behind icon
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: gradientcolors, //  gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 2.0,
                  blurStyle: BlurStyle.inner,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }
}
