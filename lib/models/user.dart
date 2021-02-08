import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String uid;
  String email;

  Timestamp accountCreated;
  String displayName;
  String phoneNumber;
  String UserType;
  String image;
  bool block;
  String feedback;


  User({
    this.uid,
    this.email,
    this.accountCreated,
    this.displayName,
    this.phoneNumber,
    this.UserType,
    this.image,
    this.block,
    this.feedback
  });

}
