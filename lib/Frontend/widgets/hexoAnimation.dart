import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class hexoAnimationWidget extends StatelessWidget {
  hexoAnimationWidget({super.key});

  bool isFlexing = false;

  bool isExtending = false;

  Timer? flextimer;

  StateMachineController? _controller;

  SMIInput<double>? _input;

  @override
  Widget build(BuildContext context) {
    if (_input != null) {
      _input!.change(mapValue(
          Provider.of<exoDeviceFunctions>(context, listen: false)
              .curFlexAngle));
    }
    return Center(
      child: GestureDetector(
        onTapDown: (details) {},
        onTapUp: (details) {},
        child: Container(
          child: RiveAnimation.asset(
            'assets/rive/new_file.riv',
            fit: BoxFit.fitHeight,
            onInit: (artbord) {
              _controller = StateMachineController.fromArtboard(
                  artbord, 'State Machine 1');
              if (_controller != null) {
                artbord.addController(_controller!);

                _input = _controller!.findInput('Number 1');
                _input!.change(mapValue(
                    Provider.of<exoDeviceFunctions>(context, listen: false)
                        .curFlexAngle));
              }
            },
          ),
        ),
      ),
    );
  }

  double mapValue(double originalValue) {
    // Assuming originalValue is in the range 0 to 180
    // Map it to the range 100 to 0
    return 100 - (originalValue / 180 - 15) * 100;
  }
}
