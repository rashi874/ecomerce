import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerce/view/checkout/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CheckoutScreen extends StatefulWidget {
  final DocumentSnapshot product;
  const CheckoutScreen({super.key, required this.product});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _loading = false;
  String? _paymentStatus;
  String? _selectedPaymentMethod;
  final List<Map<String, dynamic>> paymentMethods = [
    {"name": "Stripe", "icon": Icons.credit_card},
    {"name": "Apple Pay", "icon": Icons.apple},
  ];
  Future<void> _handlePayment() async {
    setState(() {
      _loading = true;
      _paymentStatus = null;
    });

    try {
      final paymentIntent = await createPaymentIntent(
        name: "Test User",
        address: "123 Test Street",
        amount: (widget.product['price']),
      );

      if (paymentIntent == null ||
          !paymentIntent.containsKey('client_secret')) {
        setState(() {
          _paymentStatus = "❌ Failed to create Payment Intent.";
        });
        return; // Stop execution to prevent crashing
      }

      final clientSecret = paymentIntent['client_secret'];

      // Initialize the Stripe payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Your Store',
        ),
      );

      // Present the payment sheet
      await Stripe.instance.presentPaymentSheet();
      setState(() {
        _paymentStatus = "✅ Payment Successful!";
      });
    } catch (e) {
      setState(() {
        _paymentStatus = "❌ Payment Failed: $e";
      });
      print("❌ Error in Payment: $e");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double orderAmount = widget.product['price']?.toDouble() ?? 0.0;
    double shippingFee = 30.0;
    double totalAmount = orderAmount + shippingFee;

    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product: ${widget.product['name']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Price: ₹${orderAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Order Summary
            _buildSummaryRow("Order", orderAmount),
            _buildSummaryRow("Shipping", shippingFee),
            const Divider(),
            _buildSummaryRow("Total", totalAmount, isTotal: true),

            const SizedBox(height: 20),

            // Payment Methods
            const Text(
              "Payment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children:
                  paymentMethods.map((method) {
                    bool isSelected = _selectedPaymentMethod == method['name'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = method['name'];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.red : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  method['icon'],
                                  color: Colors.black,
                                  size: 24,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  method['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "********2109",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),

            const Spacer(),

            // Payment Button
            _loading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed:
                        _selectedPaymentMethod == null ? null : _handlePayment,
                    child: const Text(
                      "Continue",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

            if (_paymentStatus != null) ...[
              const SizedBox(height: 20),
              Center(
                child: Text(
                  _paymentStatus!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // return Scaffold(
  //   appBar: AppBar(title: const Text("Checkout")),
  //   body: Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: Column(
  //       children: [
  //         Text("Product: ${widget.product['name']}"),
  //         Text("Price: \$${widget.product['price']}"),
  //         const SizedBox(height: 20),
  //         _loading
  //             ? const CircularProgressIndicator()
  //             : ElevatedButton(
  //               onPressed: _handlePayment,
  //               child: const Text("Pay Now"),
  //             ),
  //         if (_paymentStatus != null) ...[
  //           const SizedBox(height: 20),
  //           Text(_paymentStatus!),
  //         ],
  //       ],
  //     ),
  //   ),
  // );

  Widget _buildSummaryRow(String title, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "₹${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
