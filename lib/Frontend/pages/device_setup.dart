import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/checkBluetoothConnection.dart';
import 'package:flutter_application_1/Frontend/color_theme/theme.dart';

import 'package:flutter_application_1/Frontend/pages/bottomNavBar.dart';
import 'package:flutter_application_1/Frontend/pages/manual_Mode.dart';
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
  int? flexlimit;
  int? extlimit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // setSpeedOnStartUp();
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
    int curFlexAngle = Provider.of<exoDeviceFunctions>(context).curFlexAngle.toInt();
    final hexobt = Provider.of<exoBluetoothControlFunctions>(context);
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
            color: device_setup_ColorConstants.appBarTitleColor,
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
      backgroundColor: device_setup_ColorConstants.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                !zero_set
                    ? 'Set Maximum Extension'
                    : extlimit == null
                        ? 'Set Extension Limit'
                        : 'Set Flexion Limit',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: device_setup_ColorConstants.buttonColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                child: Text(
                  textAlign: TextAlign.center,
                  !zero_set
                      ? "Use the controls to extend the device to be straight at the elbow joint."
                      : 'Please set the flex and extend limits of the device \n\n Current Angle : $curFlexAngle',
                  style: TextStyle(
                    fontSize: 18,
                    color: device_setup_ColorConstants.textColor1,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //button1
                  GestureDetector(
                   
                    onTapDown: (details) {
                      // startFlexing();
                      hexobt.flex(currentSpeed, serialTX!);
                    },
                    onTapUp: (details) {
                      // stopFlexing();
                      hexobt.stop(serialTX!);
                    },
                    onTapCancel: () => hexobt.stop(serialTX!),
                    child: _Flex_BUTTON(),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  //button2
                  GestureDetector(
                    
                    onTap: () {
                      hexobt.EmergencyStop(serialTX!);
                      // exoDeviceFunctions().setCurFlexAngle(30);
                    },
                    child: _Stop_BUTTON(),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  //button3
                  GestureDetector(
                    onTapDown: (details) {
                      hexobt.extend(currentSpeed, serialTX!);
                    },
                    onTapUp: (details) {
                      hexobt.stop(serialTX!);
                    },
                    onTapCancel: () => hexobt.stop(serialTX!),
                    child: _Extend_BUTTON(),
                  ),
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
                  color: device_setup_ColorConstants.buttonColor,
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
              //button5
              GestureDetector(
                onTap: () {
                  if (zero_set == false) {
                    hexobt.setZero(serialTX!);
                    setState(() {
                      zero_set = true;
                    });
                    SnackBar snackBar = SnackBar(
                      content: Center(
                        child: Text(
                          'Maximum Extension Set',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color:
                                device_setup_ColorConstants.dialogButtonTextColor,
                          ),
                        ),
                      ),
                      duration: Duration(milliseconds: 500),
                      backgroundColor:
                          device_setup_ColorConstants.snackBarBackgroundColor,
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
                          child: Text(
                            'Extension Limit set to $curFlexAngle',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: device_setup_ColorConstants
                                  .dialogButtonTextColor,
                            ),
                          ),
                        ),
                        duration: Duration(milliseconds: 500),
                        backgroundColor:
                            device_setup_ColorConstants.snackBarBackgroundColor,
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
                            child: Text(
                              'Calibration Complete',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: device_setup_ColorConstants.buttonColor,
                              ),
                            ),
                          ),
                          content: Text(
                            'Flexion Limit set to $flexlimit \nExtension Limit set to $extlimit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: device_setup_ColorConstants.dialogTextColor,
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => manualMode()),
                                  (route) => false,
                                );
                                Provider.of<exoBluetoothControlFunctions>(context,
                                        listen: false)
                                    .setROMLimitEnabled(
                                        true,
                                        Provider.of<exoBluetoothControlFunctions>(
                                                context,
                                                listen: false)
                                            .serialTX!);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF004788),
                              ),
                              child: Text(
                                'OK',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: device_setup_ColorConstants
                                      .dialogButtonTextColor,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  extlimit = null;
                                  flexlimit = null;
                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF004788),
                              ),
                              child: Text(
                                're-calibrate',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: device_setup_ColorConstants
                                      .dialogButtonTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
                child: _setLimit_BUTTON(
                  extention: extlimit == null ? true : false,
                  set_zero: zero_set,
                ),
              ),
             Spacer(),
             if (zero_set)
              Align(
                alignment: Alignment.bottomLeft,
                child: TextButton(
                  onPressed: () {
                   if (zero_set){
                    if (extlimit != null){
                      setState(() {
                        extlimit = null;
                        flexlimit = null;
                       
                      });}
                      else{
                        setState(() {
                          zero_set = false;
                        });
                      }
                   }
                  },
                  child: Text(
                    '< Back',
                    style: TextStyle(
                      
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: device_setup_ColorConstants.textColor1,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
    Key? key,
    required this.speed,
    required this.currentSpeed,
    required this.serialTX,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hexobt = Provider.of<exoBluetoothControlFunctions>(context);
    //button4
    return GestureDetector(
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
                  color: device_setup_ColorConstants.textColor2,
                )),
          ),
          duration: Duration(milliseconds: 500),
          backgroundColor: device_setup_ColorConstants.primaryColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: speed == currentSpeed
              ? device_setup_ColorConstants.primaryColor
              : device_setup_ColorConstants.secondaryColor,
          border: Border.all(
            color: device_setup_ColorConstants.borderColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: device_setup_ColorConstants.boxShadow,
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
                  ? device_setup_ColorConstants.textColor2
                  : device_setup_ColorConstants.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _Extend_BUTTON extends StatelessWidget {
  const _Extend_BUTTON({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: device_setup_ColorConstants.secondaryColor,
        border: Border.all(
          color: device_setup_ColorConstants.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: device_setup_ColorConstants.boxShadow,
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
            color: device_setup_ColorConstants.primaryColor,
          ),
        ),
      ),
    );
  }
}

class _Stop_BUTTON extends StatelessWidget {
  const _Stop_BUTTON({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: device_setup_ColorConstants.stopButtonColor,
        border: Border.all(
          color: device_setup_ColorConstants.stopButtonBorderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: device_setup_ColorConstants.boxShadow,
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
            color: device_setup_ColorConstants.stopButtonTextColor,
          ),
        ),
      ),
    );
  }
}

class _Flex_BUTTON extends StatelessWidget {
  const _Flex_BUTTON({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: device_setup_ColorConstants.secondaryColor,
        border: Border.all(
          color: device_setup_ColorConstants.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: device_setup_ColorConstants.boxShadow,
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
            color: device_setup_ColorConstants.primaryColor,
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
    Key? key,
    required this.extention,
    required this.set_zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 350,
      decoration: BoxDecoration(
        color: device_setup_ColorConstants.setLimitButtonColor,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: device_setup_ColorConstants.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: device_setup_ColorConstants.boxShadow,
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
              : 'Set Maximum Extension',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: device_setup_ColorConstants.textColor2,
          ),
        ),
      ),
    );
  }
}
