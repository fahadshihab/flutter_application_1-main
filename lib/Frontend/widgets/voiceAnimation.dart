import 'package:flutter/material.dart';
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
    return GestureDetector(
      onTap: () {
        _listenS();
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

  void _listenS() async {
    if (_isListening) {
      _speech.stop();
      setState(() {
        _listen!.fire();
        _isListening = false;
      });
    } else {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        _speech.listen(onResult: (val) {
          setState(() {
            _voiceText = val.recognizedWords;
          });

          if (_voiceText.contains("stop") || _voiceText.contains("Stop")) {
            print("Stop");
          }

          if (_voiceText.contains("flex") || _voiceText.contains("Flex")) {
            print("Flex");
          }

          if (_voiceText.contains("extend") || _voiceText.contains("Extend")) {
            print("Extend");
          }

          // Add more conditions for other words

          // Restart listening immediately
          _listenS();
        });

        setState(() {
          _listenToIdle!.fire();
          _isListening = true;
        });
      }
    }
  }
}
