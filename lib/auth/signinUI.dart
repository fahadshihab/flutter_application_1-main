import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/findDevice.dart';
import 'package:flutter_application_1/auth/doctorORpatient.dart';

class signin_UI extends StatelessWidget {
  const signin_UI({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FirebaseAuth.instance
              .signInWithProvider(GoogleAuthProvider())
              .then((value) {
            if (value.user != null) {
              if (doctorORpatient(value.user) == true) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConnectDevicePage()));
              } else if (doctorORpatient(value.user) == false) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConnectDevicePage()));
              }
            }
          });
        },
        child: Scaffold());
  }
}
