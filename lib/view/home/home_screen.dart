import 'package:ecomerce/view/cart/product_details.dart';
import 'package:ecomerce/view/firebase/add_products.dart';
import 'package:ecomerce/view/firebase/firebase_services.dart';
import 'package:ecomerce/view/cart/cart_screen.dart';
import 'package:ecomerce/view/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// AuthWrapper checks the FirebaseAuth state and routes accordingly.

/// HomeScreen displays a list of products from Firestore.
/// Ensure your Firestore has a collection named "products" with fields like 'name' and 'price'.
class HomeScreen extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await AuthService.signOut();
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.card_travel),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartPage()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await firestoreService.addProduct();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Product added to Firestore")),
                );
              },
              child: Text("Add Product"),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('products').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final products = snapshot.data!.docs;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product =
                      products[index].data() as Map<String, dynamic>;
                  return ListTile(
                    leading: Image.network(product['image_urls'][0]),
                    title: Text(product['name']),
                    subtitle: Text("\$${product['price']}"),
                    trailing: ElevatedButton(
                      child: const Text("Buy"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ProductDetailPage(
                                  productId: products[index].id,
                                ),
                            // builder: (_) => CheckoutScreen(product: product),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
