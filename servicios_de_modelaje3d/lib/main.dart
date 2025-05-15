import 'package:flutter/material.dart';
import 'package:servicios_de_modelaje3d/pages/splash.dart'; // ✅ Importa tu nueva clase

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modelaje 3D',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.brown),
      home: const SplashScreen(),
    );
  }
}
