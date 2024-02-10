import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';
import 'package:flutter_application_1/Frontend/doctor/manual%20mode/bottomNavBar.dart';
import 'package:flutter_application_1/Frontend/doctor/manual%20mode/manual_Mode.dart';
import 'package:flutter_application_1/Frontend/widgets/hexoAnimation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

class calibration_page extends StatefulWidget {
  const calibration_page({super.key});

  @override
  State<calibration_page> createState() => _calibration_pageState();
}

class _calibration_pageState extends State<calibration_page> {
  bool flexionMode = true;
  //bool angleControlSwitch = false;
  //bool romLimitSwitch = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int speed = Provider.of<exoDeviceFunctions>(context).speed_setting;
    double currentAngle = 0;
    double flexLimit = Provider.of<exoDeviceFunctions>(context).flexLimit;
    double extLimit = Provider.of<exoDeviceFunctions>(context).extLimit;
    BluetoothCharacteristic? serialTX =
        Provider.of<exoBluetoothControlFunctions>(context).serialTX;
    bool romLimitSwitch =
        Provider.of<exoDeviceFunctions>(context).isROMLimitEnabled;
    bool angleControlSwitch =
        Provider.of<exoDeviceFunctions>(context).isAngleControlEnabled;
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
      body: ListView(
        shrinkWrap: true,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (!flexionMode) {
                            setState(() {
                              flexionMode = true;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
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
                      GestureDetector(
                        onTap: () {
                          if (flexionMode) {
                            setState(() {
                              flexionMode = false;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
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
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: ListView(
                    shrinkWrap: true,
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
                              serialTX:
                                  Provider.of<exoBluetoothControlFunctions>(
                                          context)
                                      .serialTX,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            _movementCircle(
                              anglePlus: -5,
                              intString: '-5',
                              currentangle: currentAngle,
                              serialTX:
                                  Provider.of<exoBluetoothControlFunctions>(
                                          context)
                                      .serialTX,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            _movementCircle(
                              anglePlus: -1,
                              intString: '-1',
                              currentangle: currentAngle,
                              serialTX:
                                  Provider.of<exoBluetoothControlFunctions>(
                                          context)
                                      .serialTX,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            _movementCircle(
                              anglePlus: 1,
                              intString: '+1',
                              currentangle: currentAngle,
                              serialTX:
                                  Provider.of<exoBluetoothControlFunctions>(
                                          context)
                                      .serialTX,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            _movementCircle(
                              anglePlus: 5,
                              intString: '+5',
                              currentangle: currentAngle,
                              serialTX:
                                  Provider.of<exoBluetoothControlFunctions>(
                                          context)
                                      .serialTX,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            _movementCircle(
                              anglePlus: 10,
                              intString: '+10',
                              currentangle: currentAngle,
                              serialTX:
                                  Provider.of<exoBluetoothControlFunctions>(
                                          context)
                                      .serialTX,
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
                      Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: GestureDetector(
                                onTap: () {
                                  if (flexionMode) {
                                    Provider.of<exoBluetoothControlFunctions>(
                                            context,
                                            listen: false)
                                        .setFlexLimit(serialTX!);
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
                                    Provider.of<exoBluetoothControlFunctions>(
                                            context,
                                            listen: false)
                                        .setExtLimit(serialTX!);
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
                                    margin:
                                        EdgeInsets.only(left: 20, bottom: 10),
                                    height: 40,
                                    width: 150,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                      color: Color(0xFFD9E5F0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        flexionMode
                                            ? 'Set Flex Limit'
                                            : 'Set Ext. Limit',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Color(0xFF004788),
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          if (serialTX != null)
                            _stopButton(
                              serialTX: serialTX,
                            ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Angle Control',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color(0xFF004788),
                            ),
                          ),
                          Container(
                            child: Switch.adaptive(
                                value: angleControlSwitch,
                                onChanged: (value) {
                                  if (serialTX != null) {
                                    Provider.of<exoBluetoothControlFunctions>(
                                            context,
                                            listen: false)
                                        .setAngleControlEnabled(
                                            value, serialTX!);
                                  }
                                }),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ROM Limits',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color(0xFF004788),
                            ),
                          ),
                          Container(
                            child: Switch.adaptive(
                                value: romLimitSwitch,
                                onChanged: (value) {
                                  if (serialTX != null) {
                                    Provider.of<exoBluetoothControlFunctions>(
                                            context,
                                            listen: false)
                                        .setROMLimitEnabled(value, serialTX!);
                                  }
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
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
                            Provider.of<exoBluetoothControlFunctions>(context,
                                    listen: false)
                                .setSpeed(value.toInt(), serialTX!);
                          },
                          min: 1,
                          max: 5,
                          divisions: 4,
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
          Container(
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
            child:
                SizedBox(height: 300, width: 300, child: hexoAnimationWidget()),
          ),
        ],
      ),
    );
  }
}

class _movementCircle extends StatefulWidget {
  int anglePlus;
  double currentangle;
  String intString;

  BluetoothCharacteristic? serialTX;

  _movementCircle(
      {super.key,
      required this.anglePlus,
      required this.intString,
      required this.currentangle,
      required this.serialTX});

  @override
  State<_movementCircle> createState() => _movementCircleState();
}

class _movementCircleState extends State<_movementCircle> {
  bool buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          buttonPressed = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          buttonPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          buttonPressed = false;
        });
      },
      onTap: () {
        if (widget.anglePlus.isNegative == false && widget.serialTX != null) {
          print('flexion');
          Provider.of<exoBluetoothControlFunctions>(context, listen: false)
              .flexByAngle(widget.anglePlus.toDouble(), widget.serialTX!);
        } else if (widget.anglePlus.isNegative &&
            widget.serialTX != null) {
          print('extension');
          Provider.of<exoBluetoothControlFunctions>(context, listen: false)
              .entendByAngle(-widget.anglePlus.toDouble(), widget.serialTX!);
        }
      },
      child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: buttonPressed
                ? Color.fromARGB(255, 0, 70, 136)
                : Color.fromARGB(255, 245, 245, 245),
            border: Border.all(
              color: Color.fromARGB(133, 0, 70, 136),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(widget.intString,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: buttonPressed
                        ? Color.fromARGB(255, 255, 255, 255)
                        : Color.fromARGB(255, 0, 70, 136))),
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
    final curAngle = Provider.of<exoDeviceFunctions>(context);
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
                '$curAngle.curFlexAngle°',
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
            angle: ((curAngle.curFlexAngle - 5) * pi) / 180 - 40,
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

class _stopButton extends StatelessWidget {
  BluetoothCharacteristic serialTX;
  _stopButton({
    Key? key,
    required this.serialTX,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        Provider.of<exoBluetoothControlFunctions>(context, listen: false)
            .EmergencyStop(serialTX);
      },
      child: Container(
          height: 40,
          width: 150,
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: Color.fromARGB(255, 224, 83, 83),
          ),
          child: Center(
            child: Text(
              'Stop',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          )),
    );
  }
}

class _testRomButton extends StatelessWidget {
  const _testRomButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 150,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: Color.fromARGB(255, 0, 70, 136)),
        child: Center(
          child: Text(
            'Range of Motion',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ));
  }
}
