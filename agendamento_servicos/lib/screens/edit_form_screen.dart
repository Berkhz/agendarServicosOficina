import 'package:flutter/material.dart';
import '../models/servico.dart';
import '../models/cliente.dart';
import '../models/empresa.dart';
import '../services/api_service.dart';

class EditFormScreen extends StatefulWidget {
  final Servico servico;

  const EditFormScreen({super.key, required this.servico});

  @override
  _EditFormScreenState createState() => _EditFormScreenState();
}

class _EditFormScreenState extends State<EditFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController horaController = TextEditingController();

  List<Empresa> empresas = [];
  List<Cliente> clientes = [];
  Empresa? selectedEmpresa;
  Cliente? selectedCliente;

  @override
  void initState() {
    super.initState();
    tipoController.text = widget.servico.tipo;
    dataController.text = widget.servico.data;
    horaController.text = widget.servico.hora;

    _loadEmpresas();
    _loadClientes();
  }

  void _loadEmpresas() async {
    final response = await apiService.getEmpresas();
    setState(() {
      empresas = response;
    });
  }

  void _loadClientes() async {
    final response = await apiService.getClientes();
    setState(() {
      clientes = response;
    });
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final updatedServico = Servico(
        id: widget.servico.id,
        tipo: tipoController.text,
        data: dataController.text,
        hora: horaController.text,
        status: widget.servico.status,
        clienteId: selectedCliente?.id ?? widget.servico.clienteId,
        empresaId: selectedEmpresa?.id ?? widget.servico.empresaId,
      );
      await apiService.updateServico(updatedServico);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Serviço')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8.0,
          color: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: tipoController,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Serviço',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.black12,
                    ),
                    validator: (value) =>
                    value!.isEmpty ? 'Digite um tipo' : null,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: dataController,
                        decoration: const InputDecoration(
                          labelText: 'Data (DD/MM/AAAA)',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.black12,
                        ),
                        validator: _validateData,
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: horaController,
                    decoration: const InputDecoration(
                      labelText: 'Hora (HH:MM)',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.black12,
                    ),
                    validator: (value) => value!.isEmpty ? 'Digite uma hora' : null,
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Empresa>(
                    value: selectedEmpresa,
                    onChanged: (value) {
                      setState(() {
                        selectedEmpresa = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Selecione a Empresa',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.black12,
                    ),
                    items: empresas.map((empresa) {
                      return DropdownMenuItem(
                        value: empresa,
                        child: Text(empresa.nome),
                      );
                    }).toList(),
                    validator: (value) => value == null ? 'Selecione uma empresa' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Cliente>(
                    value: selectedCliente,
                    onChanged: (value) {
                      setState(() {
                        selectedCliente = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Selecione o Cliente',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.black12,
                    ),
                    items: clientes.map((cliente) {
                      return DropdownMenuItem(
                        value: cliente,
                        child: Text(cliente.nome),
                      );
                    }).toList(),
                    validator: (value) => value == null ? 'Selecione um cliente' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.green,
                    ),
                    onPressed: _saveForm,
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        dataController.text =
        "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  String? _validateData(String? value) {
    if (value == null || value.isEmpty) return 'Digite uma data';
    if (value.length != 10) return 'Formato de data inválido';
    if (value[2] != '/' || value[5] != '/') return 'Formato de data inválido';

    final dateParts = value.split('/');
    final day = int.tryParse(dateParts[0]) ?? 0;
    final month = int.tryParse(dateParts[1]) ?? 0;
    final year = int.tryParse(dateParts[2]) ?? 0;

    final date = DateTime(year, month, day);
    if (date.weekday == DateTime.sunday) return 'Não é permitido agendamento para domingo';

    return null;
  }
}