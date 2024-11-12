import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/servico.dart';
import '../models/cliente.dart';

class ApiService {
  final http.Client client;
  final String baseUrl = 'http://127.0.0.1:3000';

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Servico>> getServicos() async {
    final response = await client.get(Uri.parse('$baseUrl/servicos'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print('Serviços recebidos: $data');
      return data.map((json) => Servico.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<void> addServico(Servico servico) async {
    try {
      final Map<String, dynamic> servicoJson = servico.toJson();

      if (servicoJson['empresaId'] == null) {
        servicoJson.remove('empresaId');
      }

      final response = await client.post(
        Uri.parse('$baseUrl/servicos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(servicoJson),
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

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      print('Erro ao excluir serviço: ${response.body}');
      return false;
    }
  }

  Future<bool> addCliente(Cliente cliente) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/clientes'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': cliente.id,
          'nome': cliente.nome,
          'telefone': cliente.telefone,
          'email': cliente.email,
          'empresaId': Cliente.empresaId,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Erro ao adicionar cliente: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao fazer requisição: $e');
      return false;
    }
  }

  Future<List<Cliente>> getClientes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/clientes'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((json) {
          json['id'] = int.tryParse(json['id'].toString()) ?? 0;
          json['empresaId'] = int.tryParse(json['empresaId'].toString()) ?? 1;
          return Cliente.fromJson(json);
        }).toList();
      } else {
        throw Exception('Falha ao carregar clientes');
      }
    } catch (e) {
      print('Erro ao carregar clientes: $e');
      throw Exception('Erro ao carregar clientes');
    }
  }
}