// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:flutter_blue_plus/uuid.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: BluetoothPage(),
//     );
//   }
// }

// class BluetoothPage extends StatefulWidget {
//   @override
//   _BluetoothPageState createState() => _BluetoothPageState();
// }

// class _BluetoothPageState extends State<BluetoothPage> {
//   final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

//   final ble.QualifiedCharacteristic characteristic =
//       ble.QualifiedCharacteristic(
//     characteristicId: ble.Uuid.parse("6e400002-b5a3-f393-e0a9-e50e24dcca9e"),
//     serviceId: ble.Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e"),
//     deviceId: "B8:D6:1A:BB:14:A2",
//   );

//   @override
//   void initState() {
//     super.initState();
//     connectAndWriteToCharacteristic();
//   }

//   Future<void> connectAndWriteToCharacteristic() async {
//     try {
//       // Connect to the device
//       var device = flutterBlue.connectedDevices.firstWhere(
//           (d) => d.id.id == characteristic.deviceId,
//           orElse: () => null);

//       if (device == null) {
//         await flutterBlue.connectToAdvertisingDevice(
//             id: DeviceIdentifier(characteristic.deviceId),
//             withServices: [characteristic.serviceId]);
//       }

//       // Discover Services
//       List<BluetoothService> services = await device.discoverServices();
//       BluetoothCharacteristic targetCharacteristic;

//       for (BluetoothService service in services) {
//         for (BluetoothCharacteristic char in service.characteristics) {
//           if (char.uuid == characteristic.characteristicId) {
//             targetCharacteristic = char;
//             break;
//           }
//         }
//         if (targetCharacteristic != null) {
//           break;
//         }
//       }

//       // Write to the Characteristic
//       if (targetCharacteristic != null) {
//         await targetCharacteristic.write([0x12, 0x34]); // Your data here
//         print("Data written to the characteristic");
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bluetooth Demo'),
//       ),
//       body: Center(
//         child: Text('Connecting and Writing to Characteristic...'),
//       ),
//     );
//   }
// }
