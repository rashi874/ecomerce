import 'dart:async';
import 'package:ecomerce/const/const_color.dart';
import 'package:flutter/material.dart';

class DealOfTheDayCard extends StatefulWidget {
  final VoidCallback onViewAllPressed;
  final Duration countdownDuration;
  final Color colors;
  final String title;
  final String subtitle;
  final IconData icons;

  const DealOfTheDayCard({
    super.key,
    required this.onViewAllPressed,
    required this.countdownDuration,
    required this.colors,
    required this.title,
    required this.subtitle,
    required this.icons,
  });

  @override
  _DealOfTheDayCardState createState() => _DealOfTheDayCardState();
}

class _DealOfTheDayCardState extends State<DealOfTheDayCard> {
  late Duration remainingTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.countdownDuration;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime = remainingTime - const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  // String formatDuration(Duration duration) {
  //   String hours = duration.inHours.toString().padLeft(2, '0');
  //   String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
  //   String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  //   return "$hours h $minutes m $seconds s remaining";
  // }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.colors, // Background Color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side (Text & Timer)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  color: AppColors.backgroundColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    widget.icons,
                    color: AppColors.backgroundColor,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.subtitle,

                    // formatDuration(remainingTime),
                    style: const TextStyle(
                      color: AppColors.backgroundColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Right Side (View All Button)
          TextButton(
            onPressed: widget.onViewAllPressed,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: const BorderSide(color: AppColors.backgroundColor),
            ),
            child: const Row(
              children: [
                Text("View all"),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: AppColors.backgroundColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
