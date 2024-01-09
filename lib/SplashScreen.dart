import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_application_1/ConnectedDevicePage.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.of(context).push(PageTransition(
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 500),
        child: ConnectDevicePage()
      ));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/images/main_logo.png'),
          ),
        ),
      ),
    );
  }
}
