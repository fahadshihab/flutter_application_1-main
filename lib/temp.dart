import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//import 'package:page_transition/page_transition.dart';
//import 'package:flutter_application_1/voice8.dart';
import 'package:flutter_application_1/main.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HandsPage extends StatefulWidget {
  const HandsPage({
    super.key,
    required this.connectedDevice,
    //required this.bluetoothInstance,
    required this.btService,
    required this.serialRX,
    required this.serialTX,
  });

  static const AsciiCodec ascii = AsciiCodec();

  final BluetoothDevice connectedDevice;
  //final FlutterBluePlus bluetoothInstance;
  final BluetoothService btService;
  final BluetoothCharacteristic serialRX;
  final BluetoothCharacteristic serialTX;

  @override
  _HandsPageState createState() => _HandsPageState();
}

class _HandsPageState extends State<HandsPage> {
  late stt.SpeechToText _speech;
  String _text = '';
  bool _isListening = false;
  int _countdown = 2; // Countdown duration in seconds

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  //speech for hands
  Widget build1(BuildContext context) {
    return Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _listen,
        //   backgroundColor: _isListening ? Colors.red : Colors.green,
        //   child: Text(_isListening ? 'Stop' : 'Start'),
        // ),
        );
  }

  // void _listen() async {
  //   if (_isListening) {
  //     _speech.stop();
  //     _timer.cancel();
  //     setState(() {
  //       _isListening = false;
  //       _countdown = 2; // Reset countdown for the next listen
  //     });
  //   } else {
  //     bool available = await _speech.initialize(
  //       onStatus: (val) => print('onStatus: $val'),
  //       onError: (val) => print('onError: $val'),
  //     );
  //     if (available) {
  //       _speech.listen(
  //         onResult: (val) => setState(() {
  //           _text = val.recognizedWords;
  //         }),
  //       );

  //       if (_text.contains("stop")) {
  //         widget.serialTX.write(HandsPage.ascii.encode('S 0'));
  //       }
  //       if (_text.contains("flex")) {
  //         widget.serialTX.write(HandsPage.ascii.encode('F $speed_setting'));
  //       }
  //       if (_text.contains("extend")) {
  //         widget.serialTX.write(HandsPage.ascii.encode('F $speed_setting'));    // worng command
  //       }

  //       _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //         if (_countdown > 0) {
  //           setState(() {
  //             _countdown--;
  //           });
  //         } else {
  //           _timer.cancel();
  //           setState(() {
  //             _isListening = false;
  //             _countdown = 2; // Reset countdown for the next listen
  //           });
  //           _listen(); // Initiates listening again
  //         }
  //       });
  //     }
  //     setState(() {
  //       _isListening = true;
  //     });
  //   }
  // }

  int cpm_reps_setting = 0;
  int speed_setting = 100;
  bool is_button_enabled = true;
  int _currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
            child: Text(
          'Device Control',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 180, 45),
          ),
        )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Update the _currentValue when the input changes
                _currentValue = int.tryParse(value) ?? 0;
              },
              decoration: const InputDecoration(
                labelText: 'Enter value',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: is_button_enabled
                  ? () {
                      setState(() {
                        is_button_enabled = false;
                      });
                      widget.serialTX
                          .write(HandsPage.ascii.encode('F $speed_setting'));
                      Future.delayed(const Duration(milliseconds: 2000), () {
                        setState(() {
                          is_button_enabled = true;
                        });
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: const Color.fromARGB(255, 255, 200, 0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onHover: (value) {
                // Handle hover effect
              },
              child: const Text('Manual Flex'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: is_button_enabled
                  ? () {
                      setState(() {
                        is_button_enabled = false;
                      });
                      widget.serialTX
                          .write(HandsPage.ascii.encode('E $speed_setting'));
                      Future.delayed(const Duration(milliseconds: 2000), () {
                        setState(() {
                          is_button_enabled = true;
                        });
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                primary: const Color.fromARGB(255, 255, 180, 45),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onHover: (value) {
                // Handle hover effect
              },
              child: const Text('Manual Extend'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: is_button_enabled
                  ? () {
                      setState(() {
                        is_button_enabled = false;
                      });
                      widget.serialTX
                          .write(HandsPage.ascii.encode('C $cpm_reps_setting'));
                      Future.delayed(
                          Duration(milliseconds: 10000 * cpm_reps_setting), () {
                        setState(() {
                          is_button_enabled = true;
                        });
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 255, 180, 45),
                onPrimary: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onHover: (value) {
                // Handle hover effect
              },
              child: const Text('CPM'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Reps',
                ),
                onSubmitted: (value) {
                  setState(() {
                    cpm_reps_setting = int.parse(value);
                  });
                },
              ),
            ),
            SizedBox(
              width: 250,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Speed',
                ),
                onSubmitted: (value) {
                  setState(() {
                    speed_setting = int.parse(value);
                  });
                },
              ),
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(
                width: 10,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                widget.serialTX.write(HandsPage.ascii.encode('S 0'));
                Future.delayed(const Duration(milliseconds: 200), () {
                  setState(() {
                    is_button_enabled = true;
                  });
                });
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 255, 0, 0),
                onPrimary: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onHover: (value) {
                // Handle hover effect
              },
              child: const Text('EMERGENCY STOP'),
            ),
          ],
        ),
      ),
    );
  }
}
