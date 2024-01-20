import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/findDevice.dart';
import 'package:flutter_application_1/Frontend/doctor/manual%20mode/device_setup.dart';
import 'package:provider/provider.dart';

class checkBluetoothConnection extends StatelessWidget {
  const checkBluetoothConnection({super.key});

  @override
  Widget build(BuildContext context) {
    bool _deviceConnected =
        Provider.of<bluetoothState>(context).isDeviceConnected;
    return _deviceConnected ? deviceSetup() : findDevice();
  }
}

class bluetoothState extends ChangeNotifier {
  bool _deviceConnected = false;

  bool get isDeviceConnected => _deviceConnected;

  setDeviceConnected(bool deviceConnected) {
    _deviceConnected = deviceConnected;
    notifyListeners();
  }
}
