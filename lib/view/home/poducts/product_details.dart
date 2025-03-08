import 'dart:developer';

import 'package:ecomerce/const/const_color.dart';
import 'package:ecomerce/const/const_sizedbox.dart';
import 'package:ecomerce/view/checkout/shopping_bag.dart';
import 'package:ecomerce/view/checkout/checkout.dart';
import 'package:ecomerce/view/firebase/product_service.dart';
import 'package:ecomerce/view/home/cart/cart_screen.dart';
import 'package:ecomerce/view/home/poducts/widgets/cart_button.dart';
import 'package:ecomerce/view/home/widgets/star_rate.dart';
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
  String selectedSize = '';

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
      selectedSize = productDoc['sizes'][0];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        // title: Text(product!['name']),
        actions: [
          IconButton.filled(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                AppColors.iconcartbtnbacground,
              ),
              foregroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
            ),
            // color: AppColors.backgroundColor,
            // highlightColor: AppColors.backgroundColor,
            // splashColor: AppColors.backgroundColor,
            // focusColor: AppColors.backgroundColor,
            // hoverColor: AppColors.backgroundColor,
            // disabledColor: AppColors.backgroundColor,
            onPressed: () {
              //   _firebaseService.addToCart(
              //     widget.productId,
              //     product!['name'],
              //     product!['price'] ?? '',
              //     selectedSize,
              //   );
              // },
              _firebaseService.addToCart(
                widget.productId,
                product!['name'],
                product!['price'] ?? 0, // Ensure price is always an int
                selectedSize,
                product!['image_urls'][0], // First image from the list
                product!['original_price'] ?? 0,
                product!['discount_percentage'] ?? 0,
                product!['rating']?.toDouble() ??
                    0.0, // Convert rating to double
                // product!['colors'][0],
                // (product!['colors'] is List)
                //     ? product!['colors'][0]
                //     : product!['colors'],
                (product!['colors'] is List)
                    ? List<String>.from(
                      product!['colors'],
                    ) // ✅ Ensure it's always a List<String>
                    : [product!['colors']],
                context,
              );
            },
            icon: Icon(Icons.add_shopping_cart_rounded),
          ),
          ConstSizedBox.ksizew10,
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Carousel
            SizedBox(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: PageView(
                    children: List.generate(
                      (product!['image_urls'] as List).length,
                      (index) => Image.network(
                        product!['image_urls'][index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Size Selection
                  Text(
                    "Size: ${selectedSize ?? ''}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 10,
                    children:
                        (product!['sizes'] as List).map<Widget>((size) {
                          return ChoiceChip(
                            showCheckmark: false,
                            // avatar: null,
                            labelStyle: TextStyle(color: AppColors.chipColor),

                            side: BorderSide(
                              color: AppColors.chipColor,
                              width: 2,
                            ),
                            disabledColor: AppColors.backgroundColor,
                            selectedColor: AppColors.chipColor,

                            label: Text(
                              size.toString(),
                              style: TextStyle(
                                color:
                                    selectedSize == size
                                        ? AppColors.kwhite
                                        : AppColors.chipColor,
                              ),
                            ),
                            selected: selectedSize == size.toString(),
                            onSelected: (selected) {
                              setState(() {
                                selectedSize = size.toString();
                              });
                            },
                          );
                        }).toList(),
                  ),

                  Text(
                    product!['name'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(product!['description'], style: TextStyle(fontSize: 14)),
                  StarRate(product: product!.data() as Map<String, dynamic>),
                  Row(
                    spacing: 10,
                    children: [
                      Text(
                        "\$${product!['original_price']}",
                        style: const TextStyle(
                          // fontStyle: fonts,
                          decoration: TextDecoration.lineThrough,
                          textBaseline: TextBaseline.alphabetic,
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        "₹${product!['price']}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Text(
                        "${product!['discount_percentage']}%Off",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.buttoncolor,

                          // color: Colors.green,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  Text(
                    "Product Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    product!['product_details'],
                    style: TextStyle(fontSize: 13),
                  ),

                  SizedBox(height: 20),

                  Row(
                    children: [
                      GoToCartButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CartPage()),
                          );
                        },
                        gradientcolors: [
                          Color(0xFF0B3689),
                          Color(0xFF3F92FF),
                          Color(0xFF0B3689),
                        ],
                        text: '          Go to cart   ',
                        icon: Icons.shopping_cart,
                      ),
                      GoToCartButton(
                        onPressed: () {
                          log(
                            (product!.data() as Map<String, dynamic>)
                                .toString(),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      OrderSummaryPage(product: product!),

                              // Shoppingbag(
                              //   product:
                              //       product!.data() as Map<String, dynamic>,
                              // ),
                            ),
                          );
                          // _firebaseService.addToCart(
                          //   widget.productId,
                          //   product!['name'],
                          //   product!['price'] ?? '',
                          //   selectedSize,
                          // );
                        },
                        gradientcolors: [Color(0xFF71F9A9), Color(0xFF31B769)],
                        text: '            Buy Now  ',
                        icon: Icons.touch_app,
                      ),
                    ],
                  ),

                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: GestureDetector(
                  //         onTap: () {
                  //           _firebaseService.addToCart(
                  //             widget.productId,
                  //             product!['name'],
                  //             product!['price'] ?? '',
                  //             selectedSize,
                  //           );
                  //         },
                  //         child: Stack(
                  //           alignment: AlignmentDirectional.centerStart,
                  //           children: [
                  //             Container(
                  //               padding: EdgeInsets.all(5),
                  //               decoration: BoxDecoration(
                  //                 color: AppColors.chipColor,
                  //               ),
                  //               child: Text("         Go to Cart   "),
                  //             ),
                  //             Positioned(
                  //               left: 0,
                  //               child: CircleAvatar(
                  //                 radius: 25,
                  //                 child: Icon(Icons.add_ic_call_outlined),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(width: 10),
                  //     Expanded(
                  //       child: ElevatedButton(
                  //         style: ElevatedButton.styleFrom(
                  //           backgroundColor: Colors.green,
                  //         ),
                  //         onPressed: () {
                  //           // Implement Buy Now
                  //         },
                  //         child: Text(
                  //           "Buy Now",
                  //           style: TextStyle(color: Colors.white),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  ConstSizedBox.ksize10,
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.hourcolor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    // elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Delivery in ",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "1 within Hour ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  Text(
                    "Similar To",
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
