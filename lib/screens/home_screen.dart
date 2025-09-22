import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tictactoe_p2p/services/networking_service.dart';

// Convert to a StatefulWidget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Add a state variable to track if we are connecting
  bool _isConnecting = false;

  Future<void> _requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
      Permission.nearbyWifiDevices, // Make sure this is added
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('P2P Tic Tac Toe'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: _isConnecting
        // If connecting, show a loading indicator
            ? const CircularProgressIndicator()
        // Otherwise, show the buttons
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              // Disable the button if _isConnecting is true
              onPressed: _isConnecting
                  ? null
                  : () async {
                setState(() {
                  _isConnecting = true;
                });
                await _requestPermissions();
                await NetworkingService().startAdvertising();
                // We will handle navigation and resetting the
                // _isConnecting flag in the next lesson.
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Create Game'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              // Disable the button if _isConnecting is true
              onPressed: _isConnecting
                  ? null
                  : () async {
                setState(() {
                  _isConnecting = true;
                });
                await _requestPermissions();
                await NetworkingService().startDiscovery();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Join Game'),
            ),
          ],
        ),
      ),
    );
  }
}