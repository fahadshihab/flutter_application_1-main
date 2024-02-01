import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/checkBluetoothConnection.dart';

import 'package:flutter_application_1/Frontend/doctor/manual%20mode/bottomNavBar.dart';
import 'package:flutter_application_1/Frontend/doctor/manual%20mode/manual_Mode.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../Backend/exoDeviceFunctions.dart';

class deviceSetup extends StatefulWidget {
  const deviceSetup({super.key});

  @override
  State<deviceSetup> createState() => _deviceSetupState();
}

class _deviceSetupState extends State<deviceSetup> {
  Timer? flextimer;
  bool isFlexing = false;
  bool isExtending = false;
  bool zero_set = false;
  double? flexlimit;
  double? extlimit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setSpeedOnStartUp();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BluetoothCharacteristic? serialTX =
          Provider.of<exoBluetoothControlFunctions>(context, listen: false)
              .serialTX;

      Provider.of<exoBluetoothControlFunctions>(context, listen: false)
          .setROMLimitEnabled(false, serialTX!);

      Provider.of<exoBluetoothControlFunctions>(context, listen: false)
          .disableAngleControl(serialTX);
      Provider.of<exoBluetoothControlFunctions>(context, listen: false)
          .getData(serialTX);
    });
  }

  setSpeedOnStartUp() async {
    await Future.delayed(Duration(milliseconds: 100));
    Provider.of<exoDeviceFunctions>(context, listen: false).setSpeed(1);
    Provider.of<exoDeviceFunctions>(context, listen: false).setExtLimit(180);
    Provider.of<exoDeviceFunctions>(context, listen: false).setFlexLimit(15);
  }

  void dispose() {
    flextimer?.cancel();
    super.dispose();

    isFlexing = false;
    isExtending = false;
    flexlimit = null;
    extlimit = null;
  }

  @override
  Widget build(BuildContext context) {
    double curFlexAngle = Provider.of<exoDeviceFunctions>(context).curFlexAngle;
    int currentSpeed = Provider.of<exoDeviceFunctions>(context).speed_setting;
    BluetoothCharacteristic? serialTX =
        Provider.of<exoBluetoothControlFunctions>(context).serialTX;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Device Setup',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color.fromARGB(255, 90, 90, 90),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/main_logo.png',
              height: 50,
              width: 50,
            ),
          )
        ],
      ),
      backgroundColor: Color(0xFFF0F0F2),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              !zero_set
                  ? 'Set Zero'
                  : extlimit == null
                      ? 'Set Extention Limit'
                      : 'Set Flexion Limit',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Color(0xFF004788),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
              child: Text(
                textAlign: TextAlign.center,
                !zero_set
                    ? "Set Max Extention of the device. The device shoule be stright"
                    : 'Please set the flex and extend limits of the device \n\n Current  ngle : $curFlexAngle',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 90, 90, 90),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTapDown: (details) {
                      // startFlexing();
                      exoBluetoothControlFunctions()
                          .flex(currentSpeed, serialTX!);
                    },
                    onTapUp: (details) {
                      // stopFlexing();
                      exoBluetoothControlFunctions().stop(serialTX!);
                    },
                    onTapCancel: () =>
                        exoBluetoothControlFunctions().stop(serialTX!),
                    child: _Flex_BUTTON()),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                    onTap: () {
                      exoBluetoothControlFunctions().EmergencyStop(serialTX!);
                    },
                    child: _Stop_BUTTON()),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                    onTapDown: (details) {
                      exoBluetoothControlFunctions()
                          .extend(currentSpeed, serialTX!);
                    },
                    onTapUp: (details) {
                      exoBluetoothControlFunctions().stop(serialTX!);
                    },
                    onTapCancel: () =>
                        exoBluetoothControlFunctions().stop(serialTX!),
                    child: _Extend_BUTTON()),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Speed',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF004788),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Speed_BUTTON(
                  speed: 1,
                  currentSpeed: currentSpeed,
                  serialTX: serialTX,
                ),
                SizedBox(
                  width: 10,
                ),
                _Speed_BUTTON(
                  speed: 2,
                  currentSpeed: currentSpeed,
                  serialTX: serialTX,
                ),
                SizedBox(
                  width: 10,
                ),
                _Speed_BUTTON(
                  speed: 3,
                  currentSpeed: currentSpeed,
                  serialTX: serialTX,
                ),
                SizedBox(
                  width: 10,
                ),
                _Speed_BUTTON(
                  speed: 4,
                  currentSpeed: currentSpeed,
                  serialTX: serialTX,
                ),
                SizedBox(
                  width: 10,
                ),
                _Speed_BUTTON(
                  speed: 5,
                  currentSpeed: currentSpeed,
                  serialTX: serialTX,
                ),
              ],
            ),
            SizedBox(
              height: 80,
            ),
            GestureDetector(
                onTap: () {
                  if (zero_set == false) {
                    exoBluetoothControlFunctions().setZero(serialTX!);
                    setState(() {
                      zero_set = true;
                    });
                    SnackBar snackBar = SnackBar(
                      content: Center(
                        child: Text('Zero set',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 255, 255, 255),
                            )),
                      ),
                      duration: Duration(milliseconds: 500),
                      backgroundColor: Color(0xFF004788),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    if (extlimit == null) {
                      setState(() {
                        extlimit = curFlexAngle;
                      });
                      exoBluetoothControlFunctions().setExtLimit(serialTX!);
                      SnackBar snackBar = SnackBar(
                        content: Center(
                          child: Text('Extention Limit set to $curFlexAngle',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color.fromARGB(255, 255, 255, 255),
                              )),
                        ),
                        duration: Duration(milliseconds: 500),
                        backgroundColor: Color(0xFF004788),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      setState(() {
                        flexlimit = curFlexAngle;
                      });
                      exoBluetoothControlFunctions().setFlexLimit(serialTX!);
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Center(
                                  child: Text('Calibration Complete',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color(0xFF004788),
                                      )),
                                ),
                                content: Text(
                                  'Flexion Limit set to $flexlimit \nExtention Limit set to $extlimit',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 90, 90, 90),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF004788),
                                      ),
                                      onPressed: () {
                                        Provider.of<exoBluetoothControlFunctions>(
                                                context,
                                                listen: false)
                                            .setROMLimitEnabled(true, serialTX);
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    manualMode()),
                                            (route) => false);
                                      },
                                      child: Text('OK',
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          ))),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF004788),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          extlimit = null;
                                          flexlimit = null;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text('re-calibrate',
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          ))),
                                ],
                              ));
                    }
                  }
                },
                child: _setLimit_BUTTON(
                  extention: extlimit == null ? true : false,
                  set_zero: zero_set,
                ))
          ],
        ),
      ),
    );
  }
}

