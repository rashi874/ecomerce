import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerce/controller/cart_controller.dart';
import 'package:ecomerce/view/home/cart/cart_item_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: StreamBuilder<QuerySnapshot>(
        stream: cartProvider.cartItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Your cart is empty"));
          }

          final cartItems = snapshot.data!.docs;

          return ListView(
            padding: EdgeInsets.all(15),
            shrinkWrap: true,
            children: [
              Text(
                'Shopping List',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  // final data = item.data() as Map<String, dynamic>;

                  final data = item.data() as Map<String, dynamic>;

                  return CartItem(
                    data: data,
                    onRemove:
                        () => cartProvider.removeFromCart(data['productId']),
                    onIncrease:
                        () => cartProvider.updateQuantity(
                          data['productId'],
                          data['quantity'] + 1,
                        ),
                    onDecrease:
                        () => cartProvider.updateQuantity(
                          data['productId'],
                          data['quantity'] - 1,
                        ),
                  );
                  // return ListTile(
                  //   leading: CircleAvatar(child: Text(data['quantity'].toString())),
                  //   title: Text(data['name']),
                  //   subtitle: Text("\$${data['price']}"),
                  //   trailing: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       IconButton(
                  //         icon: Icon(Icons.remove),
                  //         onPressed: () {
                  //           cartProvider.updateQuantity(
                  //             data['productId'],
                  //             data['quantity'] - 1,
                  //           );
                  //         },
                  //       ),
                  //       IconButton(
                  //         icon: Icon(Icons.add),
                  //         onPressed: () {
                  //           cartProvider.updateQuantity(
                  //             data['productId'],
                  //             data['quantity'] + 1,
                  //           );
                  //         },
                  //       ),
                  //       IconButton(
                  //         icon: Icon(Icons.delete, color: Colors.red),
                  //         onPressed: () {
                  //           cartProvider.removeFromCart(data['productId']);
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
