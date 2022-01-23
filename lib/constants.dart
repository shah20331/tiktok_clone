import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tictok_app/controllers/auth_controller.dart';
import 'package:tictok_app/views/screens/add_video_screen.dart';
import 'package:tictok_app/views/screens/profile_screen.dart';
import 'package:tictok_app/views/screens/search_screen.dart';
import 'package:tictok_app/views/screens/video_screen.dart';

//colors
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// controller
var authController = AuthController.instance;

//buttomnevigationbar
List pages = [
  VideoScreen(),
  SearchScreen(),
  const AddVideoScreen(),
  const Center(child: Text('massage')),
  ProfileScreen(id: authController.user.uid),
];
