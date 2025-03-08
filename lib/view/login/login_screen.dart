import 'package:ecomerce/const/const_color.dart';
import 'package:ecomerce/const/const_sizedbox.dart';
import 'package:ecomerce/view/firebase/firebase_services.dart';
import 'package:ecomerce/view/login/forgot_password.dart';
import 'package:ecomerce/view/login/widgets/custom_textfield.dart';
import 'package:ecomerce/view/login/widgets/header_text.dart';
import 'package:ecomerce/view/login/widgets/or_continue_text.dart';
import 'package:ecomerce/view/login/widgets/social_icon_btn.dart';
import 'package:flutter/material.dart';

/// LoginScreen offers three authentication options: Google, Facebook, and Email/Password.
class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordHidden = true;

  bool _isLoading = false;

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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HederText(text: "Welcome\nBack!"),

                ConstSizedBox.ksize30,

                CustomTextField(
                  controller: emailController,
                  labelText: "Username or Email",
                  prefixIcon: Icon(Icons.person),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                ConstSizedBox.ksize10,

                CustomTextField(
                  controller: passwordController,
                  labelText: "Password",
                  obscureText: _isPasswordHidden,
                  suffixIcon: Icon(
                    _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                  ),
                  onSuffixIconTap: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                  prefixIcon: Icon(Icons.lock),
                  // suffixIcon: Icon(Icons.remove_red_eye),
                ),
                // Forgot Password Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPassword(),
                        ),
                      );

                      // ForgotPassword
                    },

                    // onPressed: () async {

                    //   if (emailController.text.isEmpty) {
                    //     _showError(
                    //       context,
                    //       "Please enter your email for password reset.",
                    //     );
                    //     return;
                    //   }
                    //   try {
                    //     await AuthService.sendPasswordResetEmail(
                    //       emailController.text,
                    //     );
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(
                    //         content: Text(
                    //           "Password reset email sent. Check your inbox.",
                    //         ),
                    //       ),
                    //     );
                    //   } catch (e) {
                    //     _showError(context, e.toString());
                    //   }
                    // },
                    child: const Text("Forgot Password?"),
                  ),
                ),
                ConstSizedBox.ksize30,

                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    // style:
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      setState(() => _isLoading = true);
                      try {
                        await AuthService.signInWithEmailPassword(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      } catch (e) {
                        _showError(context, e.toString());
                      } finally {
                        setState(
                          () => _isLoading = false,
                        ); // Stop loading indicator
                      }
                    },
                    // onPressed: () async {
                    //   if (!_formKey.currentState!.validate()) return;

                    //   setState(() => _isLoading = true);
                    //   try {
                    //     await AuthService.signInWithEmailPassword(
                    //       emailController.text,
                    //       passwordController.text,
                    //     );
                    //   } catch (e) {
                    //     _showError(context, e.toString());
                    //   }
                    // },
                    child:
                        _isLoading
                            ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                            : const Text("Login"),
                  ),
                ),
                ConstSizedBox.ksize30,
                Orcontinuetext(),

                ConstSizedBox.ksize20,
                SocialLoginButtons(
                  onError: (errorMessage) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(errorMessage)));
                  },
                ),

                ConstSizedBox.ksize20,

                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.buttonColor,
                      ),
                      children: [
                        TextSpan(text: "Create An Account  "),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/create', // Route name
                                (route) => false, // Remove all previous routes
                              );
                            },
                            // onTap: () async {
                            //   try {
                            //     await AuthService.registerWithEmailPassword(
                            //       emailController.text,
                            //       passwordController.text,
                            //     );
                            //   } catch (e) {
                            //     _showError(context, e.toString());
                            //   }
                            // },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 14,

                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                color: AppColors.buttoncolor,
                                decorationColor: AppColors.buttoncolor,
                                // textBaseline: TextBaseline.ideographic,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
