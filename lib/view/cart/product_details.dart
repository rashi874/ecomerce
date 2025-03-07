import 'dart:developer';

import 'package:ecomerce/view/firebase/product_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final FirebaseService _firebaseService = FirebaseService();
  DocumentSnapshot? product;
  List<DocumentSnapshot>? similarProducts;
  String selectedSize = "";

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  void fetchProductDetails() async {
    DocumentSnapshot productDoc = await _firebaseService.getProductDetails(
      widget.productId,
    );

    log(widget.productId);
    // List<DocumentSnapshot> similarProductsList = await _firebaseService
    //     .getSimilarProducts(
    //       List<String>.from(productDoc['similarProducts'] ?? []),
    //     );

    setState(() {
      product = productDoc;
      // similarProducts = similarProductsList;
      selectedSize = productDoc['sizes'][0].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(product!['name'])),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Carousel
            // SizedBox(
            //   height: 250,
            //   child: PageView(
            //     children: List.generate(
            //       (product!['images'] as List).length,
            //       (index) => Image.network(
            //         product!['images'][index],
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product!['name'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  Row(
                    children: [
                      Text(
                        "₹${product!['price']}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: 10),
                      // Text(
                      //   "₹${product!['oldPrice']}",
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     color: Colors.grey,
                      //     decoration: TextDecoration.lineThrough,
                      //   ),
                      // ),
                      SizedBox(width: 10),
                      // Text(
                      //   product!['discount'],
                      //   style: TextStyle(fontSize: 16, color: Colors.red),
                      // ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // Size Selection
                  Text(
                    "Size:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 10,
                    children:
                        (product!['sizes'] as List).map<Widget>((size) {
                          return ChoiceChip(
                            label: Text(size.toString()),
                            selected: selectedSize == size.toString(),
                            onSelected: (selected) {
                              setState(() {
                                selectedSize = size.toString();
                              });
                            },
                          );
                        }).toList(),
                  ),

                  SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _firebaseService.addToCart(
                              widget.productId,
                              product!['name'],
                              product!['price'] ?? '',
                              selectedSize,
                            );
                          },
                          child: Text("Add to Cart"),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            // Implement Buy Now
                          },
                          child: Text(
                            "Buy Now",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  Text(
                    "Product Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(product!['description'], style: TextStyle(fontSize: 14)),

                  SizedBox(height: 20),

                  Text(
                    "Similar Products",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  // similarProducts == null
                  // ? Center(child: CircularProgressIndicator())
                  // : SizedBox(
                  //   height: 200,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount: similarProducts!.length,
                  //     itemBuilder: (context, index) {
                  //       final similar = similarProducts![index];
                  //       return GestureDetector(
                  //         onTap: () {
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder:
                  //                   (context) => ProductDetailPage(
                  //                     productId: similar.id,
                  //                   ),
                  //             ),
                  //           );
                  //         },
                  //         child: Card(
                  //           child: Column(
                  //             children: [
                  //               Image.network(
                  //                 similar['images'][0],
                  //                 height: 100,
                  //                 width: 100,
                  //                 fit: BoxFit.cover,
                  //               ),
                  //               Text(similar['name']),
                  //               Text(
                  //                 "₹${similar['price']}",
                  //                 style: TextStyle(
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
