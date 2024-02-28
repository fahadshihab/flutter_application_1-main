import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class hexoAnimationWidget extends StatefulWidget {
  hexoAnimationWidget({super.key});

  @override
  hexoAnimationWidgetState createState() => hexoAnimationWidgetState();
}

class hexoAnimationWidgetState extends State<hexoAnimationWidget> {
  bool isFlexing = false;

  bool isExtending = false;

  Timer? flextimer;

  late StateMachineController _controller;

  SMIInput<double>? _input;

  @override
  void initState() {
    super.initState();
  }

  void _onInit(Artboard art) {
    var ctrl = StateMachineController.fromArtboard(art, 'State Machine 1')
        as StateMachineController;
    ctrl.isActive = false;
    art.addController(ctrl);
    setState(() {
      _controller = ctrl;
      _input = ctrl.findInput('Number 1');
    });
  }

  @override
  Widget build(BuildContext context) {
    final hexostate = Provider.of<exoDeviceFunctions>(context);

    if (_input != null) {
      _input!.change(mapValue(hexostate.curFlexAngle));
    }
    return Center(
      child: GestureDetector(
        onTapDown: (details) {
          print(hexostate.curFlexAngle);
        },
        onTapUp: (details) {},
        child: RiveAnimation.asset(
          'assets/rive/new_file (1).riv',
          fit: BoxFit.fitHeight,
          onInit: _onInit,
        ),
      ),
    );
  }

  double mapValue(double originalValue) {
    // Assuming originalValue is in the range 0 to 180
    // Map it to the range 100 to 0
    return (originalValue / 140) * 100;
  }
}
