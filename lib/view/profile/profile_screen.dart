// import 'dart:io';
// import 'package:ecomerce/firebase_services.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final TextEditingController _nameController = TextEditingController();
//   File? _imageFile;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   void _loadUserData() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       final userDoc = await _firestore.collection("users").doc(user.uid).get();
//       if (userDoc.exists) {
//         setState(() {
//           _nameController.text = userDoc["displayName"] ?? "";
//         });
//       }
//     }
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//     );
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//       await _uploadImage();
//     }
//   }

//   Future<void> _uploadImage() async {
//     if (_imageFile == null) return;

//     setState(() {
//       _isLoading = true;
//     });

//     User? user = _auth.currentUser;
//     if (user != null) {
//       try {
//         final ref = FirebaseStorage.instance
//             .ref()
//             .child("profile_pictures")
//             .child("${user.uid}.jpg");

//         await ref.putFile(_imageFile!);
//         final imageUrl = await ref.getDownloadURL();

//         await AuthService.updateUserProfile(photoURL: imageUrl);
//         setState(() {
//           _isLoading = false;
//         });
//       } catch (e) {
//         setState(() {
//           _isLoading = false;
//         });
//         print("Error uploading image: $e");
//       }
//     }
//   }

//   Future<void> _updateName() async {
//     if (_nameController.text.isNotEmpty) {
//       setState(() {
//         _isLoading = true;
//       });

//       await AuthService.updateUserProfile(displayName: _nameController.text);

//       setState(() {
//         _isLoading = false;
//       });

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Profile Updated Successfully")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     User? user = _auth.currentUser;

//     return Scaffold(
//       appBar: AppBar(title: Text("Profile")),
//       body:
//           _isLoading
//               ? Center(child: CircularProgressIndicator())
//               : Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: _pickImage,
//                       child: CircleAvatar(
//                         radius: 50,
//                         backgroundImage:
//                             user?.photoURL != null
//                                 ? NetworkImage(user!.photoURL!)
//                                 : AssetImage("assets/default_profile.png")
//                                     as ImageProvider,
//                         child:
//                             _imageFile == null
//                                 ? Icon(
//                                   Icons.camera_alt,
//                                   size: 30,
//                                   color: Colors.white,
//                                 )
//                                 : null,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextField(
//                       controller: _nameController,
//                       decoration: InputDecoration(labelText: "Name"),
//                     ),
//                     SizedBox(height: 10),
//                     Text("Email: ${user?.email ?? 'Not Available'}"),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _updateName,
//                       child: Text("Update Profile"),
//                     ),
//                   ],
//                 ),
//               ),
//     );
//   }
// }
import 'dart:io';
import 'package:ecomerce/view/firebase/firebase_services.dart';
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
          _nameController.text = userDoc["displayName"] ?? "";
          _addressController.text = userDoc["address"] ?? "";
          _cityController.text = userDoc["city"] ?? "";
          _stateController.text = userDoc["state"] ?? "";
          _zipController.text = userDoc["zip"] ?? "";
          _countryController.text = userDoc["country"] ?? "";
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
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              user?.photoURL != null
                                  ? NetworkImage(user!.photoURL!)
                                  : NetworkImage(
                                    "https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg",
                                  ),
                          // : AssetImage("assets/default_profile.png")
                          //     as ImageProvider,
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
                      SizedBox(height: 10),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: "Name"),
                      ),
                      SizedBox(height: 10),
                      Text("Email: ${user?.email ?? 'Not Available'}"),
                      SizedBox(height: 20),
                      Divider(),
                      Text(
                        "Delivery Address",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _addressController,
                        decoration: InputDecoration(labelText: "Address"),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _cityController,
                        decoration: InputDecoration(labelText: "City"),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _stateController,
                        decoration: InputDecoration(labelText: "State"),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _zipController,
                        decoration: InputDecoration(labelText: "Zip Code"),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _countryController,
                        decoration: InputDecoration(labelText: "Country"),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _updateProfile,
                        child: Text("Update Profile"),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
