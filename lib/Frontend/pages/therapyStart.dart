import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';
import 'package:flutter_application_1/Frontend/color_theme/theme.dart';
import 'package:flutter_application_1/Frontend/pages/bottomNavBar.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class therapyStart extends StatefulWidget {
  int reps;
  int holdTime;
  therapyStart({super.key, required this.reps, required this.holdTime});

  @override
  State<therapyStart> createState() => _therapyStartState();
}

class _therapyStartState extends State<therapyStart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double currentangle = Provider.of<exoDeviceFunctions>(context).curFlexAngle;
    double flexLimit = Provider.of<exoDeviceFunctions>(context).flexLimit;
    double extLimit = Provider.of<exoDeviceFunctions>(context).extLimit;
    return Scaffold(
      bottomNavigationBar: bottomNavBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: therapyStart_ColorConstrants.primaryBackground,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Therapy Mode (CPM)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: therapyStart_ColorConstrants.appBarTitle,
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rep 0',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: therapyStart_ColorConstrants.appBarTitle,
                    ),
                  ),
                  Text(
                    'Rep ${widget.reps}',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: therapyStart_ColorConstrants.appBarTitle,
                    ),
                  ),
                ],
              ),
              LinearProgressIndicator(
                borderRadius: BorderRadius.circular(5),
                minHeight: 11,
                value: 0.5,
                backgroundColor: therapyStart_ColorConstrants.linearProgressBackground,
                valueColor: AlwaysStoppedAnimation<Color>(therapyStart_ColorConstrants.linearProgressValue),
              ),
              SizedBox(
                height: 140,
              ),
              Expanded(
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/person_nohand.png',
                    ),
                    Positioned(
                      top: 100,
                      left: 100,
                      child: Transform.rotate(
                        angle: ((currentangle - 15) * pi) / 180 - 40,
                        origin: Offset(-20, -12),
                        child: Image.asset(
                          'assets/images/hand.png',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0),
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: _ArmRangeGauge(
                            currentAngle: currentangle,
                            minRange: flexLimit,
                            maxRange: extLimit),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: therapyStart_ColorConstrants.buttonBackground.withOpacity(0.6),
                        ),
                        child: Center(
                          child: Text(
                            'PAIN',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              color: therapyStart_ColorConstrants.text1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<exoBluetoothControlFunctions>(context,
                                listen: false)
                            .stop(Provider.of<exoBluetoothControlFunctions>(
                                    context,
                                    listen: false)
                                .serialTX!);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: therapyStart_ColorConstrants.stopButtonBackground,
                        ),
                        child: Center(
                          child: Text(
                            'STOP',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              color: therapyStart_ColorConstrants.text1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
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
            color: therapyStart_ColorConstrants.buttonBackground,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: <GaugePointer>[
            MarkerPointer(
              value: maxRange != null ? maxRange! : currentAngle,
              markerType: MarkerType.circle,
              color: therapyStart_ColorConstrants.buttonBackground,
              markerHeight: 15,
              markerWidth: 15,
              markerOffset: 0,
            ),
            MarkerPointer(
              value: minRange != null ? minRange! : currentAngle,
              markerType: MarkerType.circle,
              color: therapyStart_ColorConstrants.buttonBackground,
              markerHeight: 15,
              markerWidth: 15,
              markerOffset: 0,
            ),
          ],
        ),
      ],
    );
  }
}


Future<void> startReps(BuildContext context, int numberOfReps) async {
  for (int i = 0; i < numberOfReps; i++) {
    double currentAngle =
        Provider.of<exoDeviceFunctions>(context, listen: false).curFlexAngle;
    double flexLimit =
        Provider.of<exoDeviceFunctions>(context, listen: false).flexLimit;
    double extLimit =
        Provider.of<exoDeviceFunctions>(context, listen: false).extLimit;

    if (currentAngle > flexLimit) {
      await Provider.of<exoDeviceFunctions>(context, listen: false)
          .test_flex(false);
    } else if (currentAngle < extLimit) {
      await Provider.of<exoDeviceFunctions>(context, listen: false)
          .test_extend(false);
    }
  }
}
