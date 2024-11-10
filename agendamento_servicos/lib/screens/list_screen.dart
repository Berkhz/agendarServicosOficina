import 'package:flutter/material.dart';
import '../models/servico.dart';
import '../services/api_service.dart';
import 'servico_form_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final ApiService apiService = ApiService();

  Future<List<Servico>>? _servicos;

  @override
  void initState() {
    super.initState();
    _loadServicos();
  }

  void _loadServicos() {
    _servicos = apiService.getServicos();
  }

  void _deleteServico(int id) async {
    final response = await apiService.deleteServico(id);
    if (response) {
      setState(() {
        _loadServicos();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao deletar o serviço')),
      );
    }
  }

  void _editServico(Servico servico) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServicoFormScreen(servico: servico),
      ),
    );

    if (result != null) {
      setState(() {
        _loadServicos();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listagem de Serviços')),
      body: FutureBuilder<List<Servico>>(
        future: _servicos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os serviços: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum serviço encontrado'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Servico servico = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10.0),
                    title: Text(servico.tipo),
                    subtitle: Text('Data: ${servico.data} - Hora: ${servico.hora}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _editServico(servico);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _deleteServico(servico.id);
                          },
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}