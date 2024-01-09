import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/sahil/Frontend/doctor/calibrationPage.dart';
import 'package:flutter_application_1/sahil/Frontend/patient/home.dart';
import 'package:flutter_application_1/sahil/auth/doctorORpatient.dart';

class signIN_UI extends StatefulWidget {
  const signIN_UI({super.key});

  @override
  State<signIN_UI> createState() => _signIN_UIState();
}

class _signIN_UIState extends State<signIN_UI> {
  StreamSubscription<User?>? _listener;
  @override
  void initState() {
    super.initState();
    _listener = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => calibrationPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {
            try {
              await FirebaseAuth.instance
                  .signInWithProvider(GoogleAuthProvider())
                  .then((value) async {
                if (await doctorORpatient(value.user) == true) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => calibrationPage()));
                } else {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => home()));
                }
              });
            } catch (e) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('Error: $e'),
                        content: Text(e.toString()),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'))
                        ],
                      ));
            }
          },
          child: Container(
            height: 100,
            width: 100,
            color: Colors.red,
            child: Text('sign in with google'),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _listener?.cancel();
  }
}
