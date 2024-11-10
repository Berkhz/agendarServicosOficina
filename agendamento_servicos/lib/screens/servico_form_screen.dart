import 'package:flutter/material.dart';
import '../models/servico.dart';

class ServicoFormScreen extends StatefulWidget {
  final Servico servico;

  const ServicoFormScreen({super.key, required this.servico});

  @override
  _ServicoFormScreenState createState() => _ServicoFormScreenState();
}

class _ServicoFormScreenState extends State<ServicoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController tipoController;
  late TextEditingController dataController;
  late TextEditingController horaController;

  @override
  void initState() {
    super.initState();
    tipoController = TextEditingController(text: widget.servico.tipo);
    dataController = TextEditingController(text: widget.servico.data);
    horaController = TextEditingController(text: widget.servico.hora);
  }

  @override
  void dispose() {
    tipoController.dispose();
    dataController.dispose();
    horaController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final novoServico = Servico(
        id: widget.servico.id,
        tipo: tipoController.text,
        data: dataController.text,
        hora: horaController.text,
        status: 'agendado',
        clienteId: 1,
        empresaId: 1
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Serviço')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: tipoController,
                decoration: const InputDecoration(labelText: 'Tipo de Serviço'),
                validator: (value) => value!.isEmpty ? 'Digite um tipo' : null,
              ),
              TextFormField(
                controller: dataController,
                decoration: const InputDecoration(labelText: 'Data (DD/MM/AAAA)'),
                validator: (value) => value!.isEmpty ? 'Digite uma data' : null,
              ),
              TextFormField(
                controller: horaController,
                decoration: const InputDecoration(labelText: 'Hora (HH:MM)'),
                validator: (value) => value!.isEmpty ? 'Digite uma hora' : null,
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