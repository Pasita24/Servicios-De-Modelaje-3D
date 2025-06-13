import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_de_modelaje3d/pages/login_page.dart';
import 'package:servicios_de_modelaje3d/services/auth_provider.dart';
import 'package:servicios_de_modelaje3d/services/plan_provider.dart';
import 'package:servicios_de_modelaje3d/themes/theme.dart'; // Importa theme.dart
import 'package:servicios_de_modelaje3d/utils/util.dart'; // Importa util.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Crea el TextTheme usando las fuentes especificadas
    final textTheme = createTextTheme(context, "Afacad", "Aboreto");
    // Instancia MaterialTheme con el TextTheme
    final theme = MaterialTheme(textTheme);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PlanProvider()),
      ],
      child: MaterialApp(
        title: 'Modelaje 3D',
        theme: theme.light(), // Tema claro
        darkTheme: theme.dark(), // Tema oscuro
        themeMode: ThemeMode.system, // Cambia automáticamente según el sistema
        home: const LoginPage(),
      ),
    );
  }
}
