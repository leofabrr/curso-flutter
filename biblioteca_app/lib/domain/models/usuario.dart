class Usuario {
  final String id;
  String nome;
  String email;

  Usuario({required this.id, required this.nome, required this.email}) {
    _validar();
  }

  void _validar() {
    if (nome.isEmpty) {
      throw ArgumentError('Nome não pode estar vazio');
    }

    if (!email.contains('@')) {
      throw ArgumentError('Formado de email inválido');
    }
  }

  String get nomeFormatado => nome.toUpperCase();
}
