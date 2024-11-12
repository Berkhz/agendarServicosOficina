import 'package:agendamento_servicos/models/cliente.dart';
import 'package:agendamento_servicos/models/servico.dart';
import 'package:agendamento_servicos/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('ApiService', () {
    late ApiService apiService;

    setUp(() {
      // Configura um cliente HTTP mock para simular requisições e respostas sem acessar uma API real.
      apiService = ApiService(client: MockClient((request) async {
        if (request.url.path.contains('/servicos')) {
          if (request.method == 'GET') {
            return http.Response(
              json.encode([
                {
                  'id': 1,
                  'tipo': 'Manutenção',
                  'data': '2024-11-12',
                  'hora': '14:00',
                  'status': 'Pendente',
                  'clienteId': 101,
                  'empresaId': 201
                },
                {
                  'id': 2,
                  'tipo': 'Instalação',
                  'data': '2024-11-13',
                  'hora': '09:00',
                  'status': 'Concluído',
                  'clienteId': 102,
                  'empresaId': 202
                }
              ]),
              200,
            );
          } else if (request.method == 'POST') {
            return http.Response('', 201);
          } else if (request.method == 'PUT') {
            return http.Response('', 200);
          } else if (request.method == 'DELETE') {
            return http.Response('', 200);
          }
        }

        if (request.url.path.contains('/clientes')) {
          if (request.method == 'GET') {
            return http.Response(
              json.encode([
                {'id': 1, 'nome': 'Cliente 1', 'telefone': '123456', 'email': 'email1@test.com', 'empresaId': 1},
                {'id': 2, 'nome': 'Cliente 2', 'telefone': '789123', 'email': 'email2@test.com', 'empresaId': 1}
              ]),
              200,
            );
          } else if (request.method == 'POST') {
            return http.Response('', 201);
          }
        }

        return http.Response('Not Found', 404);
      }));
    });

    test('getServicos retorna uma lista de serviços', () async {
      // Testa se o método getServicos retorna corretamente uma lista de serviços.
      // Espera-se que a lista tenha dois serviços simulados no MockClient.
      final servicos = await apiService.getServicos();
      expect(servicos, isA<List<Servico>>());
      expect(servicos.length, 2);
      expect(servicos[0].tipo, 'Manutenção');
      expect(servicos[0].status, 'Pendente');
    });

    test('addServico adiciona um serviço sem erro', () async {
      // Testa se o método addServico executa com sucesso sem lançar exceções.
      // Envia um objeto Servico simulado e verifica se o mock responde corretamente.
      final servico = Servico(
        id: 1,
        tipo: 'Manutenção',
        data: '2024-11-14',
        hora: '10:00',
        status: 'Pendente',
        clienteId: 101,
        empresaId: 201,
      );
      await apiService.addServico(servico);
      // Sem exceções = sucesso
    });

    test('updateServico atualiza um serviço sem erro', () async {
      // Testa se o método updateServico executa corretamente para atualizar um serviço existente.
      // Envia um objeto Servico simulado com novos valores e verifica a execução.
      final servico = Servico(
        id: 1,
        tipo: 'Instalação Atualizada',
        data: '2024-11-14',
        hora: '11:00',
        status: 'Concluído',
        clienteId: 101,
        empresaId: 201,
      );
      await apiService.updateServico(servico);
      // Sem exceções = sucesso
    });

    test('deleteServico retorna true ao excluir com sucesso', () async {
      // Testa se o método deleteServico retorna `true` ao excluir um serviço com sucesso.
      final result = await apiService.deleteServico(1);
      expect(result, true);
    });

    test('addCliente adiciona um cliente sem erro', () async {
      // Testa se o método addCliente executa corretamente ao adicionar um novo cliente.
      // Envia um objeto Cliente simulado e verifica se o mock responde com sucesso.
      final cliente = Cliente(
        nome: 'Cliente Teste',
        telefone: '123456',
        email: 'cliente@teste.com',
        id: 1,
      );
      final result = await apiService.addCliente(cliente);
      expect(result, true);
    });
  });
}
