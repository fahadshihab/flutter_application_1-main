import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';
import 'package:flutter_application_1/Frontend/color_theme/theme.dart';
import 'package:flutter_application_1/Frontend/pages/bottomNavBar.dart';
import 'package:flutter_application_1/Frontend/pages/therapyStart.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class therapyMode extends StatefulWidget {
  final ValueChanged<int>? onSecondsChanged;
  final int initialSeconds;
  const therapyMode({  Key? key,
    this.onSecondsChanged,
    this.initialSeconds = 0,
  }) : super(key: key);


  @override
  State<therapyMode> createState() => therapyModeState();
}

class therapyModeState extends State<therapyMode> {
  int holdtime = 0;
  late int _seconds;
  int reps = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seconds = widget.initialSeconds;
  }

  @override
  Widget build(BuildContext context) {
    BluetoothCharacteristic? serialTX =
        Provider.of<exoBluetoothControlFunctions>(context).serialTX;
    int flexionLimit =
        Provider.of<exoDeviceFunctions>(context).flexLimit.toInt();
    int extensionLimit =
        Provider.of<exoDeviceFunctions>(context).extLimit.toInt();
    int speed = Provider.of<exoDeviceFunctions>(context).speed_setting;

    return Scaffold(
        bottomNavigationBar: bottomNavBar(),
        extendBodyBehindAppBar: true,
        backgroundColor: therapymode_ColorConstrants.backgroundColor,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
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
            child: ListView(children: [
          SizedBox(
            height: 50,
          ),
          Container(
          
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            padding: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: therapymode_ColorConstrants.containerBackground
                      .withOpacity(0.16),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                  spreadRadius: 0,
                ),
              ],
              borderRadius: BorderRadius.circular(30),
              color: therapymode_ColorConstrants.backgroundColor,
            ),
            child: Column(
              children: [
                Center(
                  
                  child: Text(
                    'Flexion Limit : ${flexionLimit}°\n Extension Limit : ${extensionLimit}°\n Speed set to : $speed\n',
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                  child: Text(
                    'Re-Calibrate',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: therapymode_ColorConstrants.text1,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
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
              ],
            ),
          ),
         
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: therapymode_ColorConstrants.containerBackground
                      .withOpacity(0.16),
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
                      color: therapymode_ColorConstrants.container3Color),
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
                          Icons.add_circle_outline_outlined,
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
                          Icons.remove_circle_outline_sharp,
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
                      color: therapymode_ColorConstrants.container3Color),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Hold Time',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: therapymode_ColorConstrants.iconColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Set your hold time after each Flex-Ext cycle.',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: therapymode_ColorConstrants.textColor,
                    )),
                SizedBox(
                  height: 10,
                ),
                
                GestureDetector(
                  onTap: (() {
                      showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SecondsPickerDialog(
                          onSecondsChanged: (seconds) {
                            setState(() {
                              holdtime = seconds;
                            });
                          },
                          initialSeconds: holdtime,
                        );
  
                      },
                    );
                  }),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: therapymode_ColorConstrants.boxShadow,
                            offset: Offset(0, 2),
                            blurRadius: 2,
                            spreadRadius: 0,
                          ),
                        ],
                        color: therapymode_ColorConstrants.backgroundColor),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '$holdtime s',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: therapymode_ColorConstrants.iconColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //button4
                //       Container(
                //         width: 100,
                //         padding: EdgeInsets.symmetric(horizontal: 10),
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(10),
                //           color: therapymode_ColorConstrants.container2Color,
                //           boxShadow:  [
                //             BoxShadow(
                //               color: therapymode_ColorConstrants.boxShadow,
                //               offset: Offset(0, 2),
                //               blurRadius: 2,
                //               spreadRadius: 0,
                //             ),
                //           ],
                //         ),
                //         child: TextField(
                //          decoration: InputDecoration(
                //           labelText: 'Sec',

                //       labelStyle: TextStyle(
                //             fontSize: 17,

                //           ),
                //           suffixStyle: TextStyle(
                //             fontSize: 20,

                //           ),

                //           border: InputBorder.none),
                //           showCursor: true,
                //           textAlign: TextAlign.center,
                //           keyboardType:  TextInputType.number,

                //           onChanged: (value) {
                //             setState(() {
                //               holdTime = int.parse(value);
                //             });
                //           },
                //         ),),
                //       SizedBox(
                //         height: 40,
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 30,
                ),
                //button5
              
               
              ],
            ),
          ),
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
                          holdTime: holdtime,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: therapymode_ColorConstrants.containerBackground
                              .withOpacity(0.16),
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
                        'Start Session',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: therapymode_ColorConstrants.text1,
                        ),
                      ),
                    ),
                  ),
                ),
        ])));
  }
}

datetimeToSeconds(DateTime time) {
  return time.hour * 60 + time.minute;
}

class SecondsPickerDialog extends StatefulWidget {
  final ValueChanged<int>? onSecondsChanged;
  final int initialSeconds;

  SecondsPickerDialog({
    Key? key,
    this.onSecondsChanged,
    this.initialSeconds = 0,
  }) : super(key: key);

  @override
  _SecondsPickerDialogState createState() => _SecondsPickerDialogState();
}

class _SecondsPickerDialogState extends State<SecondsPickerDialog> {
  late int _seconds;

  @override
  void initState() {
    super.initState();
    _seconds = widget.initialSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select Seconds", textAlign: TextAlign.center, style: TextStyle(color: maincolors.color1)   ),
      
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Seconds: $_seconds",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Slider(
            activeColor: maincolors.color1,
            inactiveColor: maincolors.color1.withOpacity(0.2),
            value: _seconds.toDouble(),
            min: 0,
            max: 59,
            divisions: 59,
            onChanged: (value) {
              setState(() {
                _seconds = value.toInt();
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel', style: TextStyle(color: maincolors.color1) ),
        ),
        TextButton(
          onPressed: () {
            if (widget.onSecondsChanged != null) {
              widget.onSecondsChanged!(_seconds);

          
            }
            Navigator.of(context).pop();
          },
          child: Text('OK', style: TextStyle(color: maincolors.color1) ),
        ),
      ],
    );
  }
}
