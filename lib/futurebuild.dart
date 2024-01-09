// ignore_for_file: must_be_immutable, unused_field, unused_local_variable

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//import 'package:page_transition/page_transition.dart';
//import 'package:flutter_application_1/voice8.dart';
import 'package:flutter_application_1/Splashscreen.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/Connecteddevicepage.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

//addition for future builds
//home page
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cre-',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 180, 45),
                  ),
                ),
                Text(
                  'AID LABS',
                  style: TextStyle(
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.only(top: 100),
            children: <Widget>[
              ListTile(
                title: const Text('Connect Device'),
                onTap: () {
                  Navigator.pushNamed(context, '/connect');
                },
              ),
              ListTile(
                title: const Text('Support'),
                onTap: () {
                  // Handle support option
                },
              ),
            ],
          ),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/connect');
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 255, 180, 45),
                  onPrimary: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onHover: (value) {
                  // Handle hover effect
                },
                child: const Text('Connect Device'),
              ),
            ])));
  }
}
