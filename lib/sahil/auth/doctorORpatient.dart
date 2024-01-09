import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<bool?> doctorORpatient(User? user) async {
  if (user == null) {
    return null;
  }
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      Map data = documentSnapshot.data() as Map<String, dynamic>;
      if (data['role'] == 'doctor') {
        return true;
      } else if (data['role'] == 'patient') {
        return false;
      }
    } else {
      return false;
    }
  });
  return false;
}
