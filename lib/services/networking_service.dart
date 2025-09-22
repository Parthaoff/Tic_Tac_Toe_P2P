import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:tictactoe_p2p/screens/game_screen.dart';

class NetworkingService {
  static final NetworkingService _instance = NetworkingService._internal();
  factory NetworkingService() => _instance;
  NetworkingService._internal();

  final Strategy _strategy = Strategy.P2P_STAR;
  final String _userName = Random().nextInt(10000).toString();
  String? _opponentName;
  String? _opponentId; // To know who to send data to

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Use a ValueNotifier to notify the UI of received data
  final ValueNotifier<int?> opponentMoveNotifier = ValueNotifier(null);

  Future<void> startAdvertising() async {
    try {
      await Nearby().startAdvertising(
        _userName,
        _strategy,
        onConnectionInitiated: _onConnectionInitiated,
        onConnectionResult: (id, status) {
          if (status == Status.CONNECTED) {
            _opponentId = id;
            print('Connected to: $_opponentName ($id)');
            navigatorKey.currentState?.push(MaterialPageRoute(
              builder: (context) => const GameScreen(isHost: true), // I am Player 'X'
            ));
          }
        },
        onDisconnected: (id) {
          print('Disconnected from: $_opponentName ($id)');
          // TODO: Handle disconnection, maybe show a dialog and navigate home
        },
      );
      print('Started advertising as $_userName');
    } catch (e) {
      print('Error starting advertising: $e');
    }
  }

  Future<void> startDiscovery() async {
    try {
      await Nearby().startDiscovery(
        _userName,
        _strategy,
        onEndpointFound: (id, name, serviceId) {
          print('Endpoint found: $name ($id)');
          Nearby().requestConnection(
            _userName,
            id,
            onConnectionInitiated: _onConnectionInitiated,
            onConnectionResult: (id, status) {
              if (status == Status.CONNECTED) {
                _opponentId = id;
                print('Connected to: $_opponentName ($id)');
                navigatorKey.currentState?.push(MaterialPageRoute(
                  builder: (context) => const GameScreen(isHost: false), // I am Player 'O'
                ));
              }
            },
            onDisconnected: (id) {
              print('Disconnected from: $_opponentName ($id)');
            },
          );
        },
        onEndpointLost: (id) {
          print('Endpoint lost: $id');
        },
      );
      print('Started discovery');
    } catch (e) {
      print('Error starting discovery: $e');
    }
  }

  void _onConnectionInitiated(String id, ConnectionInfo info) {
    print('Connection initiated from: ${info.endpointName} ($id)');
    _opponentName = info.endpointName;
    Nearby().acceptConnection(id, onPayLoadRecieved: (endpointId, payload) {
      if (payload.type == PayloadType.BYTES) {
        final moveIndex = int.parse(utf8.decode(payload.bytes!));
        print('Received move: $moveIndex');
        opponentMoveNotifier.value = moveIndex;
      }
    });
  }

  // Method to send data to the opponent
  void sendMove(int index) {
    if (_opponentId != null) {
      final data = Uint8List.fromList(utf8.encode('$index'));
      Nearby().sendBytesPayload(_opponentId!, data);
      print('Sent move: $index');
    }
  }

  // Method to clean up resources
  Future<void> disconnect() async {
    await Nearby().stopAllEndpoints();
    await Nearby().stopAdvertising();
    await Nearby().stopDiscovery();
    _opponentId = null;
    _opponentName = null;
  }
}