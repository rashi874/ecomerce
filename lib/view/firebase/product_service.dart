import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<DocumentSnapshot> getProductDetails(String productId) async {
    return await _firestore.collection('products').doc(productId).get();
  }

  Future<List<DocumentSnapshot>> getSimilarProducts(
    List<String> productIds,
  ) async {
    if (productIds.isEmpty) return [];

    QuerySnapshot query =
        await _firestore
            .collection('products')
            .where(FieldPath.documentId, whereIn: productIds)
            .get();

    return query.docs;
  }

  // Future<void> addToCart(
  //   String productId,
  //   String name,
  //   int price,
  //   String size,
  // ) async {
  //   final String userId = _auth.currentUser!.uid;
  //   final cartRef = _firestore
  //       .collection('carts')
  //       .doc(userId)
  //       .collection('items')
  //       .doc(productId);

  //   final doc = await cartRef.get();
  //   if (doc.exists) {
  //     await cartRef.update({'quantity': FieldValue.increment(1)});
  //   } else {
  //     await cartRef.set({
  //       'productId': productId,
  //       'name': name,
  //       'price': price,
  //       'size': size,
  //       'quantity': 1,
  //     });
  //   }
  // }
  Future<void> addToCart(
    String productId,
    String name,
    int price,
    String size,
    String imageUrl,
    int originalPrice,
    int discount,
    double rating,
    // List<String> variations,
    List<String> variations, // ✅ Expecting a List<String>
    context,
  ) async {
    final String userId = _auth.currentUser!.uid;
    final cartRef = _firestore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(productId);

    final doc = await cartRef.get();
    if (doc.exists) {
      await cartRef.update({'quantity': FieldValue.increment(1)});
    } else {
      await cartRef.set({
        'productId': productId,
        'name': name,
        'price': price,
        'originalPrice': originalPrice, // Added original price
        'size': size,
        'imageUrl': imageUrl, // Added product image
        'discount': discount, // Added discount percentage
        'rating': rating, // Added product rating
        'variations': variations, // List of color/size variations
        'quantity': 1,
        'addedAt': FieldValue.serverTimestamp(), // Added timestamp
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name added to cart!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/cart',
            ); // Navigate to the cart screen
          },
        ),
      ),
    );
  }
}
