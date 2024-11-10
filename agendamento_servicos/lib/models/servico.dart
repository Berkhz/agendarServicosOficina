class Servico {
  final int id;
  final String tipo;
  final String data;
  final String hora;
  final String status;
  final int clienteId;
  final int empresaId;

  Servico({
    required this.id,
    required this.tipo,
    required this.data,
    required this.hora,
    required this.status,
    required this.clienteId,
    required this.empresaId,
  });

  factory Servico.fromJson(Map<String, dynamic> json) {
    return Servico(
      id: json['id'],
      tipo: json['tipo'],
      data: json['data'],
      hora: json['hora'],
      status: json['status'],
      clienteId: json['clienteId'],
      empresaId: json['empresaId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'data': data,
      'hora': hora,
      'status': status,
      'clienteId': clienteId,
      'empresaId': empresaId,
    };
  }
}