import 'package:flutter/material.dart';
import '../../models/servico.dart';
import '../../models/cliente.dart';
import '../../services/api_service.dart';

class ServicoFormScreen extends StatefulWidget {
  const ServicoFormScreen({super.key});

  @override
  _ServicoFormScreenState createState() => _ServicoFormScreenState();
}

class _ServicoFormScreenState extends State<ServicoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  late TextEditingController tipoController;
  late TextEditingController dataController;
  late TextEditingController horaController;
  int? _clienteId;
  List<Cliente> _clientes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    tipoController = TextEditingController();
    dataController = TextEditingController();
    horaController = TextEditingController();
    _fetchClientes();
  }

  Future<void> _fetchClientes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Cliente> clientes = await _apiService.getClientes();
      setState(() {
        _clientes = clientes;
        _isLoading = false;
      });
    } catch (error) {
      print("Erro ao carregar clientes: $error");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar clientes: $error')),
      );
    }
  }

  int _generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate() && _clienteId != null) {
      final novoServico = Servico(
        id: _generateUniqueId(),
        tipo: tipoController.text,
        data: dataController.text,
        hora: horaController.text,
        status: 'agendado',
        clienteId: _clienteId!,
        empresaId: 1,
      );

      try {
        await _apiService.addServico(novoServico);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar serviço: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Serviço')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_clientes.isEmpty)
                  const Center(child: Text("Não foi encontrado nenhum cliente para selecionar."))
                else
                  DropdownButtonFormField<int?>(
                    value: _clienteId,
                    hint: const Text("Selecione um Cliente"),
                    items: _clientes.map((cliente) {
                      return DropdownMenuItem<int?>(
                        value: cliente.id != null ? cliente.id : null,
                        child: Text(cliente.nome),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _clienteId = value;
                      });
                    },
                    validator: (value) => value == null ? 'Selecione um cliente' : null,
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
