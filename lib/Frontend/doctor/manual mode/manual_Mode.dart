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
    return Scaffold(
      backgroundColor: Color(0xffF0F0F2),
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
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
          )
        ],
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

class _Extend_BUTTON extends StatelessWidget {
  const _Extend_BUTTON({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 300,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Extend',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.arrow_downward,
            color: Colors.white,
          ),
        ],
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
      width: 300,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.arrow_upward,
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Flex',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          )
        ],
      ),
    );
  }
}

class _ROM_display extends StatelessWidget {
  const _ROM_display({
    super.key,
    required this.startLimit,
    required this.endLimit,
  });

  final double startLimit;
  final double endLimit;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
    );
  }
}

class _speed_Control extends StatelessWidget {
  const _speed_Control({
    super.key,
    required this.speed,
  });

  final int speed;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    Provider.of<exoDeviceFunctions>(context, listen: false)
                        .setSpeed(speed + 1);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                    Provider.of<exoDeviceFunctions>(context, listen: false)
                        .setSpeed(speed - 1);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
    );
  }
}
