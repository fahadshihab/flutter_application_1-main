import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';
import 'package:flutter_application_1/Frontend/color_theme/theme.dart';
import 'package:flutter_application_1/Frontend/pages/bottomNavBar.dart';
import 'package:flutter_application_1/Frontend/pages/therapyStart.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
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
    BluetoothCharacteristic? serialTX =
        Provider.of<exoBluetoothControlFunctions>(context).serialTX;
    double flexionLimit = Provider.of<exoDeviceFunctions>(context).flexLimit;
    double extensionLimit = Provider.of<exoDeviceFunctions>(context).extLimit;
    int speed = Provider.of<exoDeviceFunctions>(context).speed_setting;

    return Scaffold(
      bottomNavigationBar: bottomNavBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: therapymode_ColorConstrants.backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Therapy Mode',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: therapymode_ColorConstrants.appBarTextColor,
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
        child: ListView(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Text(
                'Flexion Limit : $flexionLimit\n Extension Limit : $extensionLimit\n Speed set to : $speed\n',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: therapymode_ColorConstrants.appBarTextColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              //button1
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
                    color: therapymode_ColorConstrants.text1,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                   backgroundColor: Color(0xFF004788),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
                    color: therapymode_ColorConstrants.containerBackground.withOpacity(0.16),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                    spreadRadius: 0,
                  ),
                ],
                borderRadius: BorderRadius.circular(30),
                color: therapymode_ColorConstrants.containerColor,
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
                      color: therapymode_ColorConstrants.container3Color
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'reptition count',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: therapymode_ColorConstrants.iconColor,
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
                        //button2
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              reps++;
                            });
                          },
                          child: Icon(
                            Icons.add_circle_rounded,
                            color: therapymode_ColorConstrants.iconColor,
                            size: 50,
                          ),
                        ),
                        Text('$reps',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: therapymode_ColorConstrants.textColor,
                            )),
                            //button3
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              reps--;
                            });
                          },
                          child: Icon(
                            Icons.remove_circle_sharp,
                            size: 50,
                            color: therapymode_ColorConstrants.iconColor,
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
                      color: therapymode_ColorConstrants.container3Color
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'Hold Time',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: therapymode_ColorConstrants.iconColor,
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
                        color: therapymode_ColorConstrants.textColor,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  //button4
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
                                    color: therapymode_ColorConstrants.textColor,
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
                                    color: therapymode_ColorConstrants.textColor,
                                  ),
                                  highlightedTextStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: therapymode_ColorConstrants.textColor,
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
                                          color: therapymode_ColorConstrants.containerBackground.withOpacity(0.16),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(30),
                                      color: therapymode_ColorConstrants.buttonColor,
                                    ),
                                    child: Text(
                                      'Set',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        color: therapymode_ColorConstrants.text1
                                        
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: therapymode_ColorConstrants.boxShadow,
                            offset: Offset(0, 3),
                            blurRadius: 2,
                            spreadRadius: 0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                        color: therapymode_ColorConstrants.container2Color,
                      ),
                      child: Text(
                        "${holdTime.hour.toString()}" ' min ' +
                            "${holdTime.minute.toString()} sec",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: therapymode_ColorConstrants.textColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            //button5
            GestureDetector(
              onTap: () {
                Provider.of<exoBluetoothControlFunctions>(context,
                        listen: false)
                    .CPM(reps, serialTX!);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => therapyStart(
                      reps: reps,
                      holdTime: datetimeToSeconds(holdTime),
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: therapymode_ColorConstrants.containerBackground.withOpacity(0.16),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                      spreadRadius: 0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(30),
                  color: therapymode_ColorConstrants.buttonColor,
                ),
                child: Center(
                  child: Text(
                    'Start',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: therapymode_ColorConstrants.text1,
                    ),
                  ),
                ),
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
