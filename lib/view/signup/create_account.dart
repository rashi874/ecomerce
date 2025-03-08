import 'package:ecomerce/const/const_color.dart';
import 'package:ecomerce/const/const_sizedbox.dart';
import 'package:ecomerce/view/firebase/firebase_services.dart';
import 'package:ecomerce/view/login/widgets/custom_textfield.dart';
import 'package:ecomerce/view/login/widgets/header_text.dart';
import 'package:ecomerce/view/login/widgets/or_continue_text.dart';
import 'package:ecomerce/view/login/widgets/social_icon_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool _isPasswordHidden = true;
  bool _isPasswordHiddenone = true;
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HederText(text: "Create an \naccount"),
                ConstSizedBox.ksize30,

                /// Email Field
                CustomTextField(
                  controller: emailController,
                  labelText: "Username or Email",
                  prefixIcon: const Icon(Icons.person),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your email";
                    }
                    if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value.trim())) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                ConstSizedBox.ksize10,

                /// Password Field
                CustomTextField(
                  controller: passwordController,
                  labelText: "Password",
                  obscureText: _isPasswordHiddenone,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordHiddenone
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordHiddenone = !_isPasswordHiddenone;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your password";
                    }
                    if (value.trim().length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                ConstSizedBox.ksize10,

                /// Confirm Password Field
                CustomTextField(
                  controller: confirmController,
                  labelText: "Confirm Password",
                  obscureText: _isPasswordHidden,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordHidden = !_isPasswordHidden;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please confirm your password";
                    }
                    if (value.trim() != passwordController.text.trim()) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
                ConstSizedBox.ksize10,

                /// Terms & Conditions Text
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: "By clicking the ",
                    style: TextStyle(color: AppColors.textColor, fontSize: 12),
                    children: [
                      TextSpan(
                        text: "Register",
                        style: TextStyle(color: AppColors.buttoncolor),
                      ),
                      const TextSpan(
                        text: " button, you agree\nto the public offer",
                      ),
                    ],
                  ),
                ),
                ConstSizedBox.ksize30,

                /// Register Button
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _isLoading
                            ? null
                            : () async {
                              if (!_formKey.currentState!.validate()) return;

                              setState(() => _isLoading = true);
                              try {
                                await AuthService.signUpWithEmail(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                  context,
                                );
                              } catch (e) {
                                _showError(context, e.toString());
                              } finally {
                                setState(() => _isLoading = false);
                              }
                            },
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text("Create Account"),
                  ),
                ),

                // /// LoginScreen offers three authentication options: Google, Facebook, and Email/Password.
                // class CreateAccount extends StatelessWidget {
                //   final _formKey = GlobalKey<FormState>();
                //   final TextEditingController emailController = TextEditingController();
                //   final TextEditingController passwordController = TextEditingController();

                //   final TextEditingController confirmController = TextEditingController();

                //   bool _isPasswordHidden = true;

                //   bool _isLoading = false;

                //   CreateAccount({super.key});

                //   void _showError(BuildContext context, String message) {
                //     ScaffoldMessenger.of(
                //       context,
                //     ).showSnackBar(SnackBar(content: Text(message)));
                //   }

                //   @override
                //   Widget build(BuildContext context) {
                //     return Scaffold(
                //       appBar: AppBar(),
                //       body: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 25),
                //         child: SingleChildScrollView(
                //           child: Form(
                //             key: _formKey,
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.start,
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 HederText(text: "Create an \naccount"),

                //                 ConstSizedBox.ksize30,

                //                 CustomTextField(
                //                   controller: emailController,
                //                   labelText: "Username or Email",
                //                   prefixIcon: Icon(Icons.person),
                //                   validator: (value) {
                //                     if (value == null || value.isEmpty) {
                //                       return "Please enter your email";
                //                     }
                //                     if (!RegExp(
                //                       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                //                     ).hasMatch(value)) {
                //                       return "Enter a valid email";
                //                     }
                //                     return null;
                //                   },
                //                 ),
                //                 ConstSizedBox.ksize10,

                //                 CustomTextField(
                //                   controller: passwordController,
                //                   labelText: "Password",
                //                   obscureText: true,
                //                   prefixIcon: Icon(Icons.lock),
                //                   suffixIcon: Icon(Icons.remove_red_eye),
                //                   validator: (value) {
                //                     if (value == null || value.isEmpty) {
                //                       return "Please enter your password";
                //                     }
                //                     if (value.length < 6) {
                //                       return "Password must be at least 6 characters";
                //                     }
                //                     return null;
                //                   },
                //                 ),
                //                 ConstSizedBox.ksize10,

                //                 CustomTextField(
                //                   controller: passwordController,
                //                   labelText: "Confirm Password",
                //                   obscureText: true,
                //                   prefixIcon: Icon(Icons.lock),
                //                   suffixIcon: Icon(Icons.remove_red_eye),
                //                   validator: (value) {
                //                     if (value == null || value.isEmpty) {
                //                       return "Please confirm your password";
                //                     }
                //                     if (value != passwordController.text) {
                //                       return "Passwords do not match";
                //                     }
                //                     return null;
                //                   },
                //                 ),

                //                 ConstSizedBox.ksize10,

                //                 // Forgot Password Button
                //                 RichText(
                //                   textAlign: TextAlign.start,
                //                   text: TextSpan(
                //                     text: "By clicking the ",
                //                     style: TextStyle(color: AppColors.textColor, fontSize: 12),
                //                     children: [
                //                       TextSpan(
                //                         text: "Register",
                //                         style: TextStyle(
                //                           color:
                //                               AppColors
                //                                   .buttoncolor, // Change color to indicate it's clickable
                //                           // fontWeight: FontWeight.bold,
                //                         ),
                //                       ),
                //                       TextSpan(text: " button, you agree\nto the public offer"),
                //                     ],
                //                   ),
                //                 ),

                //                 ConstSizedBox.ksize30,

                //                 SizedBox(
                //                   height: 50,
                //                   width: double.infinity,
                //                   child: ElevatedButton(
                //                     // style:
                //                     onPressed: () async {
                //                       try {
                //                         await AuthService.signUpWithEmail(
                //                           emailController.text,
                //                           passwordController.text,
                //                           context,
                //                         );
                //                       } catch (e) {
                //                         _showError(context, e.toString());
                //                       }
                //                     },
                //                     child: const Text("Create Account"),
                //                   ),
                //                 ),
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
                        TextSpan(text: "I Already Have an Account  "),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login', // Route name
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
                              "Login",
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

                // CustomTextField(
                //   controller: emailController,
                //   labelText: "Username or Email",
                //   prefixIcon: Icon(Icons.person),
                // ),
                // ConstSizedBox.ksize10,

                // CustomTextField(
                //   controller: passwordController,
                //   labelText: "Password",
                //   obscureText: true,
                //   prefixIcon: Icon(Icons.lock),
                //   suffixIcon: Icon(Icons.remove_red_eye),
                // ),
                // ConstSizedBox.ksize10,

                // CustomTextField(
                //   controller: passwordController,
                //   labelText: "Password",
                //   obscureText: true,
                //   prefixIcon: Icon(Icons.lock),
                //   suffixIcon: Icon(Icons.remove_red_eye),
                // ),