import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerce/view/checkout/checkout.dart';
import 'package:flutter/material.dart';

class OrderSummaryPage extends StatelessWidget {
  final DocumentSnapshot product;

  const OrderSummaryPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    log(product['name']);
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Bag"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Details
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      product["image_urls"][0], // Dynamic Image
                      width: 80,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product["name"], // Dynamic Title
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          product["description"], // Dynamic Description
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text("Size: ", style: TextStyle(fontSize: 12)),
                            // DropdownButton<String>(
                            //   value: product["size"].toString(),
                            //   items:
                            //       product["availableSizes"]
                            //           .map<DropdownMenuItem<String>>(
                            //             (size) => DropdownMenuItem(
                            //               value: size.toString(),
                            //               child: Text(size.toString()),
                            //             ),
                            //           )
                            //           .toList(),
                            //   onChanged: (value) {},
                            // ),
                            SizedBox(width: 10),
                            Text("Qty: ", style: TextStyle(fontSize: 12)),
                            // DropdownButton<String>(
                            //   value: product["quantity"].toString(),
                            //   items:
                            //       ["1", "2", "3"]
                            //           .map(
                            //             (qty) => DropdownMenuItem(
                            //               value: qty,
                            //               child: Text(qty),
                            //             ),
                            //           )
                            //           .toList(),
                            //   onChanged: (value) {},
                            // ),
                          ],
                        ),
                        SizedBox(height: 5),
                        // Text(
                        //   "Delivery by ${product["deliveryDate"]}",
                        //   style: TextStyle(fontWeight: FontWeight.bold),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Apply Coupon
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_offer, color: Colors.black54),
                      SizedBox(width: 5),
                      Text("Apply Coupons"),
                    ],
                  ),
                  Text("Select", style: TextStyle(color: Colors.red)),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Order Payment Details
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Payment Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  _buildDetailRow("Order Amounts", "₹ ${product["price"]}"),
                  _buildDetailRow(
                    "Convenience",
                    "Know More",
                    color: Colors.red,
                    isAction: true,
                  ),
                  // _buildDetailRow(
                  //   "Delivery Fee",
                  //   product["deliveryFee"],
                  //   color: Colors.green,
                  //   isAction: false,
                  // ),
                  Divider(),
                  // _buildDetailRow("Order Total", "₹ ${product["totalPrice"]}"),
                  _buildDetailRow(
                    "EMI Available",
                    "Details",
                    color: Colors.red,
                    isAction: true,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Bottom Payment Section
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  // _buildDetailRow(
                  //   "₹ ${product["totalPrice"]}",
                  //   "View Details",
                  //   color: Colors.red,
                  //   isAction: true,
                  // ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CheckoutScreen(product: product),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(child: Text("Proceed to Payment")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String title,
    String value, {
    Color color = Colors.black,
    bool isAction = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.black54)),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: isAction ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
