import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/servico_form_screen.dart';
import 'screens/list_screen.dart';
import '../models/servico.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agendamento de Serviços',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/form': (context) {
          return ServicoFormScreen(servico: Servico(id: 0, tipo: '', data: '', hora: '', status: '', clienteId: 0, empresaId: 0));
        },
        '/list': (context) {
          return const ListScreen();
        },
      },
    );
  }
}
