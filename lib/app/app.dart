import 'package:flutter/material.dart';
import 'package:pem_ble_app/presentation/screens/start_screen/start_screen.dart';

class PemBleApp extends StatelessWidget {
  const PemBleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pem Ble - پێم بڵێ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Kurdish',
      ),
      home: const StartScreen(),
    );
  }
}