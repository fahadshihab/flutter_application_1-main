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
      child: RiveAnimation.asset(
        'assets/rive/google_assistant_redesign_-_animation.riv',
        fit: BoxFit.fitHeight,
        onInit: (artbord) {
          _controller =
              StateMachineController.fromArtboard(artbord, 'State Machine 1');
          if (_controller != null) {
            artbord.addController(_controller!);
            _listen = _controller!.findSMI('listen');
            _listenToIdle = _controller!.findSMI('listen to idle');
            _Speaking = _controller!.findSMI('speak & listen');
          }
        },
      ),
    );
  }

  void _listenS() async {
    if (_isListening) {
      _speech.stop();
      setState(() {
        _listenToIdle!.fire();
        _isListening = false;
      });
    } else {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val != "listening") {
            _speech.stop();
            print('not listening');
            setState(() {
              _listenToIdle!.fire();
              _isListening = false;
            });
          }
        },
        onError: (val) {
          _speech.stop();
          setState(() {
            _listenToIdle!.fire();
            _isListening = false;
          });
        },
      );
      if (available) {
        _speech.listen(onResult: (val) {
          if (val.recognizedWords.contains("stop") ||
              val.recognizedWords.contains("Stop")) {
            print("Stop");
          }

          if (val.recognizedWords.contains("flex") ||
              val.recognizedWords.contains("Flex")) {
            print("Flex");
          }

          if (val.recognizedWords.contains("extend") ||
              val.recognizedWords.contains("Extend")) {
            print("Extend");
          }

          // Add more conditions for other words

          // Restart listening immediately
          // _listenS();
        });

        setState(() {
          _listen!.fire();

          _isListening = true;
        });
      }
    }
  }
}
