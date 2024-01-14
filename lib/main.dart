import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';
import 'package:flutter_application_1/Backend/findDevice.dart';
import 'package:flutter_application_1/Frontend/doctor/manual%20mode/calibration_Page.dart';
import 'package:flutter_application_1/Frontend/doctor/manual%20mode/manual_Mode.dart';
import 'package:flutter_application_1/Frontend/doctor/manual%20mode/therapymode.dart';

import 'package:flutter_application_1/auth/signinUI.dart';

import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Frontend/doctor/manual mode/device_setup.dart';
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
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ),
    );
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => exoDeviceFunctions())],
      child: MaterialApp(
          routes: {
            // '/home': (context) => HomeScreen(),
            '/deviceSetup': (context) => deviceSetup(),
            '/manual': (context) => manualMode(),
            // '/info': (context) => InfoScreen(),
            '/calibration': (context) => calibration_page(),
            '/therapy': (context) => therapyMode(),
            '/info': (context) => deviceSetup(),
            // Add other routes as needed
          },
          debugShowCheckedModeBanner: false,
          title: 'Device Control App',
          home: therapyMode()),
    );
  }
}
