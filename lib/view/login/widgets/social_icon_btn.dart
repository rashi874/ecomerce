import 'package:ecomerce/const/const_color.dart';
import 'package:ecomerce/view/firebase/firebase_services.dart';
import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  final void Function(String) onError; // Callback to handle errors

  const SocialLoginButtons({super.key, required this.onError});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialLoginButton(
          imageUrl:
              'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
          onTap: () async {
            try {
              await AuthService.signInWithGoogle();
            } catch (e) {
              onError(e.toString());
            }
          },
        ),
        const SizedBox(width: 10),
        SocialLoginButton(
          imageUrl:
              'https://static.xx.fbcdn.net/rsrc.php/v3/yG/r/pENh3y_2Pnw.png',
          onTap: () async {
            try {
              await AuthService.signInWithFacebook();
            } catch (e) {
              onError(e.toString());
            }
          },
        ),
      ],
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Color(0xffFCF3F6)),
        side: WidgetStatePropertyAll(
          BorderSide(
            color: AppColors.buttoncolor,
            width: 1,
          ), // Border color and width
        ),
      ),
      iconSize: 10,
      icon: Image.network(height: 30, width: 30, imageUrl),
      onPressed: onTap,
    );
    // child: const Text("Sign in with Google"),

    // GestureDetector(
    //   onTap: onTap,
    //   child: Container(
    //     padding: const EdgeInsets.all(10),
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.grey),
    //       borderRadius: BorderRadius.circular(8),
    //     ),
    //     child: Image.network(imageUrl, height: 30, width: 30),
    //   ),
    // );
  }
}
