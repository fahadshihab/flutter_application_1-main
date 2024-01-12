import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Frontend/doctor/Doctor_home.dart';
import 'package:flutter_application_1/Frontend/doctor/manual%20mode/manual_Mode.dart';
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
  double? flexlimit;
  double? extlimit;

  @override
  Widget build(BuildContext context) {
    double curFlexAngle = Provider.of<exoDeviceFunctions>(context).curFlexAngle;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // leading: Image.network(
        //   'https://firebasestorage.googleapis.com/v0/b/creair-exo.appspot.com/o/creaid%20logo%20png%203.png?alt=media&token=d1b95c2f-2535-4576-a8d1-78bea5b90e5d',
        //   height: 20,
        //   fit: BoxFit.fitHeight,
        // ),
        title: Text('Device Setup',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 128, 102, 255),
                fontSize: 25)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color.fromARGB(255, 228, 229, 229),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                    height: 230,
                    child: _ArmRangeGauge(
                      currentAngle: curFlexAngle,
                      minRange: flexlimit,
                      maxRange: extlimit,
                    )),
                SizedBox(
                  height: 20,
                ),
                Text(
                  extlimit == null ? 'FIX MAX EXTENSION' : 'FIX MAX FLEXION',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff004788)),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'use the controls below to Extend the device to the maximum extension and press the button below',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTapDown: (details) {
                          startFlexing();
                        },
                        onTapUp: (details) {
                          stopFlexing();
                        },
                        onTapCancel: () {
                          stopFlexing();
                        },
                        child: _Flex_BUTTON()),
                    GestureDetector(
                        onTapDown: (details) {
                          startextending();
                        },
                        onTapUp: (details) {
                          stopextending();
                        },
                        onTapCancel: () {
                          stopextending();
                        },
                        child: _Extend_BUTTON()),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                if (extlimit == null) {
                  setState(() {
                    extlimit = curFlexAngle;
                  });
                } else {
                  setState(() {
                    flexlimit = curFlexAngle;
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          title: Text('Setup Complete',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff004788))),
                          content: Text(
                              'Flexion Limit: $flexlimit\n'
                              'Extension Limit: $extlimit',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0))),
                          actions: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 128, 102, 255),
                                ),
                                onPressed: () {
                                  Provider.of<exoDeviceFunctions>(context,
                                          listen: false)
                                      .setFlexLimit(flexlimit!);
                                  Provider.of<exoDeviceFunctions>(context,
                                          listen: false)
                                      .setExtLimit(extlimit!);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              calibrationPage()));

                                  // Navigator.push(context,
                                  //     MaterialPageRoute(builder: (context) {
                                  //   return calibrationPage();
                                  // }));
                                  // Navigator.pushAndRemoveUntil(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             calibrationPage()),
                                  //     (route) => false);
                                },
                                child: Text('Ok',
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 255, 255, 255)))),
                            //reset button
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 128, 102, 255),
                                ),
                                onPressed: () {
                                  setState(() {
                                    extlimit = null;
                                    flexlimit = null;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text('Reset',
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 255, 255, 255)))),
                          ],
                        );
                      });
                }
              },
              child: Container(
                height: 70,
                width: 290,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 131, 119, 247),
                  borderRadius: BorderRadius.circular(10),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.2),
                  //     spreadRadius: 0,
                  //     blurRadius: 20,
                  //   ),
                  // ],
                ),
                child: Center(
                  child: Text(
                    extlimit == null ? 'SET MAX EXTENSION' : 'SET MAX FLEXION',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 70,
              width: 290,
              decoration: BoxDecoration(
                color: Colors.red[400],
                borderRadius: BorderRadius.circular(10),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.2),
                //     spreadRadius: 0,
                //     blurRadius: 20,
                //   ),
                // ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'EMERGENCY STOP',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  Text(
                    'Cuts off power to the device',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  startFlexing() {
    if (isFlexing == false) {
      flextimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        Provider.of<exoDeviceFunctions>(context, listen: false).test_flex();
      });
      setState(() {
        isFlexing = true;
      });
    }
  }

  stopFlexing() {
    if (isFlexing == true) {
      flextimer!.cancel();
      setState(() {
        isFlexing = false;
      });
    }
  }

  startextending() {
    if (isExtending == false) {
      flextimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        Provider.of<exoDeviceFunctions>(context, listen: false).test_extend();
      });
      setState(() {
        isExtending = true;
      });
    }
  }

  stopextending() {
    if (isExtending == true) {
      flextimer!.cancel();
      setState(() {
        isExtending = false;
      });
    }
  }
}

class _Extend_BUTTON extends StatelessWidget {
  const _Extend_BUTTON({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 120,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 131, 119, 247),
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.2),
        //     spreadRadius: 0,
        //     blurRadius: 20,
        //   ),
        // ],
      ),
      child: Center(
        child: Text(
          'Extend',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: const Color.fromARGB(255, 255, 255, 255),
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
      width: 120,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 131, 119, 247),
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.2),
        //     spreadRadius: 0,
        //     blurRadius: 20,
        //   ),
        // ],
      ),
      child: Center(
        child: Text(
          'Flex',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
    );
  }
}

class _ArmRangeGauge extends StatelessWidget {
  final double currentAngle; // Pass the current arm angle dynamically
  final double? minRange; // Minimum range of motion
  final double? maxRange; // Maximum range of motion

  _ArmRangeGauge({
    required this.currentAngle,
    required this.minRange,
    required this.maxRange,
  });

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 180,
          showLabels: false,
          showTicks: false,
          startAngle: -90,
          endAngle: 90,
          radiusFactor: 0.8,
          axisLineStyle: AxisLineStyle(
            thickness: 0.0,
            cornerStyle: CornerStyle.bothCurve,
            color: Color.fromARGB(255, 131, 119, 247),
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: <GaugePointer>[
            MarkerPointer(
              value: maxRange != null ? maxRange! : currentAngle,
              markerType: MarkerType.circle,
              color: Color.fromARGB(255, 131, 119, 247),
              markerHeight: 15,
              markerWidth: 15,
              markerOffset: 0,
            ),
            MarkerPointer(
              value: minRange != null ? minRange! : currentAngle,
              markerType: MarkerType.circle,
              color: Color.fromARGB(255, 131, 119, 247),
              markerHeight: 15,
              markerWidth: 15,
              markerOffset: 0,
            ),
            // NeedlePointer(
            //   value: maxRange != null ? maxRange! : currentAngle,
            //   needleLength: 1,
            //   needleColor: Color.fromARGB(255, 131, 119, 247),
            //   needleStartWidth: 1,
            //   needleEndWidth: 5,
            //   knobStyle: KnobStyle(
            //     knobRadius: 0.04,
            //     sizeUnit: GaugeSizeUnit.factor,
            //     color: Color.fromARGB(255, 131, 119, 247),
            //   ),
            // ),
            // NeedlePointer(
            //   value: minRange != null ? minRange! : currentAngle,
            //   needleLength: 1,
            //   needleColor: Color.fromARGB(255, 131, 119, 247),
            //   needleStartWidth: 1,
            //   needleEndWidth: 5,
            //   knobStyle: KnobStyle(
            //     knobRadius: 0.04,
            //     sizeUnit: GaugeSizeUnit.factor,
            //     color: Color.fromARGB(255, 131, 119, 247),
            //   ),
            // ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Container(
                child: Text(
                  '$currentAngle',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              angle: 0,
              positionFactor: 0,
            )
          ],
        ),
      ],
    );
  }
}
