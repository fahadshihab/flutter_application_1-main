import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';

import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MyDeviceControlPage extends StatefulWidget {
  const MyDeviceControlPage({
    Key? key,
    required this.connectedDevice,
    required this.btService,
    required this.serialRX,
    required this.serialTX,
  }) : super(key: key);

  static const AsciiCodec ascii = AsciiCodec();

  final BluetoothDevice connectedDevice;
  final BluetoothService btService;
  final BluetoothCharacteristic serialRX;
  final BluetoothCharacteristic serialTX;

  @override
  _MyDeviceControlPageState createState() => _MyDeviceControlPageState();
}

class _MyDeviceControlPageState extends State<MyDeviceControlPage> {
  late stt.SpeechToText _speech;
  String _text = '';
  bool _isListening = false;
  int _countdown = 2;

  String speedSetting = "";

  @override
  void initState() {
    super.initState();

    // exoDeviceFunctions()
    //     .startreceiverSubscription(widget.serialRX, widget.connectedDevice);
  }

  @override
  Widget build(BuildContext context) {
    int speed_setting = Provider.of<exoDeviceFunctions>(context)
        .speed_setting; // int speed_setting = 80;
    double flexionCounter = Provider.of<exoDeviceFunctions>(context)
        .flexionCounter; // double flexionCounter = 0.0;
    double extensionCounter = Provider.of<exoDeviceFunctions>(context)
        .extensionCounter; // double extensionCounter = 0.0;
    double curFlexAngle = Provider.of<exoDeviceFunctions>(context)
        .curFlexAngle; // double curFlexAngle = 0.0;
    double flexLimit = Provider.of<exoDeviceFunctions>(context)
        .flexLimit; // double flexLimit = 120.0;
    double extLimit = Provider.of<exoDeviceFunctions>(context)
        .extLimit; // double extLimit = 0.0;
    bool isROMLimitEnabled = Provider.of<exoDeviceFunctions>(context)
        .isROMLimitEnabled; // bool isROMLimitEnabled = false;
    bool isAngleControlEnabled = Provider.of<exoDeviceFunctions>(context)
        .isAngleControlEnabled; // bool isAngleControlEnabled = false;

    // int speed_setting = 80;
    // double flexionCounter = 0.0;
    // double extensionCounter = 0.0;
    // double curFlexAngle = 0.0;
    // double flexLimit = 120.0;
    // double extLimit = 0.0;
    // bool isROMLimitEnabled = false;
    // bool isAngleControlEnabled = false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Device Control'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  //widget.serialTX.write(MyDeviceControlPage.ascii.encode('Z 0'));
                  await widget.serialTX.write(ascii.encode("Z 0"));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text('Calibrate'),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  widget.serialTX
                      .write(MyDeviceControlPage.ascii.encode('S 0'));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text('Emergency Stop'),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'ROM Limit',
                  ),
                  Switch(
                    value: isROMLimitEnabled,
                    onChanged: (value) {
                      exoControlFunctions().setROMLimitEnabled(
                          value,
                          widget
                              .serialTX); // exoControlFunctions().setROMLimitEnabled(

                      setState(() {
                        isROMLimitEnabled = value;
                      });
                    },
                  ),
                  Text(
                    'Angle Control',
                  ),
                  Switch(
                    value: isAngleControlEnabled,
                    onChanged: (value) {
                      exoControlFunctions().setAngleControlEnabled(
                          value,
                          widget
                              .serialTX); // exoControlFunctions().setAngleControlEnabled(
                      setState(() {
                        isAngleControlEnabled = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: Color(0xFFF0E0E0),
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'WARNING! Only for debug',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFFF0000),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              exoControlFunctions().resetSetPoint(widget
                                  .serialTX); // exoControlFunctions().resetSetPoint(widget.serialTX);
                            },
                            child: Text('Reset Setpoint')),
                        ElevatedButton(
                            onPressed: () {
                              exoControlFunctions().unwindIntergral(widget
                                  .serialTX); // exoControlFunctions().unwindIntergral(widget.serialTX
                            },
                            child: Text('Unwind Integral')),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      widget.serialTX.write(MyDeviceControlPage.ascii
                          .encode('F ${speed_setting}'));
                    },
                    child: Text('Flex'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.serialTX.write(MyDeviceControlPage.ascii
                          .encode('E ${speed_setting}'));
                    },
                    child: Text('Extend'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.serialTX
                          .write(MyDeviceControlPage.ascii.encode('X 0'));
                    },
                    child: Text('Stop'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Speed',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  buildSpeedButton(50, '1'),
                  buildSpeedButton(100, '2'),
                  buildSpeedButton(150, '3'),
                  buildSpeedButton(200, '4'),
                  buildSpeedButton(250, '5'),
                ],
              ),
              const SizedBox(height: 15.0),
              buildFlexionExtensionButtons(extensionCounter, flexionCounter),
              const SizedBox(height: 15.0),
              buildTable(curFlexAngle, flexLimit, extLimit),
              ElevatedButton(
                onPressed: () {
                  widget.serialTX
                      .write(MyDeviceControlPage.ascii.encode('S 0'));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text('Emergency Stop'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFlexionExtensionButtons(
      double extensionCounter, double flexionCounter) {
    return Column(
      children: [
        Text(
          'Set Flexion',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildNumberButton('1°', () => setFlexion(1, flexionCounter)),
            buildNumberButton('2°', () => setFlexion(2, flexionCounter)),
            buildNumberButton('5°', () => setFlexion(5, flexionCounter)),
            buildNumberButton('10°', () => setFlexion(10, flexionCounter)),
          ],
        ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () {
            widget.serialTX.write(ascii.encode('M 0'));
            widget.serialTX.write(ascii.encode('P 0'));
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            onPrimary: Colors.white,
            padding: const EdgeInsets.all(8.0),
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text('Set Flexion Limit'),
        ),
        const SizedBox(height: 15.0),
        Text(
          'Set Extension',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildNumberButton('1°', () => setExtension(1, flexionCounter)),
            buildNumberButton('2°', () => setExtension(2, flexionCounter)),
            buildNumberButton('5°', () => setExtension(5, flexionCounter)),
            buildNumberButton('10°', () => setExtension(10, flexionCounter)),
          ],
        ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () {
            widget.serialTX.write(ascii.encode('M 1'));
            widget.serialTX.write(ascii.encode('P 0'));
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            onPrimary: Colors.white,
            padding: const EdgeInsets.all(8.0),
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text('Set Extension Limit'),
        ),
      ],
    );
  }

  Widget buildTable(double curFlexAngle, double flexLimit, double extLimit) {
    return Table(
      border: null,
      children: [
        buildTableRow(
            'Current Angle', 'Flexion Limit', 'Extension Limit', true),
        buildTableRow('$curFlexAngle°', '$flexLimit°', '$extLimit°', false),
      ],
    );
  }

  TableRow buildTableRow(
      String label1, String value1, String label2, bool bold) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(
            child: Text(
              label1,
              style: TextStyle(
                fontSize: 14,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(
            child: Text(
              value1,
              style: TextStyle(
                fontSize: 14,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(
            child: Text(
              label2,
              style: TextStyle(
                fontSize: 14,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void setFlexion(double value, double flexionCounter) {
    widget.serialTX.write(MyDeviceControlPage.ascii.encode('I $value'));
    exoDeviceFunctions().setFlexionCounter(flexionCounter + value);
  }

  void setExtension(double value, double extensionCounter) {
    widget.serialTX.write(MyDeviceControlPage.ascii.encode('J $value'));

    exoDeviceFunctions().setExtensionCounter(extensionCounter + value);
  }

  Widget buildNumberButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
        onPrimary: Colors.white,
        padding: const EdgeInsets.all(8.0),
        textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(text),
    );
  }

  Widget buildSpeedButton(int speed, String text) {
    return ElevatedButton(
      onPressed: () {
        exoDeviceFunctions().setSpeed(speed);
      },
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(Size(40, 40)),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          CircleBorder(),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
