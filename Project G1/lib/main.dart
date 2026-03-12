import 'package:flutter/material.dart';
import 'feature/screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const GaiaConnectApp());
}

class GaiaConnectApp extends StatelessWidget {
  const GaiaConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gaia Connect',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        brightness: Brightness.dark, 
        primarySwatch: Colors.blueGrey,
      ),
      home: const ChatScreen(), 
    );
  }
}