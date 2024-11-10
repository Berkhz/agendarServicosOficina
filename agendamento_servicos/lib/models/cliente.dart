class Cliente {
  final int id;
  final String nome;
  final String telefone;
  final String email;
  final int empresaId;

  Cliente({required this.id, required this.nome, required this.telefone, required this.email, required this.empresaId});

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'],
      telefone: json['telefone'],
      email: json['email'],
      empresaId: json['empresaId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'empresaId': empresaId,
    };
  }
}