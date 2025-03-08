import 'package:ecomerce/const/const_color.dart';
import 'package:ecomerce/const/const_sizedbox.dart';
import 'package:ecomerce/view/firebase/firebase_services.dart';
import 'package:ecomerce/view/login/widgets/custom_textfield.dart';
import 'package:ecomerce/view/login/widgets/header_text.dart';
import 'package:flutter/material.dart';

/// LoginScreen offers three authentication options: Google, Facebook, and Email/Password.
class ForgotPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  ForgotPassword({super.key});

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HederText(text: "Forgot\npassword?"),

              ConstSizedBox.ksize30,

              CustomTextField(
                controller: emailController,
                labelText: "Enter your email address",
                prefixIcon: Icon(Icons.email),
              ),

              // Forgot Password Button
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton(

              //     },
              //     child: const Text("Forgot Password?"),
              //   ),
              // ),
              ConstSizedBox.ksize10,
              const Text(
                "* We will send you a message to set or reset\nyour new password",
                style: TextStyle(fontSize: 11, color: AppColors.primaryColor),
              ),
              ConstSizedBox.ksize40,

              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  // style:
                  onPressed: () async {
                    if (emailController.text.isEmpty) {
                      _showError(
                        context,
                        "Please enter your email for password reset.",
                      );
                      return;
                    }
                    try {
                      await AuthService.sendPasswordResetEmail(
                        emailController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Password reset email sent. Check your inbox.",
                          ),
                        ),
                      );
                    } catch (e) {
                      _showError(context, e.toString());
                    }
                  },
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