class _Speed_BUTTON extends StatelessWidget {
  int speed;
  int currentSpeed;
  BluetoothCharacteristic? serialTX;
  _Speed_BUTTON({
    super.key,
    required this.speed,
    required this.currentSpeed,
    required this.serialTX,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        exoBluetoothControlFunctions().setSpeed(speed, serialTX!);
        SnackBar snackBar = SnackBar(
          content: Center(
            child: Text('Speed set to $speed',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromARGB(255, 255, 255, 255),
                )),
          ),
          duration: Duration(milliseconds: 500),
          backgroundColor: Color(0xFF004788),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: speed == currentSpeed ? Color(0xFF004788) : Color(0xFFA8BED2),
          border: Border.all(
            color: Color.fromARGB(32, 0, 70, 136),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 0,
              blurRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            speed.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: speed == currentSpeed
                  ? Color.fromARGB(255, 255, 255, 255)
                  : Color(0xFF004788),
            ),
          ),
        ),
      ),
    );
  }
}

class _Extend_BUTTON extends StatelessWidget {
  const _Extend_BUTTON({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Color(0xFFA8BED2),
        border: Border.all(
          color: Color.fromARGB(32, 0, 70, 136),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0,
            blurRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Extend',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: const Color(0xFF004788),
          ),
        ),
      ),
    );
  }
}

class _Stop_BUTTON extends StatelessWidget {
  const _Stop_BUTTON({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Color(0xFFD2A8A8),
        border: Border.all(
          color: Color.fromARGB(38, 136, 0, 0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0,
            blurRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Stop',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: const Color(0xFF880000),
          ),
        ),
      ),
    );
  }
}

class _Flex_BUTTON extends StatelessWidget {
  const _Flex_BUTTON({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Color(0xFFA8BED2),
        border: Border.all(
          color: Color.fromARGB(32, 0, 70, 136),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0,
            blurRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Flex',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: const Color(0xFF004788),
          ),
        ),
      ),
    );
  }
}

class _setLimit_BUTTON extends StatelessWidget {
  bool extention;
  bool set_zero;

  _setLimit_BUTTON({
    super.key,
    required this.extention,
    required this.set_zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 350,
      decoration: BoxDecoration(
        color: const Color(0xFF004788),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Color.fromARGB(32, 0, 70, 136),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0,
            blurRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          set_zero
              ? extention == true
                  ? 'Set Extition Limit'
                  : 'Set Flexion Limit'
              : 'Set Zero',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
    );
  }
}
