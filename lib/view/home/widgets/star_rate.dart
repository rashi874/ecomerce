import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class StarRate extends StatelessWidget {
  const StarRate({super.key, required this.product});

  final Map<String, dynamic> product;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        RatingBarIndicator(
          rating: (product['rating'] ?? 0).toDouble(),
          itemBuilder:
              (context, _) => const Icon(Icons.star, color: Colors.amber),
          itemCount: 5,
          itemSize: 16,
          direction: Axis.horizontal,
        ),
        Text(
          "${product['reviews_count'] ?? ''}",
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
