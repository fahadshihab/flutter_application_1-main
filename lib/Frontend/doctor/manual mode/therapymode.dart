import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';
import 'package:flutter_application_1/Frontend/doctor/manual%20mode/bottomNavBar.dart';
import 'package:flutter_application_1/Frontend/doctor/therapyStart.dart';
import 'package:provider/provider.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class therapyMode extends StatefulWidget {
  const therapyMode({super.key});

  @override
  State<therapyMode> createState() => _therapyModeState();
}

class _therapyModeState extends State<therapyMode> {
  DateTime holdTime = DateTime.parse('2021-07-20 00:00:00Z');
  int reps = 0;

  @override
  Widget build(BuildContext context) {
    double flexionLimit = Provider.of<exoDeviceFunctions>(context).flexLimit;
    double extensionLimit = Provider.of<exoDeviceFunctions>(context).extLimit;
    int speed = Provider.of<exoDeviceFunctions>(context).speed_setting;
    return Scaffold(
      bottomNavigationBar: bottomNavBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xffF0F0F2),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Therapy Mode',
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                'Flexion Limit : $flexionLimit\n Extension Limit : $extensionLimit\n Speed set to : $speed\n',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Color.fromARGB(255, 90, 90, 90),
                ),
              ),
            ),
            Container(
              height: 45,
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/deviceSetup', (route) => false);
                },
                child: Text(
                  'Re-Calibrate',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color.fromARGB(255, 81, 81, 81),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Color.fromARGB(255, 194, 208, 221),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.16),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                      spreadRadius: 0)
                ],
                borderRadius: BorderRadius.circular(30),
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 194, 208, 221),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'reptition count',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: Color(0xFF004788),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 110),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              reps++;
                            });
                          },
                          child: Icon(
                            Icons.add_circle_rounded,
                            color: Color(0xFF004788),
                            size: 50,
                          ),
                        ),
                        Text('$reps',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Color.fromARGB(255, 71, 71, 71),
                            )),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              reps--;
                            });
                          },
                          child: Icon(
                            Icons.remove_circle_sharp,
                            size: 50,
                            color: Color(0xFF004788),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 194, 208, 221),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'Hold Time',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: Color(0xFF004788),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Set your hold time after each Flex-Ext cycle.',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color.fromARGB(255, 110, 110, 110),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 300,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Set Hold Time',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: Color.fromARGB(255, 71, 71, 71),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TimePickerSpinner(
                                    minutesInterval: 1,
                                    secondsInterval: 1,
                                    normalTextStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: Color.fromARGB(255, 71, 71, 71),
                                    ),
                                    highlightedTextStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: Color.fromARGB(255, 71, 71, 71),
                                    ),
                                    spacing: 50,
                                    itemHeight: 50,
                                    isForce2Digits: true,
                                    onTimeChange: (time) {
                                      setState(() {
                                        holdTime = time;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 100, vertical: 15),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)
                                                      .withOpacity(0.16),
                                              offset: Offset(0, 3),
                                              blurRadius: 6,
                                              spreadRadius: 0)
                                        ],
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color(0xFF004788),
                                      ),
                                      child: Text('Set',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(76, 0, 0, 0),
                              offset: Offset(0, 3),
                              blurRadius: 2,
                              spreadRadius: 0)
                        ],
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 237, 237, 237),
                      ),
                      child: Text(
                          "${holdTime.hour.toString()}" ' min ' +
                              "${holdTime.minute.toString()} sec",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Color.fromARGB(255, 71, 71, 71),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => therapyStart(
                              reps: reps,
                              holdTime: datetimeToSeconds(holdTime),
                            )));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.16),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                        spreadRadius: 0)
                  ],
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFF004788),
                ),
                child: Text('Start',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: Color.fromARGB(255, 255, 255, 255),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

datetimeToSeconds(DateTime time) {
  return time.hour * 60 + time.minute;
}
