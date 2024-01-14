import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';
import 'package:flutter_application_1/Frontend/doctor/manual%20mode/bottomNavBar.dart';
import 'package:provider/provider.dart';

class therapyStart extends StatefulWidget {
  int reps;
  int holdTime;
  therapyStart({super.key, required this.reps, required this.holdTime});

  @override
  State<therapyStart> createState() => _therapyStartState();
}

class _therapyStartState extends State<therapyStart> {
  @override
  Widget build(BuildContext context) {
    double currentangle = Provider.of<exoDeviceFunctions>(context).curFlexAngle;
    double flexLimit = Provider.of<exoDeviceFunctions>(context).flexLimit;
    double extLimit = Provider.of<exoDeviceFunctions>(context).extLimit;
    return Scaffold(
      bottomNavigationBar: bottomNavBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xffF0F0F2),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Therapy Mode (CPM)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rep 1',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Color.fromARGB(255, 90, 90, 90),
                    ),
                  ),
                  Text(
                    'Rep 10',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Color.fromARGB(255, 90, 90, 90),
                    ),
                  ),
                ],
              ),
              LinearProgressIndicator(
                borderRadius: BorderRadius.circular(5),
                minHeight: 11,
                value: 0.5,
                backgroundColor: Color(0xffD9E5F0),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff004788)),
              ),
              SizedBox(
                height: 140,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 100.0),
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
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xff003B73).withOpacity(0.6),
                      ),
                      child: Center(
                        child: Text(
                          'PAIN',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xffD20E0E),
                      ),
                      child: Center(
                        child: Text(
                          'STOP',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                            color: Colors.white,
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
