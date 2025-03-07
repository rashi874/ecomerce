import 'package:ecomerce/const/const_sizedbox.dart';
import 'package:ecomerce/view/firebase/firebase_services.dart';
import 'package:ecomerce/view/login/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

/// LoginScreen offers three authentication options: Google, Facebook, and Email/Password.
class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginScreen({super.key});

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
              Text(
                "Welcome\nBack!",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),

              ElevatedButton(
                onPressed: () async {
                  try {
                    await AuthService.signInWithFacebook();
                  } catch (e) {
                    _showError(context, e.toString());
                  }
                },
                child: const Text("Sign in with Facebook"),
              ),
              CustomTextField(controller: emailController, labelText: "Email"),
              CustomTextField(
                controller: passwordController,
                labelText: "Password",
                obscureText: true,
              ),
              // Forgot Password Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
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
                  child: const Text("Forgot Password?"),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // style:
                  onPressed: () async {
                    try {
                      await AuthService.signInWithEmailPassword(
                        emailController.text,
                        passwordController.text,
                      );
                    } catch (e) {
                      _showError(context, e.toString());
                    }
                  },
                  child: const Text("Login"),
                ),
              ),
              ConstSizedBox.ksize30,
              Center(
                child: Text(
                  "- OR Continue with -",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton.outlined(
                iconSize: 10,
                icon: Image.network(
                  height: 40,
                  width: 40,
                  'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
                ),
                onPressed: () async {
                  try {
                    await AuthService.signInWithGoogle();
                  } catch (e) {
                    _showError(context, e.toString());
                  }
                },
                // child: const Text("Sign in with Google"),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await AuthService.registerWithEmailPassword(
                      emailController.text,
                      passwordController.text,
                    );
                  } catch (e) {
                    _showError(context, e.toString());
                  }
                },
                child: const Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
