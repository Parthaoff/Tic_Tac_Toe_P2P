import 'package:flutter/material.dart';
// Import our new home screen
import 'package:tictactoe_p2p/screens/home_screen.dart';
import 'package:tictactoe_p2p/services/networking_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe P2P',
      debugShowCheckedModeBanner: false,
      navigatorKey: NetworkingService().navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Set the home property to our new HomeScreen
      home: const HomeScreen(),
    );
  }
}