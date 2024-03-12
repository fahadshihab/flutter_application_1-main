import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';
import 'package:flutter_application_1/Frontend/pages/bottomNavBar.dart';
import 'package:flutter_application_1/Frontend/pages/manual_Mode.dart';
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
      bottomNavigationBar: const bottomNavBar(),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 120,
        centerTitle: false,
        title: const Text(
          'Device Calibration',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color.fromARGB(255, 90, 90, 90),
          ),
        ),
        backgroundColor: Color.fromARGB(57, 0, 70, 136),
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
          preferredSize: const Size.fromHeight(0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Image.asset(flexionMode
                      ? 'assets/app V2/calibration page/Calibration tab Flexion selected.png'
                      : 'assets/app V2/calibration page/Calibration tab extention selected.png'),
                ),
                Row(
                  children: [
                    GestureDetector(
                      //Button #1
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          flexionMode = true;
                        });
                      },
                      child: SizedBox(
                        height: 44,
                        width: MediaQuery.of(context).size.width / 2,
                      ),
                    ),
                    GestureDetector(
                      //Button #2
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          flexionMode = false;
                        });
                      },
                      child: SizedBox(
                        height: 44,
                        width: MediaQuery.of(context).size.width / 2,
                      ),
                    ),
                  ],
                ),
              ]),
            ],
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(height: 300, width: 300, child: hexoAnimationWidget()),
          const SizedBox(
            height: 20,
          ),
          Text(
            flexionMode
                ? 'Set the flexion limit to your free range of motion'
                : 'Set the extension limit to your free range of motion',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 90, 90, 90),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text('Angle Control',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF004788),
                )),
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
                  serialTX: Provider.of<exoBluetoothControlFunctions>(context)
                      .serialTX,
                ),
                const SizedBox(
                  width: 10,
                ),
                _movementCircle(
                  anglePlus: -5,
                  intString: '-5',
                  currentangle: currentAngle,
                  serialTX: Provider.of<exoBluetoothControlFunctions>(context)
                      .serialTX,
                ),
                const SizedBox(
                  width: 10,
                ),
                _movementCircle(
                  anglePlus: -1,
                  intString: '-1',
                  currentangle: currentAngle,
                  serialTX: Provider.of<exoBluetoothControlFunctions>(context)
                      .serialTX,
                ),
                const SizedBox(
                  width: 10,
                ),
                _movementCircle(
                  anglePlus: 1,
                  intString: '+1',
                  currentangle: currentAngle,
                  serialTX: Provider.of<exoBluetoothControlFunctions>(context)
                      .serialTX,
                ),
                const SizedBox(
                  width: 10,
                ),
                _movementCircle(
                  anglePlus: 5,
                  intString: '+5',
                  currentangle: currentAngle,
                  serialTX: Provider.of<exoBluetoothControlFunctions>(context)
                      .serialTX,
                ),
                const SizedBox(
                  width: 10,
                ),
                _movementCircle(
                  anglePlus: 10,
                  intString: '+10',
                  currentangle: currentAngle,
                  serialTX: Provider.of<exoBluetoothControlFunctions>(context)
                      .serialTX,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
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
                    activeColor: Color.fromARGB(255, 81, 133, 182),
                    inactiveColor: Color.fromARGB(51, 0, 70, 136),
                    value: speed.toDouble(),
                    onChanged: (double value) {
                      //#5
                      Provider.of<exoDeviceFunctions>(context, listen: false)
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
          const SizedBox(
            height: 15,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: const Color.fromRGBO(242, 242, 242, 0.4000000059604645),
              border: Border.all(
                color: const Color.fromRGBO(215, 215, 215, 1),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              flexionMode
                  ? 'Set Flexion limit to: ${currentAngle.toInt()}'
                  : 'Set Extension limit to: ${currentAngle.toInt()}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color.fromRGBO(112, 112, 112, 1),
                  fontFamily: 'Roboto',
                  fontSize: 17,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            //Button #3
            onTap: () {
              if (flexionMode) {
                Provider.of<exoBluetoothControlFunctions>(context,
                        listen: false)
                    .setFlexLimit(serialTX!);
                SnackBar snackBar = SnackBar(
                  backgroundColor: const Color(0xFF004788),
                  content: Text(
                    'Flexion limit set to $currentAngle',
                    style: const TextStyle(color: Colors.white),
                  ),
                  duration: const Duration(seconds: 1),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                Provider.of<exoBluetoothControlFunctions>(context,
                        listen: false)
                    .setExtLimit(serialTX!);
                SnackBar snackBar = SnackBar(
                  backgroundColor: const Color(0xFF004788),
                  content: Text(
                    'Extension limit set to $currentAngle',
                    style: const TextStyle(color: Colors.white),
                  ),
                  duration: const Duration(seconds: 1),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: Container(
                width: 200,
                margin: const EdgeInsets.symmetric(horizontal: 100),
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Color(0xFF004788),
                ),
                child: Center(
                  child: Text(
                    flexionMode ? 'Reset Flex Limit' : 'Reset Ext. Limit',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                )),
          ),
          const SizedBox(
            height: 20,
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
      //Button #4
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
        } else if (widget.anglePlus.isNegative && widget.serialTX != null) {
          print('extension');
          Provider.of<exoBluetoothControlFunctions>(context, listen: false)
              .entendByAngle(-widget.anglePlus.toDouble(), widget.serialTX!);
        }
      },
      child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(0)),
            color: buttonPressed
                ? const Color.fromARGB(255, 0, 70, 136)
                : const Color.fromARGB(255, 245, 245, 245),
            border: Border.all(
              color: const Color(0xFFBABABA),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(17, 75, 75, 75),
                spreadRadius: 0,
                blurRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Text('${widget.intString}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: buttonPressed
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(255, 0, 70, 136))),
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
              backgroundColor: const Color.fromARGB(255, 231, 10, 10),
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
                color: const Color.fromARGB(255, 245, 245, 245),
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
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: Color.fromARGB(255, 224, 83, 83),
          ),
          child: const Center(
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
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: Color.fromARGB(255, 0, 70, 136)),
        child: const Center(
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
