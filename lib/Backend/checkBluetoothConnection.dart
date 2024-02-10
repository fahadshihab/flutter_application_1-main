import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class checkBluetoothConnection {
  final GlobalKey<NavigatorState> navigatorKey;

  checkBluetoothConnection(this.navigatorKey);

  bluetootchListner() {
    FlutterBluePlus.adapterState.listen((state) {
      if (state != BluetoothAdapterState.on) {
        navigatorKey.currentState!
            .pushNamedAndRemoveUntil('/findDevice', (route) => false);
      }
    });
    bluetoothDeviceConnectionListner();
  }

  bluetoothDeviceConnectionListner() {
    FlutterBluePlus.events.onConnectionStateChanged.listen((value) {
      if (value == BluetoothConnectionState.disconnected) {
        navigatorKey.currentState!
            .pushNamedAndRemoveUntil('/findDevice', (route) => false);
      }
    });
  }

  Future<bool> bluetoothConnectionInetial() async {
    if (await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on) {
      print(await FlutterBluePlus.systemDevices);
      if (await FlutterBluePlus.systemDevices.then((value) {
        for (BluetoothDevice device in value) {
          if (device.platformName.contains("CREAID")) {
            return true;
          }
        }
        return false;
      })) {
        return true;
      }
    }
    return false;
  }
}
