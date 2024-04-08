import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class voiceAnimation extends StatefulWidget {
  bool isListening = false;

  voiceAnimation({super.key});

  @override
  State<voiceAnimation> createState() => _voiceAnimationState();
}

class _voiceAnimationState extends State<voiceAnimation> {
  late stt.SpeechToText _speech;
  String _voiceText = '';
  bool _isListening = false;

  StateMachineController? _controller;

  // trigger listen
  SMITrigger? _listen;
  //trigger listentoIdel
  SMITrigger? _listenToIdle;

  SMIBool? _Speaking;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    BluetoothCharacteristic serialTX =
        Provider.of<exoBluetoothControlFunctions>(context).serialTX!;
    int speed = Provider.of<exoDeviceFunctions>(context).speed_setting;
    return GestureDetector(
      onTap: () {
        _listenS(speed, serialTX);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(30),
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            color: const Color(0xFF004788),
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 5, right: 2),
            child: RiveAnimation.asset(
              'assets/rive/google_assistant_redesign_-_animation.riv',
              fit: BoxFit.fitHeight,
              onInit: (artbord) {
                _controller = StateMachineController.fromArtboard(
                    artbord, 'State Machine 1');
                if (_controller != null) {
                  artbord.addController(_controller!);
                  _listen = _controller!.findSMI('listen');
                  _listenToIdle = _controller!.findSMI('listen to idle');
                  _Speaking = _controller!.findSMI('speak & listen');
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _listenS(int speed, BluetoothCharacteristic serialTX) async {
    if (_isListening) {
      _speech.stop();
      _listenToIdle?.fire();
      await Future.delayed(Duration(milliseconds: 500));

      setState(() {
        _isListening = false;
      });
    } else {
      _listen?.fire();
      await Future.delayed(Duration(milliseconds: 400));

      bool available = await _speech.initialize(
          onStatus: (val) => print('onStatus: $val'),
          onError: (val) async {
            print('onError: $val');
            _listenToIdle?.fire();
            await Future.delayed(Duration(milliseconds: 500));
          });
      if (available) {
        _speech.listen(
          onResult: (val) {
            setState(() {
              _voiceText = val.recognizedWords;
            });

            if (_voiceText.contains("stop") || _voiceText.contains("Stop")) {
              print("Stop");
              exoBluetoothControlFunctions().stop(serialTX);
            }

            if (_voiceText.contains("flex") || _voiceText.contains("Flex")) {
              print("Flex");
              exoBluetoothControlFunctions().flex(speed, serialTX);
            }
            if (_voiceText.contains("extend") ||
                _voiceText.contains("Extend")) {
              print("Extend");
              exoBluetoothControlFunctions().extend(speed, serialTX);
            }

            // Add more conditions for other words

            // Restart listening immediately
            _listenS(speed, serialTX);
          },
        );

        setState(() {
          _isListening = true;
        });
      }
    }
  }
}
