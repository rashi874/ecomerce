import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// AuthService provides authentication methods for Google, Facebook, and Email/Password.
class AuthService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  // Google Sign-In
  static Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Facebook Sign-In
  static Future<UserCredential?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final OAuthCredential credential = FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    return null;
  }

  // Email/Password Sign-In
  static Future<UserCredential> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Email/Password Registration
  static Future<UserCredential> registerWithEmailPassword(
    String email,
    String password,
  ) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Forgot Password: Send a password reset email.
  static Future<void> sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  // Save user data to Firestore
  static Future<void> _saveUserData(User? user) async {
    if (user != null) {
      final userDoc = _firestore.collection("users").doc(user.uid);
      final userData = {
        "uid": user.uid,
        "email": user.email,
        "displayName": user.displayName ?? "",
        "photoURL": user.photoURL ?? "",
        "createdAt": FieldValue.serverTimestamp(),
      };

      await userDoc.set(userData, SetOptions(merge: true));
    }
  }

  // Get user profile from Firestore
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection("users").doc(user.uid).get();
      return userDoc.data();
    }
    return null;
  }

  // Update user profile
  static Future<void> updateUserProfile({
    String? displayName,
    // String? photoURL,
  }) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      if (displayName != null
      // || photoURL != null
      ) {
        await user.updateDisplayName(displayName);
        // await user.updatePhotoURL(photoURL);
        await user.reload();

        // Update Firestore as well
        final userDoc = _firestore.collection("users").doc(user.uid);
        await userDoc.update({
          "displayName": displayName,
          // if (photoURL != null) "photoURL": photoURL,
        });
      }
    }
  }

  // Sign Out
  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    // await FacebookAuth.instance.logOut();
  }
}
