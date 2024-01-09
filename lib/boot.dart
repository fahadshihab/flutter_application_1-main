
// class AssistedExtension extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           title: const Center(
//             child: Text(
//               'Assisted Extension',
//               style: TextStyle(
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ),
//         //body: MyHomePage(),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key,
//     required this.connectedDevice,
//     //required this.bluetoothInstance,
//     required this.btService,
//     required this.serialRX,
//     required this.serialTX,
//   });

//   static const AsciiCodec ascii = AsciiCodec();

//   final BluetoothDevice connectedDevice;
//   //final FlutterBluePlus bluetoothInstance;
//   final BluetoothService btService;
//   final BluetoothCharacteristic serialRX;
//   final BluetoothCharacteristic serialTX;
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   TextEditingController repsController = TextEditingController();
//   TextEditingController speedController = TextEditingController();
//   double progressValue = 0.0;
//   Timer? progressTimer;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           TextField(
//             controller: repsController,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               labelText: 'Number of reps',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           SizedBox(height: 10),
//           TextField(
//             controller: speedController,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               labelText: 'Speed',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               // Implement logic for the Start button
//               print('Start button pressed');
//               startProgressBar();
//             },
//             style: ElevatedButton.styleFrom(
//               primary: Colors.black,
//               onPrimary: Colors.white,
//               padding: const EdgeInsets.all(16.0),
//               textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             child: Text('Start'),
//           ),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () {
//               // Implement logic for the Stop button
//               print('Stop button pressed');
//               stopProgressBar();
//             },
//             style: ElevatedButton.styleFrom(
//               primary: Colors.black,
//               onPrimary: Colors.white,
//               padding: const EdgeInsets.all(16.0),
//               textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             child: Text('Stop'),
//           ),
//           SizedBox(height: 20),
//           LinearProgressIndicator(
//             minHeight: 30.0, // Adjust the height as needed
//             value: progressValue,
//             backgroundColor: Colors.grey[300],
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
//           ),
//           Spacer(), // Add this spacer to push the Emergency Stop button to the bottom
//           ElevatedButton(
//             onPressed: () {
//               // Implement logic for the Emergency Stop button
//               widget.serialTX.write(MyHomePage.ascii.encode('S 0'));
//               print('Emergency Stop button pressed');
//               stopProgressBar();
//             },
//             style: ElevatedButton.styleFrom(
//               primary: Colors.red,
//               onPrimary: Colors.white,
//               padding: const EdgeInsets.all(16.0),
//               textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             child: Text('Emergency Stop'),
//           ),
//         ],
//       ),
//     );
//   }

//   void startProgressBar() {
//     int numberOfReps = int.tryParse(repsController.text) ?? 1;
//     if (numberOfReps <= 0) {
//       return;
//     }

//     const duration = Duration(seconds: 5); // Change the duration as needed
//     double step = 1.0 / numberOfReps;

//     progressTimer = Timer.periodic(Duration(milliseconds: (duration.inMilliseconds * step).round()), (Timer timer) {
//       if (progressValue >= 1) {
//         timer.cancel();
//         stopProgressBar();
//       } else {
//         setState(() {
//           progressValue += step;
//         });
//       }
//     });
//   }

//   void stopProgressBar() {
//     setState(() {
//       progressValue = 0.0;
//     });

//     if (progressTimer != null && progressTimer!.isActive) {
//       progressTimer!.cancel();
//     }
//   }
// }
