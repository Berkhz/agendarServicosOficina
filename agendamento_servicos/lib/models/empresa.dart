class Empresa {
  final int id;
  final String nome;
  final String telefone;
  final String email;

  Empresa({required this.id, required this.nome, required this.telefone, required this.email});

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      id: json['id'],
      nome: json['nome'],
      telefone: json['telefone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
    };
  }
}
