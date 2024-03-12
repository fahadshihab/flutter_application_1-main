import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/checkBluetoothConnection.dart';

import 'package:flutter_application_1/Frontend/pages/bottomNavBar.dart';
import 'package:flutter_application_1/Frontend/pages/manual_Mode.dart';
import 'package:flutter_application_1/Frontend/widgets/hexoAnimation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../Backend/exoDeviceFunctions.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPopup();
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<exoBluetoothControlFunctions>(context, listen: false)
          .disableAngleControl(
              Provider.of<exoBluetoothControlFunctions>(context, listen: false)
                  .serialTX!);
      Provider.of<exoBluetoothControlFunctions>(context, listen: false)
          .setROMLimitEnabled(
              false,
              Provider.of<exoBluetoothControlFunctions>(context, listen: false)
                  .serialTX!);
    });
  }

  void _showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Column(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 200,
                  color: Colors.amber,
                ),
                Text(
                  'DONT WEAR THE DEVICE YET!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Color(0xFF004788),
                  ),
                ),
              ],
            ),
          ),
          content: Text(
            'Hold off on wearing your new companion until we guide you through setup.',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  // setSpeedOnStartUp() async {
  //   await Future.delayed(Duration(milliseconds: 100));
  //   Provider.of<exoDeviceFunctions>(context, listen: false).setSpeed(1);
  //   Provider.of<exoDeviceFunctions>(context, listen: false).setExtLimit(180);
  //   Provider.of<exoDeviceFunctions>(context, listen: false).setFlexLimit(15);
  // }

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
    final hexobt = Provider.of<exoBluetoothControlFunctions>(context);
    int currentSpeed = Provider.of<exoDeviceFunctions>(context).speed_setting;
    BluetoothCharacteristic? serialTX =
        Provider.of<exoBluetoothControlFunctions>(context).serialTX;

    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 37),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                // BUTTON #1
                onTap: () {
                  setState(() {
                    if (extlimit != null) {
                      if (flexlimit == null) {
                        setState(() {
                          extlimit = null;
                        });
                      } else {
                        setState(() {
                          extlimit = null;
                          zero_set = false;
                        });
                      }
                    } else if (flexlimit != null) {
                      setState(() {
                        flexlimit = null;
                        extlimit = null;
                      });
                    } else {
                      setState(() {
                        zero_set = false;
                      });
                    }
                  });
                },
                child: Text(
                  '< Back',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF004788),
                  ),
                ),
              ),
              GestureDetector(
                  // BUTTON #2
                  onTap: () {
                    if (zero_set == false) {
                      // hexobt.setZero(serialTX!);
                      setState(() {
                        zero_set = true;
                      });
                      SnackBar snackBar = SnackBar(
                        content: Center(
                          child: Text('Zero set',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
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
                        hexobt.setExtLimit(serialTX!);
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
                        hexobt.setFlexLimit(serialTX!);
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
                  )),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            'Device Setup',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromARGB(255, 90, 90, 90),
            ),
          ),
        ),
        backgroundColor: Color(0xffBECEDD),
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Image.asset(
                !zero_set
                    ? 'assets/app V2/steps bar/step1.png'
                    : extlimit == null
                        ? 'assets/app V2/steps bar/step2.png'
                        : 'assets/app V2/steps bar/step3.png',
                width: MediaQuery.of(context).size.width,
              )),
        ),
      ),
      backgroundColor: Color(0xFFF0F0F2),
      body: ListView(
        children: [
          Container(
            color: Color(0xff5D84A7),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Column(
              children: [
                Text(
                  !zero_set
                      ? 'Put device in maximum extension'
                      : extlimit == null
                          ? 'Set Extention Limit'
                          : 'Set Flexion Limit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  !zero_set
                      ? 'Use the controls to extend the device to be straight at the elbow joint.'
                      : 'Set the extension limit to the patient’s free R.O.M',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          if (!zero_set)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Image.asset(
                  'assets/app V2/Device Gif/output-onlinegiftools.gif'),
            ),
          if (zero_set) SizedBox(height: 280, child: hexoAnimationWidget()),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  // BUTTON #3
                  onTapDown: (details) {
                    // startFlexing();
                    hexobt.flex(currentSpeed, serialTX!);
                  },
                  onTapUp: (details) {
                    // stopFlexing();
                    hexobt.stop(serialTX!);
                  },
                  onTapCancel: () => hexobt.stop(serialTX!),
                  child: _Flex_BUTTON()),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                  // BUTTON #4
                  onTap: () {
                    hexobt.EmergencyStop(serialTX!);
                    // exoDeviceFunctions().setCurFlexAngle(30);
                  },
                  child: _Stop_BUTTON()),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                  // BUTTON #5
                  onTapDown: (details) {
                    hexobt.extend(currentSpeed, serialTX!);
                  },
                  onTapUp: (details) {
                    hexobt.stop(serialTX!);
                  },
                  onTapCancel: () => hexobt.stop(serialTX!),
                  child: _Extend_BUTTON()),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Speed',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF004788),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          ),
          SizedBox(
            height: 40,
          ),
        ],
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
    final hexobt = Provider.of<exoBluetoothControlFunctions>(context);
    print(currentSpeed);
    return GestureDetector(
      // BUTTON #6
      onTap: () {
        Provider.of<exoDeviceFunctions>(context, listen: false).setSpeed(speed);
        Provider.of<exoBluetoothControlFunctions>(context, listen: false)
            .setSpeed(speed, serialTX!);
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
          color: speed == currentSpeed
              ? Color.fromARGB(255, 0, 71, 136)
              : Color.fromARGB(255, 208, 222, 235),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color.fromARGB(32, 0, 70, 136),
            width: 1,
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey,
          //     spreadRadius: 0,
          //     blurRadius: 2,
          //   ),
          // ],
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
        color: Color.fromARGB(255, 208, 222, 235),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Color.fromARGB(32, 0, 70, 136),
          width: 1,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey,
        //     spreadRadius: 0,
        //     blurRadius: 2,
        //   ),
        // ],
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
        color: Color.fromARGB(255, 206, 82, 82),
        border: Border.all(
          color: Color.fromARGB(38, 136, 0, 0),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          'Stop',
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
        color: Color.fromARGB(255, 208, 222, 235),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Color.fromARGB(32, 0, 70, 136),
          width: 1,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey,
        //     spreadRadius: 0,
        //     blurRadius: 2,
        //   ),
        // ],
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
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                  ? 'Set Extension Limit'
                  : 'Set Flexion Limit'
              : 'Store',
          style: TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
    );
  }
}
