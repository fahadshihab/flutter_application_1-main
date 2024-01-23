import 'package:flutter/material.dart';
import 'package:flutter_application_1/Frontend/doctor/manual%20mode/bottomNavBar.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class voiceMode extends StatefulWidget {
  const voiceMode({super.key});

  @override
  State<voiceMode> createState() => _voiceModeState();
}

class _voiceModeState extends State<voiceMode> {
  late stt.SpeechToText _speech;
  String _voiceText = '';
  bool _isListening = false;
  @override
  Widget build(BuildContext context) {
    _speech = stt.SpeechToText();
    return Scaffold(
      bottomNavigationBar: bottomNavBar(),
      backgroundColor: Color(0xffF0F0F2),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Voice Mode',
          style: TextStyle(
            fontWeight: FontWeight.w600,
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
    );
  }

  void _listen() async {
    if (_isListening) {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    } else {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (val) {
            setState(() {
              _voiceText = val.recognizedWords;
            });

            if (_voiceText.contains("stop") || _voiceText.contains("Stop")) {
              print("Stop");
            }

            if (_voiceText.contains("flex") || _voiceText.contains("Flex")) {
              print("Flex");
            }
            if (_voiceText.contains("extend") ||
                _voiceText.contains("Extend")) {
              print("Extend");
            }

            // Add more conditions for other words

            // Restart listening immediately
            _listen();
          },
        );
      }
    }
  }
}
