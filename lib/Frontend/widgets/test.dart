// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'dart:convert';
// import 'package:flutter_application_1/splashscreen.dart';
// import 'package:flutter_application_1/ConnectedDevicePage.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

// void main() {
//   runApp(DeviceControl());
// }

// class DeviceControl extends StatelessWidget {
//   const DeviceControl({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Device Control App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: SplashScreen(),
//       routes: {
//         '/connect': (context) => const ConnectDevicePage(),
//         '/devicecontrol': (context) => DeviceControl(),
//       },
//     );
//   }
// }

// class MyDeviceControlPage extends StatefulWidget {
//   const MyDeviceControlPage({
//     Key? key,
//     required this.connectedDevice,
//     required this.btService,
//     required this.serialRX,
//     required this.serialTX,
//   }) : super(key: key);

//   static const AsciiCodec ascii = AsciiCodec();

//   final BluetoothDevice connectedDevice;
//   final BluetoothService btService;
//   final BluetoothCharacteristic serialRX;
//   final BluetoothCharacteristic serialTX;

//   @override
//   _MyDeviceControlPageState createState() => _MyDeviceControlPageState();
// }

// class _MyDeviceControlPageState extends State<MyDeviceControlPage> {
//   late stt.SpeechToText _speech;
//   String _text = '';
//   bool _isListening = false;
//   int _countdown = 2;
//   int speed_setting = 80;
//   double flexionCounter = 0.0;
//   double extensionCounter = 0.0;
//   double curFlexAngle = 0.0;
//   double flexLimit = 120.0;
//   double extLimit = 0.0;

//   String speedSetting = "";

//   bool isROMLimitEnabled = false;
//   bool isAngleControlEnabled = false;

//   late StreamSubscription _receiverSubscription;

//   TextEditingController _speedTextController = TextEditingController();

