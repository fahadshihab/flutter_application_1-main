import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';
import 'package:flutter_application_1/Frontend/doctor/manual%20mode/bottomNavBar.dart';
import 'package:flutter_application_1/Frontend/widgets/hexoAnimation.dart';
import 'package:flutter_application_1/Frontend/widgets/voiceAnimation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';

class manualMode extends StatefulWidget {
  const manualMode({super.key});

  @override
  State<manualMode> createState() => _manualModeState();
}

class _manualModeState extends State<manualMode> {
  bool isFlexing = false;
  bool isExtending = false;
  Timer? flextimer;
  @override
  Widget build(BuildContext context) {
    BluetoothCharacteristic serialTX =
        Provider.of<exoBluetoothControlFunctions>(context).serialTX!;
    double currentAngle = Provider.of<exoDeviceFunctions>(context)
        .curFlexAngle; // double currentAngle = 90.0;
    double startLimit = Provider.of<exoDeviceFunctions>(context)
        .flexLimit; // double flexLimit = 120.0;
    double endLimit = Provider.of<exoDeviceFunctions>(context)
        .extLimit; // double extLimit = 0.0;
    int speed = Provider.of<exoDeviceFunctions>(context).speed_setting;
    return Scaffold(
      bottomNavigationBar: bottomNavBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xffF0F0F2),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Manual Mode',
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
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 225, 229, 232),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 0,
                  blurRadius: 8,
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    //Limits display
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 241, 243, 246),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Limits',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(255, 90, 90, 90),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Flex: $startLimit°',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 90, 90, 90),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Extend: $endLimit°',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 90, 90, 90),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                        onTapDown: (details) {
                          // startFlexing();
                          exoBluetoothControlFunctions().flex(speed, serialTX);
                        },
                        onTapUp: (details) {
                          exoBluetoothControlFunctions().flex(speed, serialTX);
                          // stopFlexing();
                        },
                        onTapCancel: () {
                          // stopFlexing();
                          exoBluetoothControlFunctions().stop(serialTX);
                        },
                        child: _Flex_BUTTON()),
                    SizedBox(
                      height: 20,
                    ),
                    _Stop_BUTTON(),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                        onTapDown: (details) {
                          exoBluetoothControlFunctions()
                              .extend(speed, serialTX);
                        },
                        onTapUp: (details) {
                          exoBluetoothControlFunctions()
                              .extend(speed, serialTX);
                        },
                        onTapCancel: () =>
                            exoBluetoothControlFunctions().stop(serialTX),
                        child: _Extend_BUTTON()),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 241, 243, 246),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 0,
                      blurRadius: 10,
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                child: Stack(children: [
                  hexoAnimationWidget(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: voiceAnimation(),
                  )
                ])),
          )
        ],
      ),
    );
  }

  /////////////////////////////// FOR TESTING PURPOSES ONLY  BELOW ///////////////////////////////
  ///
  ///
  ///
  // startFlexing() {
  //   if (isFlexing == false) {
  //     flextimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
  //       Provider.of<exoDeviceFunctions>(context, listen: false)
  //           .test_flex(false);
  //     });
  //     setState(() {
  //       isFlexing = true;
  //     });
  //   }
  // }

  // stopFlexing() {
  //   if (isFlexing == true) {
  //     flextimer!.cancel();
  //     setState(() {
  //       isFlexing = false;
  //     });
  //   }
  // }

  ///////////////////////////////////////////////////////////////////////////////////////////// END
}

class _Extend_BUTTON extends StatelessWidget {
  const _Extend_BUTTON({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 70,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 241, 243, 246),
        border: Border.all(
          color: Color.fromARGB(169, 0, 70, 136),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0,
            blurRadius: 10,
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
    return GestureDetector(
      onTap: () {
        Provider.of<exoBluetoothControlFunctions>(context, listen: false)
            .EmergencyStop(Provider.of<exoBluetoothControlFunctions>(context,
                    listen: false)
                .serialTX!);
      },
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xffFBE9E9),
          border: Border.all(
            color: Color.fromARGB(223, 136, 0, 0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 0,
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Stop',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromARGB(255, 221, 10, 10),
            ),
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
      height: 70,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 243, 244, 246),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color.fromARGB(224, 0, 70, 136),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0,
            blurRadius: 10,
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
