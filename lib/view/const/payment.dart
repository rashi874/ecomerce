import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> createPaymentIntent({
  required String name,
  required String address,
  required int amount, // Use int for proper currency conversion
}) async {
  try {
    final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
    final secretKey = dotenv.env["STRIPE_SECRET_KEY"];

    if (secretKey == null || secretKey.isEmpty) {
      print("❌ Stripe Secret Key is missing!");
      return null;
    }

    // Ensure the minimum amount is met (₹50 = ~$0.60 USD)
    if (amount < 50) {
      print("❌ Amount too small, setting minimum ₹50");
      amount = 50;
    }

    final body = {
      'amount':
          (amount * 100)
              .toString(), // Convert to smallest currency unit (paise)
      'currency': "inr",
      'automatic_payment_methods[enabled]': 'true',
      'description': "Shop Payment",
      'shipping[name]': name,
      'shipping[address][line1]': address,
      'shipping[address][country]': "IN",
    };

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $secretKey",
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      print("✅ Payment Intent Created: $json");
      return json;
    } else {
      print("❌ Error in calling Payment Intent: ${response.body}");
      return null;
    }
  } catch (e) {
    print("❌ Exception: $e");
    return null;
  }
}

// /// Stripe Payment Intent creation using Stripe API
// Future<Map<String, dynamic>?> createPaymentIntent({
//   required String name,
//   required String address,
//   required String amount,
// }) async {
//   try {
//     final String? secretKey = dotenv.env["STRIPE_SECRET_KEY"];
//     if (secretKey == null || secretKey.isEmpty) {
//       print("❌ Error: Stripe Secret Key is missing.");
//       return null;
//     }

//     final Uri url = Uri.https('api.stripe.com', '/v1/payment_intents');

//     final Map<String, String> body = {
//       'amount': amount,
//       'currency': "inr",
//       'automatic_payment_methods[enabled]': 'true',
//       'description': "Shop Payment",
//       'shipping[name]': name,
//       'shipping[address][line1]': address,
//       'shipping[address][country]': "IN",
//     };

//     final response = await http.post(
//       url,
//       headers: {
//         "Authorization": "Bearer $secretKey",
//         'Content-Type': 'application/x-www-form-urlencoded',
//       },
//       body: body,
//     );

//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);

//       log("✅ PaymentIntent Created: $jsonResponse");
//       return jsonResponse;
//     } else {
//       print("❌ Error in calling Payment Intent: ${response.body}");
//       return null;
//     }
//   } catch (e) {
//     print("❌ Exception in createPaymentIntent: $e");
//     return null;
//   }
// }
