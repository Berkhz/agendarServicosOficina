import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agendamento de Serviços')),
      body: const Center(child: Text('Resumo de Serviços', style: TextStyle(color: Colors.white))),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Administrador"),
              accountEmail: Text("administrador@admin.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "",
                  style: TextStyle(fontSize: 40.0, color: Colors.black),
                ),
              ),
              decoration: BoxDecoration(color: Colors.black87),
            ),
            ListTile(
              title: const Text('Listagem de Serviços', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/list');
              },
            ),
            ListTile(
              title: const Text('Adicionar Serviço', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/form');
              },
            ),
            ListTile(
              title: const Text('Adicionar Cliente', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/add_client');
              },
            ),
          ],
        ),
      ),
    );
  }
}