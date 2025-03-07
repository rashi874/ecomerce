import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> addToCart(
    String productId,
    String name,
    int price,
    String size,
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
        'size': size,
        'quantity': 1,
      });
    }
  }
}
