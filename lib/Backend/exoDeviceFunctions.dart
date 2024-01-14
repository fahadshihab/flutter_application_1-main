import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

class exoDeviceFunctions extends ChangeNotifier {
  late StreamSubscription _receiverSubscription;
  int _speed_setting = 1;
  double _flexionCounter = 0;
  double _extensionCounter = 0;
  double _curFlexAngle = 80;
  double _flexLimit = 20;
  double _extLimit = 180;
  bool _isROMLimitEnabled = false;
  bool _isAngleControlEnabled = false;

  int get speed_setting => _speed_setting;
  double get flexLimit => _flexLimit;
  double get extensionCounter => _extensionCounter;
  double get flexionCounter => _flexionCounter;
  double get curFlexAngle => _curFlexAngle;
  double get extLimit => _extLimit;
  bool get isROMLimitEnabled => _isROMLimitEnabled;
  bool get isAngleControlEnabled => _isAngleControlEnabled;

  void test_flex() {
    if (curFlexAngle > 0 && curFlexAngle >= flexLimit) {
      _curFlexAngle -= _speed_setting;
      notifyListeners();
    }
  }

  void test_extend() {
    if (curFlexAngle < 180 && curFlexAngle <= extLimit) {
      _curFlexAngle += _speed_setting;
      notifyListeners();
    }
  }

  void setSpeed(int speed) {
    _speed_setting = speed;
    notifyListeners();
  }

  void setFlexLimit(double limit) {
    _flexLimit = limit;
    notifyListeners();
  }

  void setExtLimit(double limit) {
    _extLimit = limit;
    notifyListeners();
  }

  void setFlexionCounter(double counter) {
    _flexionCounter = counter;
    notifyListeners();
  }

  void setExtensionCounter(double counter) {
    _extensionCounter = counter;
    notifyListeners();
  }

  void setCurFlexAngle(double angle) {
    _curFlexAngle = angle;

    notifyListeners();
  }

  void setROMLimitEnabled(bool enabled) {
    _isROMLimitEnabled = enabled;
    notifyListeners();
  }

  void setAngleControlEnabled(bool enabled) {
    _isAngleControlEnabled = enabled;
    notifyListeners();
  }

  startreceiverSubscription(
      BluetoothCharacteristic serialRX, BluetoothDevice connectedDevice) {
    _receiverSubscription = serialRX.onValueReceived.listen((value) {
      String rx_str = ascii.decode(value);
      List<String> commands = rx_str.split(" ");
      if (commands[0] == "A") {
        setCurFlexAngle(double.parse(commands[1]));
      } else if (commands[0] == "P0") {
        setAngleControlEnabled(int.parse(commands[1]) == 1 ? true : false);
      } else if (commands[0] == "P1") {
        setROMLimitEnabled(int.parse(commands[1]) == 1 ? true : false);
      } else if (commands[0] == "P2") {
        setFlexLimit(double.parse(commands[1]));
      } else if (commands[0] == "P3") {
        setExtLimit(double.parse(commands[1]));
      }
    });
    connectedDevice.cancelWhenDisconnected(_receiverSubscription);
    serialRX.setNotifyValue(true);
  }
}

class exoBluetoothControlFunctions {
  void setSpeed(int speed, BluetoothCharacteristic serialTX) {
    String tx_str = "S" + speed.toString();
    serialTX.write(utf8.encode(tx_str));
  }

  void setFlexLimit(double limit, BluetoothCharacteristic serialTX) {
    String tx_str = "L" + limit.toString();
    serialTX.write(utf8.encode(tx_str));
  }

  void setExtLimit(double limit, BluetoothCharacteristic serialTX) {
    String tx_str = "l" + limit.toString();
    serialTX.write(utf8.encode(tx_str));
  }

  void setROMLimitEnabled(bool enabled, BluetoothCharacteristic serialTX) {
    String tx_str = "R" + (enabled ? "1" : "0");
    serialTX.write(utf8.encode(tx_str));
  }

  void setAngleControlEnabled(bool enabled, BluetoothCharacteristic serialTX) {
    String tx_str = "P0" + (enabled ? "1" : "0");
    serialTX.write(utf8.encode(tx_str));
  }

  void resetSetPoint(BluetoothCharacteristic serialTX) {
    String tx_str = "G 5";
    serialTX.write(utf8.encode(tx_str));
  }

  void unwindIntergral(BluetoothCharacteristic serialTX) {
    String tx_str = "G 4";
    serialTX.write(utf8.encode(tx_str));
  }
}
