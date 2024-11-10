import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/servico.dart';
import '../models/empresa.dart';
import '../models/cliente.dart';

class ApiService {
  final http.Client client;
  final String baseUrl = 'http://127.0.0.1:3000';

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Servico>> getServicos() async {
    final response = await client.get(Uri.parse('$baseUrl/servicos'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print('Serviços recebidos: $data'); // Adicionando log para verificar os dados
      return data.map((json) => Servico.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<void> addServico(Servico servico) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/servicos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(servico.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add service: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to add service: $error');
    }
  }

  Future<void> updateServico(Servico servico) async {
    final response = await client.put(
      Uri.parse('$baseUrl/servicos/${servico.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(servico.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar serviço');
    }
  }

  Future<bool> deleteServico(int id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/servicos/$id'),
    );

    return response.statusCode == 200;
  }

  Future<void> addEmpresa(Empresa empresa) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/empresas'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(empresa.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add company: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to add company: $error');
    }
  }

  Future<bool> addCliente(Cliente cliente) async {
    final response = await http.post(
      Uri.parse('$baseUrl/clientes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nome': cliente.nome,
        'telefone': cliente.telefone,
        'email': cliente.email,
        'empresaId': cliente.empresaId,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Empresa>> getEmpresas() async {
    final response = await http.get(Uri.parse('$baseUrl/empresas'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Empresa.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar empresas');
    }
  }

  Future<List<Cliente>> getClientes() async {
    final response = await http.get(Uri.parse('$baseUrl/clientes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Cliente.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar clientes');
    }
  }

}