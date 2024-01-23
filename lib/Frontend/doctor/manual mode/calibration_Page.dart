import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';
import 'package:flutter_application_1/Frontend/doctor/manual%20mode/bottomNavBar.dart';
import 'package:flutter_application_1/Frontend/doctor/manual%20mode/manual_Mode.dart';
import 'package:flutter_application_1/Frontend/widgets/hexoAnimation.dart';
import 'package:provider/provider.dart';

class calibration_page extends StatefulWidget {
  const calibration_page({super.key});

  @override
  State<calibration_page> createState() => _calibration_pageState();
}

class _calibration_pageState extends State<calibration_page> {
  bool flexionMode = true;
  @override
  Widget build(BuildContext context) {
    int speed = Provider.of<exoDeviceFunctions>(context).speed_setting;
    double currentAngle = Provider.of<exoDeviceFunctions>(context).curFlexAngle;
    double flexLimit = Provider.of<exoDeviceFunctions>(context).flexLimit;
    double extLimit = Provider.of<exoDeviceFunctions>(context).extLimit;
    return Scaffold(
      bottomNavigationBar: bottomNavBar(),
      backgroundColor: Color(0xFFECEFF1),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Calibration Mode',
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
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0.5,
                  blurRadius: 7,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
              color: Color(0xFFECEFF1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9E5F0),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (!flexionMode) {
                            setState(() {
                              flexionMode = true;
                            });
                          }
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Center(
                            child: Text(
                              'Flexion',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: flexionMode
                                    ? Color(0xFF004788)
                                    : Color(0xFF7C7C7C),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (flexionMode) {
                            setState(() {
                              flexionMode = false;
                            });
                          }
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Center(
                            child: Text(
                              'Extension',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: flexionMode
                                    ? Color(0xFF7C7C7C)
                                    : Color(0xFF004788),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color:
                              Color.fromRGBO(242, 242, 242, 0.4000000059604645),
                          border: Border.all(
                            color: Color.fromRGBO(215, 215, 215, 1),
                            width: 1,
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              flexionMode
                                  ? 'set Flexion limit to: $currentAngle'
                                  : 'set Extension limit to: $currentAngle',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(16, 16, 16, 1),
                                  fontFamily: 'Roboto',
                                  fontSize: 17,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _movementCircle(
                              anglePlus: -10,
                              intString: '-10',
                              currentangle: currentAngle,
                              extLimit: extLimit,
                              flexLimit: flexLimit,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            _movementCircle(
                              anglePlus: -5,
                              intString: '-5',
                              currentangle: currentAngle,
                              extLimit: extLimit,
                              flexLimit: flexLimit,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            _movementCircle(
                              anglePlus: -1,
                              intString: '-1',
                              currentangle: currentAngle,
                              extLimit: extLimit,
                              flexLimit: flexLimit,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            _movementCircle(
                              anglePlus: 1,
                              intString: '+1',
                              currentangle: currentAngle,
                              extLimit: extLimit,
                              flexLimit: flexLimit,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            _movementCircle(
                              anglePlus: 5,
                              intString: '+5',
                              currentangle: currentAngle,
                              extLimit: extLimit,
                              flexLimit: flexLimit,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            _movementCircle(
                              anglePlus: 10,
                              intString: '+10',
                              currentangle: currentAngle,
                              extLimit: extLimit,
                              flexLimit: flexLimit,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          flexionMode
                              ? 'Calibrate the flexion angle to your free range of motion'
                              : 'Calibrate the extension angle to your range of motion',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF8E8E8E),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 5),
                        child: Text(
                          flexionMode
                              ? 'Current Flexion Limit: $flexLimit'
                              : 'Current Extension Limit: $extLimit',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color.fromARGB(255, 142, 142, 142),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: GestureDetector(
                            onTap: () {
                              if (flexionMode) {
                                Provider.of<exoDeviceFunctions>(context,
                                        listen: false)
                                    .setFlexLimit(currentAngle);
                                SnackBar snackBar = SnackBar(
                                  backgroundColor: Color(0xFF004788),
                                  content: Text(
                                    'Flexion limit set to $currentAngle',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  duration: Duration(seconds: 1),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                Provider.of<exoDeviceFunctions>(context,
                                        listen: false)
                                    .setExtLimit(currentAngle);
                                SnackBar snackBar = SnackBar(
                                  backgroundColor: Color(0xFF004788),
                                  content: Text(
                                    'Extension limit set to $currentAngle',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  duration: Duration(seconds: 1),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            child: Container(
                                margin: EdgeInsets.only(left: 20, bottom: 10),
                                height: 50,
                                width: 150,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  color: Color(0xFFD9E5F0),
                                ),
                                child: Center(
                                  child: Text(
                                    flexionMode
                                        ? 'Set Flex Limit'
                                        : 'Set Exten Limit',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Color(0xFF004788),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 162, 162, 162),
                  spreadRadius: 0.5,
                  blurRadius: 7,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 13,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    'Speed',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF004788),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        'slow',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color.fromARGB(255, 98, 98, 98),
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          activeColor: Color(0xFF004788),
                          value: speed.toDouble(),
                          onChanged: (double value) {
                            Provider.of<exoDeviceFunctions>(context,
                                    listen: false)
                                .setSpeed(value.toInt());
                          },
                          min: 1,
                          max: 10,
                          divisions: 5,
                        ),
                      ),
                      Text(
                        'fast',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color.fromARGB(255, 98, 98, 98),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
              child: hexoAnimationWidget(),
            ),
          )
        ],
      ),
    );
  }
}

class _movementCircle extends StatelessWidget {
  int anglePlus;
  double currentangle;
  String intString;
  double flexLimit;
  double extLimit;
  _movementCircle(
      {super.key,
      required this.anglePlus,
      required this.intString,
      required this.flexLimit,
      required this.extLimit,
      required this.currentangle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (currentangle + anglePlus > 5 && currentangle + anglePlus < 180) {
          Provider.of<exoDeviceFunctions>(context, listen: false)
              .setCurFlexAngle(currentangle + anglePlus);
        }
      },
      child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: Color.fromRGBO(242, 242, 242, 0.4000000059604645),
            border: Border.all(
              color: Color.fromARGB(133, 0, 70, 136),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              intString,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Color(0xFF004788),
              ),
            ),
          )),
    );
  }
}

class _person_BOX extends StatelessWidget {
  const _person_BOX({
    Key? key,
    required this.currentAngle,
  }) : super(key: key);

  final double currentAngle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.large(
              elevation: 0,
              onPressed: () {},
              child: const Text(
                'Stop',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromARGB(255, 255, 252, 252),
                ),
              ),
              backgroundColor: Color.fromARGB(255, 231, 10, 10),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 245, 245, 245),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 0,
                    blurRadius: 3,
                  ),
                ],
              ),
              margin: const EdgeInsets.only(top: 20),
              child: Text(
                '$currentAngle°',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromARGB(255, 27, 27, 27),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Image.asset(
              'assets/images/Group 56 (1).png',
            ),
          ),
        ),
        Positioned(
          top: 20, // Adjust these values as needed (e.g., 9% from the top)
          left: 11, // 8% from the left
          child: Transform.rotate(
            angle: ((currentAngle - 5) * pi) / 180 - 40,
            origin: const Offset(-20, -12),
            child: SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(
                'assets/images/hand.png',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
