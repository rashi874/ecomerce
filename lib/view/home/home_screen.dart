import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomerce/const/const_color.dart';
import 'package:ecomerce/const/const_sizedbox.dart';
import 'package:ecomerce/view/home/poducts/product_details.dart';
import 'package:ecomerce/view/firebase/add_products.dart';
import 'package:ecomerce/view/firebase/firebase_services.dart';
import 'package:ecomerce/view/home/cart/cart_screen.dart';
import 'package:ecomerce/view/home/widgets/custom_search_field.dart';
import 'package:ecomerce/view/home/widgets/deal_of_card.dart';
import 'package:ecomerce/view/home/widgets/featured_category.dart';
import 'package:ecomerce/view/home/widgets/star_rate.dart';
import 'package:ecomerce/view/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// HomeScreen displays a list of products from Firestore.
/// Ensure your Firestore has a collection named "products" with fields like 'name' and 'price'.
class HomeScreen extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/images/logoeco.png'),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.exit_to_app),
          //   onPressed: () async {
          //     await AuthService.signOut(context);
          //   },
          // ),
          IconButton(
            icon: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                'https://t3.ftcdn.net/jpg/02/99/04/20/360_F_299042079_vGBD7wIlSeNl7vOevWHiL93G4koMM967.jpg',
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen()),
              );
            },
          ),
          ConstSizedBox.ksizew10,
          // IconButton(
          //   icon: const Icon(Icons.card_travel),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) => CartPage()),
          //     );
          //   },
          // ),
        ],
      ),

      // Center(
      //   child: ElevatedButton(
      //     onPressed: () async {
      //       await firestoreService.addProduct();
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(content: Text("Product added to Firestore")),
      //       );
      //     },
      //     child: Text("Add Product"),
      //   ),
      // ),
      body: ListView(
        shrinkWrap: true,
        // padding: EdgeInsets.all(value),
        physics: ScrollPhysics(),
        children: [
          CustomSearchBar(),
          FeaturedCategories(),
          DealOfTheDayCard(
            onViewAllPressed: () {},
            countdownDuration: Duration(),
            colors: Color(0xff4392F9),
            title: 'Deal of the Day',
            subtitle: '22h 55m 20s remaining ',
            icons: Icons.alarm,
          ),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('products').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox(
                  height: 320,

                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              final products = snapshot.data!.docs;
              return SizedBox(
                height: 320,
                // width: 200,
                child: RepaintBoundary(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    cacheExtent: 40,
                    padding: EdgeInsets.only(left: 15),
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product =
                          products[index].data() as Map<String, dynamic>;
                      return SizedBox(
                        // height: 170,
                        width: MediaQuery.of(context).size.width / 2,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ProductDetailPage(
                                      productId: products[index].id,
                                    ),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: AppColors.kwhite,
                            elevation: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        product['image_urls'][0], // Cached image URL
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (context, url) => Center(
                                          child:
                                              CircularProgressIndicator(), // Loading indicator
                                        ),
                                    errorWidget:
                                        (context, url, error) => const Icon(
                                          Icons.error,
                                          size: 50,
                                          color: Colors.red,
                                        ), // Error icon
                                  ),
                                ),
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(10),
                                //   child: Image.network(
                                //     product['image_urls'][0],
                                //     height: 150,
                                //     width: double.infinity,
                                //     fit: BoxFit.cover,
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    spacing: 5,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        product['description'],
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w100,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "\$${product['price']}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          // color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Row(
                                        spacing: 10,
                                        children: [
                                          Text(
                                            "\$${product['original_price']}",
                                            style: const TextStyle(
                                              // fontStyle: fonts,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              fontSize: 14,
                                              color: AppColors.textColor,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Text(
                                            "${product['discount_percentage']}%Off",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: AppColors.buttoncolor,

                                              // color: Colors.green,
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // ⭐ Star Rating Widget
                                      StarRate(product: product),

                                      // SizedBox(
                                      //   width: double.infinity,
                                      //   child: ElevatedButton(
                                      //     style: ElevatedButton.styleFrom(
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.circular(8),
                                      //       ),
                                      //       backgroundColor: Colors.blue,
                                      //     ),
                                      //     onPressed: () {
                                      //       // Navigate to checkout or details
                                      //       Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //           builder:
                                      //               (_) => ProductDetailPage(
                                      //                 productId: products[index].id,
                                      //               ),
                                      //         ),
                                      //       );
                                      //     },
                                      //     child: const Text(
                                      //       "Buy Now",
                                      //       style: TextStyle(color: Colors.white),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),

          DealOfTheDayCard(
            onViewAllPressed: () {},
            countdownDuration: Duration(),
            colors: Color(0xffFD6E87),
            title: 'Trending Products ',
            subtitle: 'Last Date 29/02/22',
            icons: Icons.calendar_month,
          ),
        ],
      ),
    );
  }
}


 // return ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: products.length,
                //   itemBuilder: (context, index) {
                //     final product =
                //         products[index].data() as Map<String, dynamic>;
                //     return ListTile(
                //       leading: Image.network(product['image_urls'][0]),
                //       title: Text(product['name']),
                //       subtitle: Text("\$${product['price']}"),
                //       trailing: ElevatedButton(
                //         child: const Text("Buy"),
                //         onPressed: () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder:
                //                   (_) => ProductDetailPage(
                //                     productId: products[index].id,
                //                   ),
                //               // builder: (_) => CheckoutScreen(product: product),
                //             ),
                //           );
                //         },
                //       ),
                //     );
                //   },
                // );