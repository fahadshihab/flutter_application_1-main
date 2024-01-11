import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';
import 'package:flutter_application_1/Backend/findDevice.dart';
import 'package:flutter_application_1/Frontend/doctor/calibrationPage.dart';

import 'package:flutter_application_1/auth/signinUI.dart';

import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

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
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => exoDeviceFunctions())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Device Control App',
        home: calibrationPage(),
      ),
    );
  }
}
