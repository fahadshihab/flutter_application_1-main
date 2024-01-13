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
    return Scaffold();
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
