import 'package:ecomerce/view/const/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const CheckoutScreen({super.key, required this.product});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _loading = false;
  String? _paymentStatus;
  Future<void> _handlePayment() async {
    setState(() {
      _loading = true;
      _paymentStatus = null;
    });

    try {
      final paymentIntent = await createPaymentIntent(
        name: "Test User",
        address: "123 Test Street",
        amount: (widget.product['price'] * 100).toInt(),
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
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Product: ${widget.product['name']}"),
            Text("Price: \$${widget.product['price']}"),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _handlePayment,
                  child: const Text("Pay Now"),
                ),
            if (_paymentStatus != null) ...[
              const SizedBox(height: 20),
              Text(_paymentStatus!),
            ],
          ],
        ),
      ),
    );
  }
}
