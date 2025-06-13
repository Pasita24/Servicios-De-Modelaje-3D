import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_de_modelaje3d/pages/login_page.dart';
import 'package:servicios_de_modelaje3d/services/auth_provider.dart';
import 'package:servicios_de_modelaje3d/services/plan_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PlanProvider()),
      ],
      child: MaterialApp(
        title: 'Modelaje 3D',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFF240046),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
