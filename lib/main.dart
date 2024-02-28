import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Backend/checkBluetoothConnection.dart';
import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';
import 'package:flutter_application_1/Backend/findDevice.dart';

import 'package:flutter_application_1/Frontend/pages/calibration_Page.dart';
import 'package:flutter_application_1/Frontend/pages/manual_Mode.dart';
import 'package:flutter_application_1/Frontend/pages/therapymode.dart';

import 'package:provider/provider.dart';
import 'Frontend/pages/device_setup.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => new exoDeviceFunctions()),
        ChangeNotifierProvider(
            create: (_) => new exoBluetoothControlFunctions()),
      ],
      child: DeviceControl(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MainApp());
}

class DeviceControl extends StatefulWidget {
  const DeviceControl({Key? key}) : super(key: key);

  @override
  State<DeviceControl> createState() => _DeviceControlState();
}

class _DeviceControlState extends State<DeviceControl> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    test();
    checkBluetoothConnection(navigatorKey)
        .bluetootchListner(); ///////// UNCOMMENT THISSSSSS
  }

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
    return MaterialApp(
      routes: {
        // '/home': (context) => HomeScreen(),
        '/findDevice': (context) => findDevice(),
        '/deviceSetup': (context) => deviceSetup(),
        '/manual': (context) => manualMode(),
        // '/info': (context) => InfoScreen(),
        '/calibration': (context) => calibration_page(),
        '/therapy': (context) => therapyMode(),

        '/info': (context) => deviceSetup(),
        // Add other routes as needed
      },
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Device Control App',
      home: findDevice(),
      // home: deviceSetup(),
    );
  }
}
