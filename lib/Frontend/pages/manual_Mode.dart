import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';
import 'package:flutter_application_1/Frontend/pages/bottomNavBar.dart';
import 'package:flutter_application_1/Frontend/widgets/hexoAnimation.dart';
import 'package:flutter_application_1/Frontend/widgets/voiceAnimation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:item_count_number_button/item_count_number_button.dart';

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
        .flexLimit; // double flexLimit = 110
    .0;
    double endLimit = Provider.of<exoDeviceFunctions>(context)
        .extLimit; // double extLimit = 0.0;
    final currentState = Provider.of<exoDeviceFunctions>(context);

    int speed = Provider.of<exoDeviceFunctions>(context).speed_setting;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 235, 246, 255),
            Color.fromARGB(255, 255, 255, 255),
          ],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: bottomNavBar(),
        extendBodyBehindAppBar: true,
        backgroundColor: Color.fromARGB(0, 240, 240, 242),
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
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
        body: SafeArea(
            child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 13),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Color.fromARGB(255, 255, 255, 255),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(121, 158, 158, 158),
                      spreadRadius: 0,
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Text(
                            'Range of Motion',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 90, 90, 90),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '$startLimit° to $endLimit°',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color.fromARGB(255, 90, 90, 90),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //devider line
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 1,
                      width: MediaQuery.of(context).size.width * 0.9,
                      color: Color.fromARGB(70, 0, 0, 0),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: hexoAnimationWidget()),
                  ],
                )),
            // voiceAnimation(),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Limits display

                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTapDown: (details) {
                        // startFlexing();
                        exoBluetoothControlFunctions().flex(speed, serialTX);
                      },
                      onTapUp: (details) {
                        exoBluetoothControlFunctions().stop(serialTX);
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
                  GestureDetector(
                      onTap: () {
                        Provider.of<exoBluetoothControlFunctions>(context,
                                listen: false)
                            .EmergencyStop(serialTX);
                      },
                      child: _Stop_BUTTON()),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTapDown: (details) {
                        Provider.of<exoBluetoothControlFunctions>(context,
                                listen: false)
                            .extend(speed, serialTX);
                      },
                      onTapUp: (details) {
                        Provider.of<exoBluetoothControlFunctions>(context,
                                listen: false)
                            .stop(serialTX);
                      },
                      onTapCancel: () =>
                          Provider.of<exoBluetoothControlFunctions>(context,
                                  listen: false)
                              .stop(serialTX),
                      child: _Extend_BUTTON()),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //intrementer
                Column(
                  children: [
                    Text('Speed Control',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(0xFF004788),
                        )),
                    SizedBox(height: 10),
                    ItemCount(
                        color: Color.fromARGB(109, 0, 70, 136),
                        buttonSizeHeight: 40,
                        buttonSizeWidth: 40,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        initialValue: Provider.of<exoDeviceFunctions>(context)
                            .speed_setting,
                        minValue: 1,
                        maxValue: 5,
                        onChanged: ((value) {
                          Provider.of<exoDeviceFunctions>(context,
                                  listen: false)
                              .setSpeed(value.toInt());
                          Provider.of<exoBluetoothControlFunctions>(context,
                                  listen: false)
                              .setSpeed(value.toInt(), serialTX!);
                        }),
                        decimalPlaces: 1),
                  ],
                ),

                Container(
                    padding: EdgeInsets.only(top: 5, right: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0,
                      ),
                      shape: BoxShape.circle,
                      color: Color(0xff004788),
                    ),
                    child: SizedBox(
                        height: 80, width: 80, child: voiceAnimation()))
              ],
            )
          ],
        )),
      ),
    );
  }

  /////////////////////////////// FOR TESTING PURPOSES ONLY  BELOW ///////////////////////////////
  ///
  ///
  ///
  startFlexing() {
    if (isFlexing == false) {
      flextimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        Provider.of<exoDeviceFunctions>(context, listen: false)
            .test_flex(false);
      });
      setState(() {
        isFlexing = true;
      });
    }
  }

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
      height: 110,
      width: 110,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 243, 244, 246),
        borderRadius: BorderRadius.circular(1),
        border: Border.all(
          color: Color(0xDFA8BED2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0,
            blurRadius: 0,
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
      height: 110,
      width: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Color(0xffFBE9E9),
        border: Border.all(
          color: Color(0xDFD2A8A8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0,
            blurRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Stop',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF880000),
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
      height: 110,
      width: 110,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 243, 244, 246),
        borderRadius: BorderRadius.circular(1),
        border: Border.all(
          color: Color(0xDFA8BED2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0,
            blurRadius: 0,
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
