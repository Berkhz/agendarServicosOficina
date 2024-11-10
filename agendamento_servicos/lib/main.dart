import 'package:agendamento_servicos/screens/Forms/cliente_form_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/Forms/servico_form_screen.dart';
import 'screens/Lists/list_screen.dart';
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
          return const ServicoFormScreen();
        },
        '/list': (context) {
          return const ListScreen();
        },
        '/add_client': (context) {
          return const ClienteFormScreen();
        }
      },
    );
  }
}