//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//     _receiverSubscription = widget.serialRX.onValueReceived.listen((value) {
//       String rx_str = ascii.decode(value);
//       List<String> commands = rx_str.split(" ");
//       if(commands[0] == "A") {
//         setState(() {
//           curFlexAngle = double.parse(commands[1]);
//         });
//       }
//       else if(commands[0] == "P0") {
//         setState(() {
//           isAngleControlEnabled = int.parse(commands[1]) == 1 ? true : false;
//         });
//       }
//       else if(commands[0] == "P1") {
//         setState(() {
//           isROMLimitEnabled = int.parse(commands[1]) == 1 ? true : false;
//         });
//       }
//       else if(commands[0] == "P2") {
//         setState(() {
//           flexLimit = double.parse(commands[1]);
//         });
//       }
//       else if(commands[0] == "P3") {
//         setState(() {
//           extLimit = double.parse(commands[1]);
//         });
//       }
//     });
//     widget.connectedDevice.cancelWhenDisconnected(_receiverSubscription);
//     widget.serialRX.setNotifyValue(true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           'Device Control'
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               ElevatedButton(
//                 onPressed: () async {
//                   //widget.serialTX.write(MyDeviceControlPage.ascii.encode('Z 0'));
//                   await widget.serialTX.write(ascii.encode("Z 0"));
//                 },
//                 style: ElevatedButton.styleFrom(
//                   primary: Colors.black,
//                   onPrimary: Colors.white,
//                   padding: const EdgeInsets.all(8.0),
//                   textStyle: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                 ),
//                 child: Text('Calibrate'),
//               ),
//               const SizedBox(height: 8.0),
//               ElevatedButton(
//                 onPressed: () {
//                   widget.serialTX.write(MyDeviceControlPage.ascii.encode('S 0'));
//                 },
//                 style: ElevatedButton.styleFrom(
//                   primary: Colors.red,
//                   onPrimary: Colors.white,
//                   padding: const EdgeInsets.all(8.0),
//                   textStyle: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                 ),
//                 child: Text('Emergency Stop'),
//               ),

//               SizedBox(
//                 height: 30,
//               ),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Text(
//                     'ROM Limit',
//                   ),
//                   Switch(
//                     value: isROMLimitEnabled,
//                     onChanged: (value) {
//                       if (value == true) {
//                         widget.serialTX.write(ascii.encode('G 1'));
//                       }
//                       else {
//                         widget.serialTX.write(ascii.encode('G 0'));
//                       }
//                       setState(() {
//                         isROMLimitEnabled = value;
//                       });
//                     },
//                   ),Text(
//                     'Angle Control',
//                   ),
//                   Switch(
//                     value: isAngleControlEnabled,
//                     onChanged: (value) {
//                       if (value == true) {
//                         widget.serialTX.write(ascii.encode('G 3'));
//                       }
//                       else {
//                         widget.serialTX.write(ascii.encode('G 2'));
//                       }
//                       setState(() {
//                         isAngleControlEnabled = value;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Container(
//                 color: Color(0xFFF0E0E0),
//                 padding: EdgeInsets.all(10),
//                 child: Column(
//                   children: [
//                     Center(
//                       child: Text(
//                         'WARNING! Only for debug',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Color(0xFFFF0000),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10,),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ElevatedButton(
//                             onPressed: () {
//                               widget.serialTX.write(ascii.encode('G 5'));
//                             },
//                             child: Text(
//                                 'Reset Setpoint'
//                             )),
//                         ElevatedButton(
//                             onPressed: () {
//                               widget.serialTX.write(ascii.encode('G 4'));
//                             },
//                             child: Text(
//                                 'Unwind Integral'
//                             )),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(
//                 height: 30,
//               ),

//               Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     widget.serialTX.write(MyDeviceControlPage.ascii.encode('F ${speed_setting}'));
//                   },
//                   child: Text('Flex'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     widget.serialTX.write(MyDeviceControlPage.ascii.encode('E ${speed_setting}'));
//                   },
//                   child: Text('Extend'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     widget.serialTX.write(MyDeviceControlPage.ascii.encode('X 0'));
//                   },
//                   child: Text('Stop'),
//                 ),
//               ],
//             ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Text(
//                     'Speed',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   buildSpeedButton(50, '1'),
//                   buildSpeedButton(100, '2'),
//                   buildSpeedButton(150, '3'),
//                   buildSpeedButton(200, '4'),
//                   buildSpeedButton(250, '5'),
//                 ],
//               ),
//               const SizedBox(height: 15.0),
//               buildFlexionExtensionButtons(),
//               const SizedBox(height: 15.0),
//               buildTable(),
//               const SizedBox(height: 15.0),
//               buildSpeechButton(),
//               ElevatedButton(
//                 onPressed: () {
//                   widget.serialTX.write(MyDeviceControlPage.ascii.encode('S 0'));
//                 },
//                 style: ElevatedButton.styleFrom(
//                   primary: Colors.red,
//                   onPrimary: Colors.white,
//                   padding: const EdgeInsets.all(8.0),
//                   textStyle: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                 ),
//                 child: Text('Emergency Stop'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildFlexionExtensionButtons() {
//     return Column(
//       children: [
//         Text(
//           'Set Flexion',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 4.0),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             buildNumberButton('1°', () => setFlexion(1)),
//             buildNumberButton('2°', () => setFlexion(2)),
//             buildNumberButton('5°', () => setFlexion(5)),
//             buildNumberButton('10°', () => setFlexion(10)),
//           ],
//         ),
//         const SizedBox(height: 8.0),
//         ElevatedButton(
//           onPressed: () {
//             widget.serialTX.write(ascii.encode('M 0'));
//             widget.serialTX.write(ascii.encode('P 0'));
//           },
//           style: ElevatedButton.styleFrom(
//             primary: Colors.black,
//             onPrimary: Colors.white,
//             padding: const EdgeInsets.all(8.0),
//             textStyle: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//             ),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(5),
//             ),
//           ),
//           child: Text('Set Flexion Limit'),
//         ),
//         const SizedBox(height: 15.0),
//         Text(
//           'Set Extension',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 4.0),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             buildNumberButton('1°', () => setExtension(1)),
//             buildNumberButton('2°', () => setExtension(2)),
//             buildNumberButton('5°', () => setExtension(5)),
//             buildNumberButton('10°', () => setExtension(10)),
//           ],
//         ),
//         const SizedBox(height: 8.0),
//         ElevatedButton(
//           onPressed: () {
//             widget.serialTX.write(ascii.encode('M 1'));
//             widget.serialTX.write(ascii.encode('P 0'));
//           },
//           style: ElevatedButton.styleFrom(
//             primary: Colors.black,
//             onPrimary: Colors.white,
//             padding: const EdgeInsets.all(8.0),
//             textStyle: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//             ),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(5),
//             ),
//           ),
//           child: Text('Set Extension Limit'),
//         ),
//       ],
//     );
//   }

//   Widget buildTable() {
//     return Table(
//       border: null,
//       children: [
//         buildTableRow('Current Angle', 'Flexion Limit', 'Extension Limit', true),
//         buildTableRow('$curFlexAngle°', '$flexLimit°', '$extLimit°', false),
//       ],
//     );
//   }

//   TableRow buildTableRow(String label1, String value1, String label2, bool bold) {
//     return TableRow(
//       children: [
//         TableCell(
//           verticalAlignment: TableCellVerticalAlignment.middle,
//           child: Center(
//             child: Text(
//               label1,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: bold?FontWeight.bold:FontWeight.normal,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ),
//         TableCell(
//           verticalAlignment: TableCellVerticalAlignment.middle,
//           child: Center(
//             child: Text(
//               value1,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: bold?FontWeight.bold:FontWeight.normal,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ),
//         TableCell(
//           verticalAlignment: TableCellVerticalAlignment.middle,
//           child: Center(
//             child: Text(
//               label2,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: bold?FontWeight.bold:FontWeight.normal,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildSpeechButton() {
//     return ElevatedButton(
//       onPressed: _listen,
//       style: ElevatedButton.styleFrom(
//         primary: _isListening ? Colors.red : Colors.green,
//         onPrimary: Colors.white,
//         padding: const EdgeInsets.all(8.0),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//       ),
//       child: Icon(_isListening ? Icons.stop : Icons.mic),
//     );
//   }

//   void _listen() async {
//     if (_isListening) {
//       _speech.stop();
//       setState(() {
//         _isListening = false;
//         _countdown = 1;
//       });
//     } else {
//       bool available = await _speech.initialize(
//         onStatus: (val) => print('onStatus: $val'),
//         onError: (val) => print('onError: $val'),
//       );
//       if (available) {
//         _speech.listen(
//           onResult: (val) {
//             setState(() {
//               _text = val.recognizedWords;
//             });

//             if (_text.contains("stop") || _text.contains("Stop")) {
//               print("Stop");
//               widget.serialTX.write(MyDeviceControlPage.ascii.encode('S 0'));
//             }

//             if (_text.contains("flex") || _text.contains("Flex")) {
//               print("Flex");
//               widget.serialTX.write(MyDeviceControlPage.ascii.encode('F ${speed_setting}'));
//             }
//             if (_text.contains("extend") || _text.contains("Extend")) {
//               print("Extend");
//               widget.serialTX.write(MyDeviceControlPage.ascii.encode('E $speed_setting'));
//             }

//             // Add more conditions for other words

//             // Restart listening immediately
//             _listen();
//           },
//         );

//         setState(() {
//           _isListening = true;
//         });
//       }
//     }
//   }


//   void setFlexion(double value) {
//     widget.serialTX.write(MyDeviceControlPage.ascii.encode('I $value'));
//     setState(() {
//       flexionCounter += value;
//     });
//   }

//   void setExtension(double value) {
//     widget.serialTX.write(MyDeviceControlPage.ascii.encode('J $value'));
//     setState(() {
//       extensionCounter += value;
//     });
//   }

//   Widget buildNumberButton(String text, VoidCallback onPressed) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         primary: Colors.black,
//         onPrimary: Colors.white,
//         padding: const EdgeInsets.all(8.0),
//         textStyle: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(5),
//         ),
//       ),
//       child: Text(text),
//     );
//   }

//   Widget buildSpeedButton(int speed, String text) {
//     return ElevatedButton(
//       onPressed: () {
//         speed_setting = speed;
//       },
//       style: ButtonStyle(
//         minimumSize: MaterialStateProperty.all<Size>(Size(40, 40)),
//         shape: MaterialStateProperty.all<OutlinedBorder>(CircleBorder(),),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//         ),

//       ),
//     );
//   }
// }