import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:google_fonts/google_fonts.dart';

class calibrationPage extends StatefulWidget {
  const calibrationPage({super.key});

  @override
  State<calibrationPage> createState() => _calibrationPageState();
}

class _calibrationPageState extends State<calibrationPage> {
  bool isFlexing = false;
  bool isExtending = false;
  Timer? flextimer;
  @override
  Widget build(BuildContext context) {
    double currentAngle = Provider.of<exoDeviceFunctions>(context)
        .curFlexAngle; // double currentAngle = 90.0;
    double startLimit = Provider.of<exoDeviceFunctions>(context)
        .flexLimit; // double flexLimit = 120.0;
    double endLimit = Provider.of<exoDeviceFunctions>(context)
        .extLimit; // double extLimit = 0.0;
    int speed = Provider.of<exoDeviceFunctions>(context).speed_setting;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.grey.shade800,
        Colors.grey.shade900,
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: ListView(
              children: [
                SizedBox(
                  height: 18,
                ),
                // Text(
                //   "Creaid Exo",
                //   style: GoogleFonts.bungeeSpice(
                //       textStyle: TextStyle(
                //           color: Colors.white,
                //           fontSize: 30,
                //           fontWeight: FontWeight.bold)),
                // ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(93, 0, 0, 0),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Movement Limits',
                            style: GoogleFonts.abel(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'RECALIBRATE',
                              style: GoogleFonts.abel(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(93, 151, 151, 151),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Flexion  :  $startLimit',
                              style: GoogleFonts.abel(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(93, 151, 151, 151),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Extention  :  $endLimit',
                              style: GoogleFonts.abel(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

                SizedBox(
                    height: 340,
                    child: Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: MyRadialGauge(
                            startLimit: startLimit,
                            endLimit: endLimit,
                            currentAngle: currentAngle))),
                SizedBox(
                  height: 35,
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(93, 0, 0, 0),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Speed',
                        style: GoogleFonts.abel(
                            textStyle: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(93, 151, 151, 151),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Speed  :  $speed',
                              style: GoogleFonts.abel(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (speed <= 4) {
                                Provider.of<exoDeviceFunctions>(context,
                                        listen: false)
                                    .setSpeed(speed + 1);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(235, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                Icons.add,
                                color: Color.fromARGB(255, 42, 42, 42),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (speed >= 2) {
                                Provider.of<exoDeviceFunctions>(context,
                                        listen: false)
                                    .setSpeed(speed - 1);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(235, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                Icons.remove,
                                color: Color.fromARGB(255, 42, 42, 42),
                              ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.red,
                              Colors.red,
                            ]),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: Text(
                          "STOP",
                          style: GoogleFonts.abel(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                        )),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 200,
                            child: Row(
                              children: [
                                Container(
                                  height: 70,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 75, 75, 75),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10))),
                                  child: Icon(
                                    Icons.arrow_upward,
                                    color: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTapDown: (details) {
                                      startFlexing();
                                    },
                                    onTapUp: (details) {
                                      stopFlexing();
                                    },
                                    onTapCancel: () {
                                      stopFlexing();
                                    },
                                    child: Container(
                                      height: 70,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 8),
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 240, 240, 240),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      child: Center(
                                        child: Text(
                                          "Flex",
                                          style: GoogleFonts.abel(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  letterSpacing: 1,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 200,
                            child: Row(
                              children: [
                                Container(
                                  height: 70,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 75, 75, 75),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10))),
                                  child: Icon(
                                    Icons.arrow_downward,
                                    color: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTapDown: (details) {
                                      startextending();
                                    },
                                    onTapUp: (details) {
                                      stopextending();
                                    },
                                    onTapCancel: () {
                                      stopextending();
                                    },
                                    child: Container(
                                      height: 70,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 8),
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 240, 240, 240),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      child: Center(
                                        child: Text(
                                          "EXTEND",
                                          style: GoogleFonts.abel(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  letterSpacing: 1,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
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

class MyRadialGauge extends StatelessWidget {
  double startLimit;
  double endLimit;
  double currentAngle;
  MyRadialGauge(
      {this.startLimit = 0, this.endLimit = 180, required this.currentAngle});
  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      backgroundColor: Colors.transparent,
      animationDuration: 1000,
      axes: <RadialAxis>[
        RadialAxis(
          labelOffset: 20,
          showAxisLine: true,
          axisLineStyle: AxisLineStyle(
              thickness: 0.08,
              thicknessUnit: GaugeSizeUnit.factor,
              color: Color.fromARGB(176, 121, 121, 121)),
          showLabels: true,
          maximumLabels: 4,
          minorTicksPerInterval: 5,
          majorTickStyle: MajorTickStyle(
              length: 0.09,
              lengthUnit: GaugeSizeUnit.factor,
              thickness: 2,
              color: Color.fromARGB(255, 253, 253, 253)),
          minorTickStyle: MinorTickStyle(
              length: 0.04,
              lengthUnit: GaugeSizeUnit.factor,
              thickness: 1.3,
              color: Color.fromARGB(255, 255, 255, 255)),
          minimum: -20,
          maximum: 200,
          startAngle: -110,
          endAngle: 110,
          axisLabelStyle: GaugeTextStyle(
              color: Color.fromARGB(255, 109, 109, 109),
              fontWeight: FontWeight.bold,
              fontSize: 10),
          pointers: <GaugePointer>[
            NeedlePointer(
              value: currentAngle,
              enableAnimation: true,
              needleLength: 0.5,
              needleColor: Color.fromARGB(255, 164, 164, 164),
              needleStartWidth: 0.5,
              needleEndWidth: 3,
              knobStyle: KnobStyle(
                knobRadius: 0.04,
                sizeUnit: GaugeSizeUnit.factor,
                borderColor: Colors.white,
                borderWidth: 0.05,
                color: Colors.white,
              ),
            ),
            NeedlePointer(
              value: 0,
              enableAnimation: true,
              needleLength: 0.5,
              needleColor: Color.fromARGB(255, 164, 164, 164),
              needleStartWidth: 5,
              needleEndWidth: 3,
              knobStyle: KnobStyle(
                knobRadius: 0.04,
                sizeUnit: GaugeSizeUnit.factor,
                borderColor: Colors.white,
                borderWidth: 0.05,
                color: Colors.white,
              ),
            ),
            MarkerPointer(
              value: startLimit,
              enableAnimation: true,
              color: Colors.green,
              markerWidth: 12,
              markerHeight: 12,
              offsetUnit: GaugeSizeUnit.factor,
              markerOffset: -0.04,
            ),
            MarkerPointer(
              value: currentAngle,
              enableAnimation: true,
              color: Colors.white,
              markerWidth: 12,
              markerHeight: 12,
              offsetUnit: GaugeSizeUnit.factor,
              markerOffset: -0.04,
            ),
            MarkerPointer(
              value: endLimit,
              enableAnimation: true,
              color: Colors.green,
              markerWidth: 12,
              markerHeight: 12,
              offsetUnit: GaugeSizeUnit.factor,
              markerOffset: -0.04,
            ),
          ],
        ),
      ],
    );
  }
}
