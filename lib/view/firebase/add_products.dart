import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProduct() async {
    try {
      // await _firestore.collection('products').add({
      //   "name": "Nike Sneakers",
      //   "description": "Vision Alta Men’s Shoes Size (All Colours)",
      //   "price": 1500,
      //   "original_price": 2999,
      //   "discount_percentage": 50,
      //   "rating": 4.0,
      //   "reviews_count": 56890,
      //   "sizes": ["6 UK", "7 UK", "8 UK", "9 UK", "10 UK"],
      //   "selected_size": "7 UK",
      //   "colors": ["Chicago"],
      //   "image_urls": [
      //     "https://your-image-url.com/image1.jpg",
      //     "https://your-image-url.com/image2.jpg",
      //   ],
      //   "features": {"nearest_store": true, "vip": true, "return_policy": true},
      //   "availability": true,
      //   "created_at": FieldValue.serverTimestamp(),
      // });

      await _firestore.collection('products').add({
        "name": "Men's Cotton Shirt",
        "description":
            "Premium quality cotton shirt for casual and formal wear",
        "price": 1200,
        "original_price": 2499,
        "discount_percentage": 52,
        "rating": 4.5,
        "reviews_count": 12345,
        "sizes": ["S", "M", "L", "XL", "XXL"],
        "selected_size": "L",
        "colors": ["Blue", "Black", "White"],
        "image_urls": [
          "https://d118ps6mg0w7om.cloudfront.net/media/catalog/product/1/_/fit-in/1000x1333/1_bndr-4148-t-78-light-grey.jpg",
          "https://d118ps6mg0w7om.cloudfront.net/media/catalog/product/1/_/fit-in/278x348/1_bndr-4155-t-02-white.jpg",
        ],
        "features": {
          "nearest_store": true,
          "vip": false,
          "return_policy": true,
          "fabric": "100% Cotton",
          "fit": "Regular Fit",
        },
        "availability": true,
        "created_at": FieldValue.serverTimestamp(),
      });

      print("Product added successfully!");
    } catch (e) {
      print("Error adding product: $e");
    }
  }
}
