import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_de_modelaje3d/pages/login_page.dart';
import 'package:servicios_de_modelaje3d/services/auth_provider.dart';
import 'package:servicios_de_modelaje3d/services/plan_provider.dart';
import 'package:servicios_de_modelaje3d/themes/theme.dart'; // Importa theme.dart
import 'package:servicios_de_modelaje3d/utils/util.dart'; // Importa util.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.init(); // Inicializa SharedPreferences

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => PlanProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = createTextTheme(context, "Afacad", "Aboreto");
    final theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Modelaje 3D',
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: ThemeMode.system,
      home: const LoginPage(),
      debugShowCheckedModeBanner: false, // Recomendado para producción
    );
  }
}
