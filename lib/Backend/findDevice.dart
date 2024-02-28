import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_application_1/Backend/exoDeviceFunctions.dart';

import 'package:flutter_application_1/Backend/pinEncrypter.dart';
import 'package:flutter_application_1/Frontend/pages/device_setup.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_application_1/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class findDevice extends StatefulWidget {
  const findDevice({super.key});

  @override
  _findDeviceState createState() => _findDeviceState();
}

class _findDeviceState extends State<findDevice> {
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _connectedDevice;
  bool isBluetoothOff = true;
  bool _isScanning = false;
  late StreamSubscription subscription;
  late BluetoothService? _btSerialService;
  late BluetoothCharacteristic? _serialRXCharacteristic;
  late BluetoothCharacteristic? _serialTXCharacteristic;
  static const String SERVICE_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  static const String TX_UUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
  static const String RX_UUID = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";
  static const String DEVICE_NAME = "ExoFlex";
  bool deviceFound = false;
  BluetoothDevice? _selectedDevice;
  TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //
    _devices.clear();
    checkBluetoothPermission();
  }

  checkBluetoothPermission() async {
    var subscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print(state);
      if (state == BluetoothAdapterState.on) {
        if (mounted) {
          setState(() {
            isBluetoothOff = false;
          });
        }
        Future.delayed(const Duration(seconds: 1)).then((value) async {
          await checkAndDisconnectDevice("CREAID");

          _startScan();
        });
      } else {
        if (mounted) {
          setState(() {
            isBluetoothOff = true;
          });
        }
        Future.delayed(const Duration(seconds: 1)).then((value) {
          _stopScan();
        });
      }
    });
  }

  void _startScan() {
    if (mounted) {
      setState(() {
        FlutterBluePlus.setLogLevel(LogLevel.warning);
        _devices.clear();
        _isScanning = true;
      });
    }

    subscription = FlutterBluePlus.onScanResults.listen((results) {
      for (ScanResult result in results) {
        if (_devices.contains(result.device)) continue;
        if (result.device.platformName.contains('CREAID')) {
          // if (result.device.platformName != '' &&
          //     result.device.platformName != null) {
          if (mounted) {
            setState(() {
              _devices.add(result.device);
            });
          }
        }
      }
    });

    FlutterBluePlus.startScan().then((val) {
      Future.delayed(const Duration(seconds: 10)).then((value) {
        _stopScan();

        print(_devices);
        if (_devices.length == 1) {
          if (mounted) {
            setState(() {
              deviceFound = true;
              _selectedDevice = _devices[0];
            });
          }
        } else if (_devices.length > 1) {
          if (mounted) {
            setState(() {
              deviceFound = true;
            });
          }
        }
      });
    });
  }

  void _stopScan() {
    FlutterBluePlus.stopScan().then((val) {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
      subscription.cancel();
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    if (mounted) {
      setState(() {
        _connectedDevice = null;
      });
    }

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
          if (mounted) {
            setState(() {
              if (characteristic.uuid.toString() == RX_UUID) {
                _serialRXCharacteristic = characteristic;
              } else if (characteristic.uuid.toString() == TX_UUID) {
                _serialTXCharacteristic = characteristic;
              }
            });
          }
        });
        // }
      });

      if (_btSerialService != null &&
          _serialRXCharacteristic != null &&
          _serialTXCharacteristic != null) {
        print(
            "Required services and characteristics found. Starting MyDeviceControlPage.");
        if (mounted) {
          setState(() {
            _connectedDevice = device;

            Provider.of<exoDeviceFunctions>(context, listen: false)
                .setSerialRX(_serialRXCharacteristic!);
            Provider.of<exoBluetoothControlFunctions>(context, listen: false)
                .setSerialTX(_serialTXCharacteristic!);
            Provider.of<exoDeviceFunctions>(context, listen: false)
                .setConnectedDevice(device);
            Provider.of<exoDeviceFunctions>(context, listen: false)
                .startreceiverSubscription(
                    _connectedDevice!, _serialRXCharacteristic!, context);
            // } catch (e) {

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => deviceSetup()),
                (route) => false);
          });
        }
      } else {
        print("Error: Required services or characteristics not found");
        await device.disconnect();
      }
    } catch (e) {
      print("Error connecting to device: $e");
    }
    if (mounted) {
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
    return Stack(children: [
      Image.asset(
        'assets/images/backgroundHexo.gif',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              // Color.fromARGB(60, 0, 0, 0),
              Color.fromARGB(120, 0, 0, 0),
              Color.fromARGB(255, 0, 0, 0)
            ],
          ),
        ),
      ),
      Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 400,
          elevation: 0,
          centerTitle: true,
          title: Column(
            children: [
              Text('HExo',
                  style: GoogleFonts.poppins(
                      fontSize: 100,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 255, 255, 255))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Hand Exoskeleton',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 255, 255, 255))),
                  Image.asset(
                    'assets/images/main_logo.png',
                    height: 20,
                    width: 20,
                  ),
                ],
              ),
            ],
          ),
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.only(bottom: 320, right: 10),
          //     child: Image.asset(
          //       'assets/images/main_logo.png',
          //       height: 50,
          //       width: 50,
          //     ),
          //   )
          // ],
        ),
        // appBar: AppBar(

        //   backgroundColor: ,
        //   title:is const Text('Connect Device'),
        // ),
        body: isBluetoothOff
            // body: false
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Color.fromARGB(145, 0, 90, 174),
                              Color(0xff004788)
                            ],
                          ),
                          // color: Color.fromARGB(255, 0, 70, 136),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(12, 26),
                                blurRadius: 50,
                                spreadRadius: 0,
                                color: Color.fromARGB(255, 74, 74, 74)
                                    .withOpacity(.1)),
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 25,
                              child: Icon(
                                Icons.bluetooth,
                                color: Color(0xff004788),
                                size: 30,
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text("Bluetooth is turned off",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 3.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: const Text("Please turn on bluetooth",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300)),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SimpleBtn1(
                              text: "Turn On",
                              onPressed: () async {
                                if (Platform.isAndroid) {
                                  await FlutterBluePlus.turnOn();
                                } else {
                                  SnackBar snackBar = SnackBar(
                                    content: Text(
                                      'Turn on bluetooth manually for iOS',
                                      style: TextStyle(
                                        color: Color(0xff004788),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              }),
                          SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : _isScanning
                // : false
                ? _scanningWidget()
                : deviceFound == false
                    // : false
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(30),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              // color: Color(0xff004788),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Color.fromARGB(145, 0, 70, 136),
                                  Color(0xff004788)
                                ],
                              ),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(12, 26),
                                    blurRadius: 50,
                                    spreadRadius: 0,
                                    color: Color.fromARGB(255, 74, 74, 74)
                                        .withOpacity(.1)),
                              ],
                            ),
                            child: Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 10),
                                    child: Text(
                                      'No HEXO found',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _startScan();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(12, 26),
                                            blurRadius: 50,
                                            spreadRadius: 0,
                                            color:
                                                Color.fromARGB(255, 74, 74, 74)
                                                    .withOpacity(.1)),
                                      ],
                                    ),
                                    child: Text(
                                      'Scan again',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 45,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : _selectedDevice == null
                        // : false
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, bottom: 10),
                                      child: Text(
                                        'Multiple HEXO found',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
                                      ),
                                    ),
                                  ),
                                  // dropdown list
                                  Container(
                                    constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height /
                                                3),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    // decoration: BoxDecoration(
                                    //   color: Color.fromARGB(
                                    //       255, 255, 255, 255),
                                    //   borderRadius:
                                    //       BorderRadius.circular(15),
                                    //   boxShadow: [
                                    //     BoxShadow(
                                    //         offset: const Offset(12, 26),
                                    //         blurRadius: 50,
                                    //         spreadRadius: 0,
                                    //         color: Color.fromARGB(
                                    //                 255, 74, 74, 74)
                                    //             .withOpacity(.1)),
                                    //   ],
                                    // ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _devices.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (mounted) {
                                              setState(() {
                                                _selectedDevice =
                                                    _devices[index];
                                              });
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                    offset:
                                                        const Offset(12, 26),
                                                    blurRadius: 50,
                                                    spreadRadius: 0,
                                                    color: Color.fromARGB(
                                                            255, 74, 74, 74)
                                                        .withOpacity(.1)),
                                              ],
                                            ),
                                            child: Text(
                                              _devices[index].name,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                ],
                              ),
                            ],
                          )
                        : // Figma Flutter Generator Frame114Widget - FRAME - VERTICAL
                        Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Color.fromARGB(222, 0, 70, 136),
                                      Color(0xff004788)
                                    ],
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.bluetooth,
                                        color: Colors.white, size: 30),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Connect To Device',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'enter the 6 digit PIN  indicated on the device',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: TextField(
                                        controller: _pinController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 6,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
                                        decoration: InputDecoration(
                                          hintText: 'PIN',
                                          hintStyle: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SimpleBtn1(
                                        text: "Connect",
                                        onPressed: () {
                                          if (true)
                                          // if (getHexoDeviceName(
                                          // _pinController.text.trim()) ==
                                          // _selectedDevice!.platformName)
                                          {
                                            FocusScope.of(context).unfocus();

                                            _connectToDevice(_selectedDevice!);
                                          } else {
                                            _pinController.clear();
                                            SnackBar snackBar = SnackBar(
                                              content: Text(
                                                'Please enter a valid PIN',
                                                style: TextStyle(
                                                  color: Color(0xff004788),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              backgroundColor: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        }),
                                    const SizedBox(
                                      height: 60,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
      ),
    ]);
  }
}

class _scanningWidget extends StatelessWidget {
  const _scanningWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Text(
          //   'HExo',
          //   textAlign: TextAlign.center,
          //   style: GoogleFonts.poppins(
          //       fontSize: 100,
          //       fontWeight: FontWeight.w600,
          //       color: Color.fromARGB(255, 255, 255, 255)),
          // ),
          const SizedBox(
            height: 150,
          ),
          Image.asset(
            'assets/images/Adult-Swim-Art-GIF-by-Micah-Bu-unscreen.gif',
            height: 200,
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.all(30),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              // color: Color(0xff004788),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(255, 1, 89, 171), Color(0xff004788)],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(12, 26),
                    blurRadius: 50,
                    spreadRadius: 0,
                    color: Color.fromARGB(255, 74, 74, 74).withOpacity(.1)),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 40),
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Searching for HEXO',
                      textStyle: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 255, 255, 255)),
                      speed: const Duration(milliseconds: 200),
                    ),
                    TypewriterAnimatedText(
                      'STILL Searching for HEXO',
                      textStyle: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 255, 255, 255)),
                      speed: const Duration(milliseconds: 200),
                    ),
                  ],
                  isRepeatingAnimation: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class turnOnBluetoothButton extends StatelessWidget {
  const turnOnBluetoothButton({Key? key}) : super(key: key);
  final primaryColor = const Color(0xff004788);
  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.4,
        height: MediaQuery.of(context).size.height / 4,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Color.fromARGB(255, 74, 74, 74).withOpacity(.1)),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                backgroundColor: primaryColor,
                radius: 25,
                child: Icon(
                  Icons.bluetooth,
                  color: Colors.white,
                  size: 30,
                )),
            const SizedBox(
              height: 15,
            ),
            const Text("Bluetooth is turned off",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 3.5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: const Text("Please turn on bluetooth",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w300)),
            ),
            const SizedBox(
              height: 15,
            ),
            SimpleBtn1(
                text: "Turn On",
                onPressed: () async {
                  if (Platform.isAndroid) {
                    await FlutterBluePlus.turnOn();
                  } else {
                    SnackBar snackBar = SnackBar(
                      content: Text(
                        'Turn on bluetooth manually for iOS',
                        style: TextStyle(
                          color: Color(0xff004788),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                })
          ],
        ),
      ),
    );
  }
}

class SimpleBtn1 extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool invertedColors;
  SimpleBtn1(
      {required this.text,
      required this.onPressed,
      this.invertedColors = false,
      Key? key})
      : super(key: key);
  final primaryColor = Color.fromARGB(255, 255, 255, 255);
  final accentColor = Color(0xff004788);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            alignment: Alignment.center,
            side: MaterialStateProperty.all(
                BorderSide(width: 1, color: primaryColor)),
            padding: MaterialStateProperty.all(
                const EdgeInsets.only(right: 25, left: 25, top: 0, bottom: 0)),
            backgroundColor: MaterialStateProperty.all(
                invertedColors ? accentColor : primaryColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            )),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              color: invertedColors ? primaryColor : accentColor, fontSize: 16),
        ));
  }
}

test() {
  print('yoyoy');
}

checkAndDisconnectDevice(String deviceName) async {
  // Discover connected devices
  print('tty');
  List<BluetoothDevice> connectedDevices = await FlutterBluePlus.systemDevices;

  // Check if the device with the specified name is connected
  connectedDevices.forEach((device) {
    if (device.platformName.contains('CREAID')) {
      device.disconnect(queue: false);
      device.removeBond();
    }
  });
}
