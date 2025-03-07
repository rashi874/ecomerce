import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerce/view/firebase/cart_service.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  Stream<QuerySnapshot> get cartItems => CartService.getCartItems();

  void addToCart(String productId, String name, double price) {
    CartService.addToCart(productId, name, price);
  }

  void removeFromCart(String productId) {
    CartService.removeFromCart(productId);
  }

  void updateQuantity(String productId, int quantity) {
    CartService.updateQuantity(productId, quantity);
  }
}
