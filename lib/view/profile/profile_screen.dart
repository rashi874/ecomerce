import 'dart:io';
import 'package:ecomerce/view/firebase/firebase_services.dart';
import 'package:ecomerce/view/profile/widget/main_text.dart';
import 'package:ecomerce/view/profile/widget/profile_textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection("users").doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          _nameController.text = userDoc["email"] ?? "";
          // _addressController.text = userDoc["address"] ?? "";
          _addressController.text =
              userDoc.data()!.containsKey("address") ? userDoc["address"] : "";
          _cityController.text =
              userDoc.data()!.containsKey("city") ? userDoc["city"] : "";
          _stateController.text =
              userDoc.data()!.containsKey("state") ? userDoc["state"] : "";
          _zipController.text =
              userDoc.data()!.containsKey("zip") ? userDoc["zip"] : "";
          _countryController.text =
              userDoc.data()!.containsKey("country") ? userDoc["country"] : "";
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    setState(() {
      _isLoading = true;
    });

    User? user = _auth.currentUser;
    if (user != null) {
      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child("profile_pictures")
            .child("${user.uid}.jpg");

        await ref.putFile(_imageFile!);
        // final imageUrl = await ref.getDownloadURL();

        await AuthService.updateUserProfile(
          // photoURL: imageUrl
        );
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print("Error uploading image: $e");
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      await AuthService.updateUserProfile(displayName: _nameController.text);

      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          "displayName": _nameController.text,
          "address": _addressController.text,
          "city": _cityController.text,
          "state": _stateController.text,
          "zip": _zipController.text,
          "country": _countryController.text,
        }, SetOptions(merge: true));
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Profile Updated Successfully")));
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                user?.photoURL != null
                                    ? NetworkImage(user!.photoURL!)
                                    : NetworkImage(
                                      "https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg",
                                    ),
                            child:
                                _imageFile == null
                                    ? Icon(
                                      Icons.camera_alt,
                                      size: 30,
                                      color: Colors.white,
                                    )
                                    : null,
                          ),
                        ),
                      ),
                      MainTexts(text: 'Personal Details', tsize: 16),

                      // Name Field
                      ProfileTextfield(
                        controller: _nameController,
                        label: "Email Address",
                      ),
                      ProfileTextfield(
                        controller: _passwordController,
                        label: "Password",
                      ),

                      // Text("Email: ${user?.email ?? 'Not Available'}"),
                      // SizedBox(height: 20),
                      Divider(),
                      MainTexts(text: 'Business Address Details', tsize: 15),

                      // Address Fields
                      ProfileTextfield(
                        controller: _addressController,
                        label: "Address",
                      ),
                      ProfileTextfield(
                        controller: _cityController,
                        label: "City",
                      ),
                      ProfileTextfield(
                        controller: _stateController,
                        label: "State",
                      ),
                      ProfileTextfield(
                        controller: _zipController,
                        label: "Zip Code",
                      ),
                      ProfileTextfield(
                        controller: _countryController,
                        label: "Country",
                      ),

                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _updateProfile,
                          child: Text("Save"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
