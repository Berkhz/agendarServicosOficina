import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/cliente.dart';

class ClienteFormScreen extends StatefulWidget {
  final int empresaId;
  const ClienteFormScreen({super.key, required this.empresaId});

  @override
  _ClienteFormScreenState createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final cliente = Cliente(
        id: 0,
        nome: nomeController.text,
        telefone: telefoneController.text,
        email: emailController.text,
        empresaId: widget.empresaId,
      );
      apiService.addCliente(cliente);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Cliente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Cliente'),
                validator: (value) => value!.isEmpty ? 'Digite o nome do cliente' : null,
              ),
              TextFormField(
                controller: telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: (value) => value!.isEmpty ? 'Digite o telefone' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (value) => value!.isEmpty ? 'Digite o e-mail' : null,
              ),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}