import 'package:flutter/material.dart';
import 'package:flutter_application_1/Backend/IGNORE_deviceFunctions.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_application_1/main.dart';

class ConnectDevicePage extends StatefulWidget {
  const ConnectDevicePage({super.key});

  @override
  _ConnectDevicePageState createState() => _ConnectDevicePageState();
}

class _ConnectDevicePageState extends State<ConnectDevicePage> {
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _connectedDevice;
  bool _isScanning = false;
  late StreamSubscription subscription;
  late BluetoothService? _btSerialService;
  late BluetoothCharacteristic? _serialRXCharacteristic;
  late BluetoothCharacteristic? _serialTXCharacteristic;
  static const String SERVICE_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  static const String TX_UUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
  static const String RX_UUID = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    setState(() {
      FlutterBluePlus.setLogLevel(LogLevel.warning);
      _devices.clear();
      _isScanning = true;
    });

    subscription = FlutterBluePlus.onScanResults.listen((results) {
      for (ScanResult result in results) {
        if (_devices.contains(result.device)) continue;
        setState(() {
          _devices.add(result.device);
        });
      }
    });

    FlutterBluePlus.startScan().then((val) {
      Future.delayed(const Duration(seconds: 10)).then((value) {
        _stopScan();
      });
    });
  }

  void _stopScan() {
    FlutterBluePlus.stopScan().then((val) {
      setState(() {
        _isScanning = false;
        subscription.cancel();
      });
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _connectedDevice = null;
    });

    try {
      print("Connecting to device: ${device.name} (${device.id})");
      await device.connect(autoConnect: false, timeout: Duration(seconds: 10));
      print("Connected to device: ${device.name} (${device.id})");

      List<BluetoothService> services = await device.discoverServices();
      services.forEach((service) {
        print(service.uuid.toString());
        print(service.characteristics.length);
        // if (service.uuid.toString() == SERVICE_UUID) {
        _btSerialService =
            service; ///////////////////////////// potential probles  here witht he if statments
        service.characteristics.forEach((characteristic) {
          // if (characteristic.uuid.toString() == RX_UUID) {
          _serialRXCharacteristic = characteristic;
          // } else if (characteristic.uuid.toString() == TX_UUID) {
          _serialTXCharacteristic = characteristic;
          // }
        });
        // }
      });

      if (_btSerialService != null &&
          _serialRXCharacteristic != null &&
          _serialTXCharacteristic != null) {
        print(
            "Required services and characteristics found. Starting MyDeviceControlPage.");
        setState(() {
          _connectedDevice = device;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyDeviceControlPage(
                connectedDevice: device,
                btService: _btSerialService as BluetoothService,
                serialRX: _serialRXCharacteristic as BluetoothCharacteristic,
                serialTX: _serialTXCharacteristic as BluetoothCharacteristic,
              ),
            ),
          );
        });
      } else {
        print("Error: Required services or characteristics not found");
        await device.disconnect();
      }
    } catch (e) {
      print("Error connecting to device: $e");
      setState(() {
        _connectedDevice = null;
      });
    }
  }

  @override
  void dispose() {
    _stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Device'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _isScanning ? null : _startScan,
            child: const Text('Refresh'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                final device = _devices[index];
                return ListTile(
                  title: Text(device.name.isNotEmpty
                      ? device.name
                      : device.platformName),
                  subtitle: Text(device.remoteId.toString()),
                  onTap: () {
                    _connectToDevice(device);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
