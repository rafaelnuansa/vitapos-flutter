import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:vitapos/components/app_drawer.dart';

class BluetoothPrinterConnectPage extends StatefulWidget {
  const BluetoothPrinterConnectPage({Key? key}) : super(key: key);

  @override
  BluetoothPrinterConnectPageState createState() =>
      BluetoothPrinterConnectPageState();
}

class BluetoothPrinterConnectPageState
    extends State<BluetoothPrinterConnectPage> {
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  bool _connected = false;
  bool _connecting = false;
  String _connectedDeviceName = '';
  List<BluetoothDevice> _devices = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await _refreshDevices();
    _updateConnectionStatus();
  }

  Future<void> _refreshDevices() async {
    setState(() {
      _devices = [];
    });

    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
      // ignore: empty_catches
    } on PlatformException {}

    setState(() {
      _devices = devices;
    });
  }

  Future<void> _updateConnectionStatus() async {
    bool? isConnected = await bluetooth.isConnected;

    setState(() {
      _connected = isConnected == true;
      if (_connected) {
        _connectedDeviceName =
            _devices.isNotEmpty ? _devices[0].name ?? '' : '';
      } else {
        _connectedDeviceName = '';
      }
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _connecting = true;
    });

    try {
      await bluetooth.connect(device);
      _updateConnectionStatus();
      _showSnackBar('Connected to: ${device.name}');
    } on PlatformException catch (e) {
      _showSnackBar('Failed to connect: ${e.message}');
    } finally {
      setState(() {
        _connecting = false;
      });
    }
  }

  void _disconnectDevice() async {
    setState(() {});

    try {
      await bluetooth.disconnect();
      _updateConnectionStatus();
      _showSnackBar('Device disconnected.');
    } on PlatformException catch (e) {
      _showSnackBar('Error disconnecting: ${e.message}');
    } finally {
      setState(() {});
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  void _showDeviceListDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Bluetooth Printer', style: TextStyle()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _devices.map((device) {
              return ListTile(
                title: Text(device.name ?? 'Unknown Device',
                    style: const TextStyle()),
                onTap: () {
                  Navigator.pop(context);
                  _connectToDevice(device);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text(
          'Bluetooth Printer Connection',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // backgroundColor: Colors.indigo,
        elevation: 0, // Remove elevation
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: _connected
                    ? _disconnectDevice
                    : _connecting
                        ? null
                        : _showDeviceListDialog,
                child: _connecting
                    ? const CircularProgressIndicator()
                    : Text(
                        _connected ? 'Disconnect' : 'Connect',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              if (_connected)
                Column(
                  children: [
                    Text(
                      'Connected to: $_connectedDeviceName',
                      style: const TextStyle(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshDevices,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Refresh Device List',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              else
                const Column(
                  children: [
                    Text(
                      'Tidak ada perangkat terdeteksi',
                      style: TextStyle(),
                    ),
                    SizedBox(height: 16),
                    Icon(
                      Icons.bluetooth,
                      size: 64,
                      color: Colors.grey,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: const BluetoothPrinterConnectPage(),
    theme: ThemeData(
      // Add custom theme for the app
      primaryColor: Colors.indigo,
      hintColor: Colors.indigoAccent,
      fontFamily: const TextStyle().fontFamily,
    ),
  ));
}
