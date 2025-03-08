import 'package:ecomerce/const/const_color.dart';
import 'package:ecomerce/view/home/widgets/star_rate.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onRemove;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const CartItem({
    super.key,
    required this.data,
    required this.onRemove,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      shadowColor: AppColors.iconcartbtnbacground,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    data['imageUrl'],
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Text(
                            'variations:',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          Text(
                            data['variations'][0],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            data['variations'].length > 1
                                ? data['variations'][1]
                                : '',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      StarRate(product: data),

                      // Price and Discount
                      Row(
                        spacing: 7,
                        children: [
                          Text(
                            "\$${data['price']}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "\$${data['originalPrice']}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Upto ${data['discount']}% off",
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Rating
                      // Row(
                      //   children: [
                      //     const Icon(Icons.star, color: Colors.amber, size: 18),
                      //     Text("${data['rating']}"),
                      //     const SizedBox(width: 10),
                      //     ...data['variations'].map<Widget>(
                      //       (variant) => Padding(
                      //         padding: const EdgeInsets.only(right: 4),
                      //         child: Chip(
                      //           label: Text(variant),
                      //           backgroundColor: Colors.grey[200],
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),

                // Quantity Controls
                // Column(
                //   children: [
                //     Row(
                //       children: [
                //         IconButton(
                //           icon: const Icon(
                //             Icons.remove_circle_outline,
                //             color: Colors.blue,
                //           ),
                //           onPressed: onDecrease,
                //         ),
                //         Text(
                //           data['quantity'].toString(),
                //           style: const TextStyle(
                //             fontSize: 16,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //         IconButton(
                //           icon: const Icon(
                //             Icons.add_circle_outline,
                //             color: Colors.blue,
                //           ),
                //           onPressed: onIncrease,
                //         ),
                //       ],
                //     ),
                //     // Remove button
                //     IconButton(
                //       icon: const Icon(Icons.delete, color: Colors.red),
                //       onPressed: onRemove,
                //     ),
                //   ],
                // ),
              ],
            ),

            Divider(color: AppColors.iconcartbtnbacground),
          ],
        ),
      ),
    );
  }
}
