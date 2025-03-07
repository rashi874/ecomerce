import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProduct() async {
    try {
      await _firestore.collection('products').add({
        "name": "Nike Sneakers",
        "description": "Vision Alta Men’s Shoes Size (All Colours)",
        "price": 1500,
        "original_price": 2999,
        "discount_percentage": 50,
        "rating": 4.0,
        "reviews_count": 56890,
        "sizes": ["6 UK", "7 UK", "8 UK", "9 UK", "10 UK"],
        "selected_size": "7 UK",
        "colors": ["Chicago"],
        "image_urls": [
          "https://your-image-url.com/image1.jpg",
          "https://your-image-url.com/image2.jpg",
        ],
        "features": {"nearest_store": true, "vip": true, "return_policy": true},
        "availability": true,
        "created_at": FieldValue.serverTimestamp(),
      });
      print("Product added successfully!");
    } catch (e) {
      print("Error adding product: $e");
    }
  }
}
