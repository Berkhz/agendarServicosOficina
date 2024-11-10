import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:agendamento_servicos/services/api_service.dart';
import 'package:agendamento_servicos/models/servico.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('ApiService', () {
    late ApiService apiService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiService(client: mockClient);
    });

    test('Testando o GET de serviços', () async {
      // Mock da resposta da requisição GET
      when(mockClient.get(Uri.parse('http://192.168.237.90:3000/servicos')))
          .thenAnswer(
            (_) async => http.Response(
          json.encode([
            {'id': 1, 'tipo': 'Troca de óleo', 'data': '2024-11-20', 'hora': '10:00', 'status': 'agendado', 'clienteId': 1}
          ]),
          200,
        ),
      );

      final services = await apiService.getServicos();

      // Verifica se o serviço retornado não está vazio e tem os valores corretos
      expect(services.isNotEmpty, true);
      expect(services[0].tipo, 'Troca de óleo');
      expect(services[0].id, 1);
    });

    test('Testando o POST de serviço', () async {
      final servico = Servico(
        id: 2,
        tipo: 'Troca de Pneu',
        data: '2024-11-20',
        hora: '11:00',
        status: 'agendado',
        clienteId: 1,
        empresaId: 1,  // Incluindo o empresaId aqui
      );

      // Mock da resposta da requisição POST
      when(mockClient.post(
        Uri.parse('http://192.168.237.90:3000/servicos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(servico.toJson()),
      )).thenAnswer(
            (_) async => http.Response('{"id": 2}', 201),
      );

      await apiService.addServico(servico);

      // Verifica se o método post foi chamado corretamente com os parâmetros esperados
      verify(mockClient.post(
        Uri.parse('http://192.168.237.90:3000/servicos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(servico.toJson()),
      )).called(1);
    });
  });
}
