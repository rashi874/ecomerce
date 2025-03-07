import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> addToCart(
    String productId,
    String name,
    double price,
  ) async {
    final String userId = _auth.currentUser!.uid;
    final cartRef = _firestore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(productId);

    final doc = await cartRef.get();
    if (doc.exists) {
      // Increase quantity if already in cart
      await cartRef.update({'quantity': FieldValue.increment(1)});
    } else {
      // Add new item to cart
      await cartRef.set({
        'productId': productId,
        'name': name,
        'price': price,
        'quantity': 1,
      });
    }
  }

  static Future<void> removeFromCart(String productId) async {
    final String userId = _auth.currentUser!.uid;
    await _firestore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(productId)
        .delete();
  }

  static Future<void> updateQuantity(String productId, int quantity) async {
    final String userId = _auth.currentUser!.uid;
    if (quantity > 0) {
      await _firestore
          .collection('carts')
          .doc(userId)
          .collection('items')
          .doc(productId)
          .update({'quantity': quantity});
    } else {
      await removeFromCart(productId);
    }
  }

  static Stream<QuerySnapshot> getCartItems() {
    final String userId = _auth.currentUser!.uid;
    return _firestore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .snapshots();
  }
}
