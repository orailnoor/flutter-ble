import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' as ble;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Blue Plus Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FindDevicesScreen(),
    );
  }
}

class FindDevicesScreen extends StatefulWidget {
  @override
  _FindDevicesScreenState createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? connectedDevice;
  List<BluetoothService> servicesList = [];
  StreamSubscription? scanSubscription;

  @override
  void initState() {
    super.initState();
    scanForDevices();
  }

  void scanForDevices() {
    scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devicesList.any((device) => device.id == result.device.id)) {
          setState(() {
            devicesList.add(result.device);
            // print(result.device.)
          });
        }
      }
    }, onError: (error) {
      // Handle any errors here
      print('Error occurred while scanning: $error');
    });

    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
  }

  @override
  void dispose() {
    scanSubscription?.cancel();
    super.dispose();
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    setState(() {
      connectedDevice = device;
    });
    // discoverServices(device);
    // receiveDataFromBLE(ble.FlutterReactiveBle(), device.id.toString());
    // writeAndReadCharacteristic(
    // ble.QualifiedCharacteristic(
    //     characteristicId:
    //         ble.Uuid.parse("6e400002-b5a3-f393-e0a9-e50e24dcca9e"),
    //     serviceId: ble.Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e"),
    //     deviceId: "B8:D6:1A:BB:14:A2"),
    // ble.FlutterReactiveBle());
  }

  // void discoverServices(BluetoothDevice device) async {
  //   List<BluetoothService> services = await device.discoverServices();

  //   servicesList = services;

  //   final flutterReactiveBle = ble.FlutterReactiveBle();

  //   // print(services[2].characteristics[1]);
  //   ble.QualifiedCharacteristic characteristic = ble.QualifiedCharacteristic(
  //       characteristicId:
  //           ble.Uuid.parse("6e400002-b5a3-f393-e0a9-e50e24dcca9e"),
  //       serviceId: ble.Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e"),
  //       deviceId: "B8:D6:1A:BB:14:A2");
  //   flutterReactiveBle.writeCharacteristicWithResponse(characteristic,
  //       value: [49]).asStream();
  // }

  StreamSubscription<List<int>>? valueSubscription;

  Future<void> writeAndSubscribeToCharacteristics(String deviceId,
      String writeCharacteristicUuid, String notifyCharacteristicUuid) async {
    // Define the write characteristic
    final writeCharacteristic = ble.QualifiedCharacteristic(
        serviceId: ble.Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e"),
        characteristicId: ble.Uuid.parse(writeCharacteristicUuid),
        deviceId: deviceId);

    // Define the notify characteristic
    final notifyCharacteristic = ble.QualifiedCharacteristic(
        serviceId: ble.Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e"),
        characteristicId: ble.Uuid.parse(notifyCharacteristicUuid),
        deviceId: deviceId);

    ble.FlutterReactiveBle flutterReactiveBle = ble.FlutterReactiveBle();
    // Write to the characteristic
    await flutterReactiveBle.writeCharacteristicWithResponse(
      writeCharacteristic,
      value: [1], // The value you want to write
    );

    // Listen to the notifications from the notifyCharacteristic
    flutterReactiveBle.subscribeToCharacteristic(notifyCharacteristic).listen(
        (data) {
      final receivedString = utf8.decode(data);
      print('Received: $receivedString');
      if (receivedString.contains('Finish')) {
        // Handle 'Finish' logic here
        print('Received "Finish"');
      }
    }, onError: (dynamic error) {
      // Handle errors
      print('Error encountered: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            onTap: () {
              print('tapped');
              // Call this function after the device is connected
              writeAndSubscribeToCharacteristics(
                  "B8:D6:1A:BB:14:A2", // Your device's ID
                  "6e400002-b5a3-f393-e0a9-e50e24dcca9e", // RX Characteristic UUID for writing
                  "6e400003-b5a3-f393-e0a9-e50e24dcca9e" // TX Characteristic UUID for notifications
                  );
            },
            child: Text('Flutter Blue Plus Devices')),
      ),
      body: ListView.builder(
        itemCount: devicesList.length,
        itemBuilder: (context, index) {
          BluetoothDevice device = devicesList[index];
          return ListTile(
            title: Text(device.name),
            subtitle: Text(device.id.toString()),
            onTap: () {
              connectToDevice(device);
              print(device.id.toString());
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          print('scanning...');
          scanForDevices();
        },
      ),
    );
  }
}

void discoverServicesandroid(BluetoothDevice device) async {
  List<BluetoothService> services = await device.discoverServices();
  List<List<BluetoothCharacteristic>> allCharacteristicsAndServices = [];
  for (BluetoothService service in services) {
    List<BluetoothCharacteristic> characteristics = service.characteristics;
    allCharacteristicsAndServices.add(characteristics);
  }
  log(allCharacteristicsAndServices[1].toString());
  allCharacteristicsAndServices[3][0].setNotifyValue(true);
  await allCharacteristicsAndServices[3][1].write([49]);
  allCharacteristicsAndServices[3][0].onValueReceived.listen((value) {
    log(value.toString());
  });
}

void discoverServicesios(BluetoothDevice device) async {
  List<BluetoothService> services = await device.discoverServices();
  List<List<BluetoothCharacteristic>> allCharacteristicsAndServices = [];
  for (BluetoothService service in services) {
    List<BluetoothCharacteristic> characteristics = service.characteristics;
    allCharacteristicsAndServices.add(characteristics);
  }
  log(allCharacteristicsAndServices[1].toString());
  allCharacteristicsAndServices[1][0].setNotifyValue(true);
  await allCharacteristicsAndServices[1][1].write([49]);
  allCharacteristicsAndServices[1][0].onValueReceived.listen((value) {
    log(value.toString());
  });
}
