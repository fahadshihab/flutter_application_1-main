import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Splashscreen.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/sahil/auth/signIN.dart';

import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';

import 'package:flutter_application_1/ConnectedDevicePage.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(DeviceControl());
}

class DeviceControl extends StatelessWidget {
  const DeviceControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Control App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: signIN_UI(),
      routes: {
        '/connect': (context) => const ConnectDevicePage(),
        '/devicecontrol': (context) => DeviceControl(),
      },
    );
  }
}
