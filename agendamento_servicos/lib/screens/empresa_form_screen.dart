import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/empresa.dart';

class EmpresaFormScreen extends StatefulWidget {
  const EmpresaFormScreen({super.key});

  @override
  _EmpresaFormScreenState createState() => _EmpresaFormScreenState();
}

class _EmpresaFormScreenState extends State<EmpresaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final empresa = Empresa(
        id: 0,
        nome: nomeController.text,
        telefone: telefoneController.text,
        email: emailController.text,
      );
      apiService.addEmpresa(empresa);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Empresa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome da Empresa'),
                validator: (value) => value!.isEmpty ? 'Digite o nome da empresa' : null,
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