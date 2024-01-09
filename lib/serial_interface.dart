// ignore_for_file: unused_import

import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class CPMController {
  CPMController(
      {required this.connectedDevice,
      required this.btInstance,
      required this.btService,
      required this.serialRX,
      required this.serialTX});

  final BluetoothDevice connectedDevice;
  final FlutterBluePlus btInstance;
  final BluetoothService btService;
  final BluetoothCharacteristic serialRX;
  final BluetoothCharacteristic serialTX;

  double angle = 0.0;
  double flex_limit = 180.0;
  double ext_limit = 0.0;
  double zero_angle = 0.0;

  void flex(double delta) {
    ;
  }

  void extend(double delta) {
    ;
  }

  void CPM(double flex_limit, double ext_limit, int cycles) {
    ;
  }
}
