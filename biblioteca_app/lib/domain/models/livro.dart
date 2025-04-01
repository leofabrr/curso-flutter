// domain/models/book.dart
class Livro {
  final String id;
  final String titulo;
  final String autor;
  final String genero;
  final int paginas;

  Livro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.genero,
    required this.paginas,
  }) {
    // Validações
    _validar();
  }

  // ! Ainda vamos falar sobre todos os métodos abaixo com mais profundidade
  // ! Por enquanto estamos apenas vendo como um modelo padrão de Model seria

  void _validar() {
    if (titulo.isEmpty) {
      throw ArgumentError('Título não pode ser vazio');
    }

    if (autor.length < 3) {
      throw ArgumentError('Autor deve ter pelo menos 3 caracteres');
    }

    if (paginas <= 0) {
      throw ArgumentError('Número de páginas inválido');
    }

    if (!generosValidos.contains(genero)) {
      throw ArgumentError('Gênero inválido: $genero');
    }
  }

  static const generosValidos = [
    'Ficção',
    'Não-Ficção',
    'Técnico',
    'Fantasia',
    'Biografia',
  ];

  // Método útil para transformações simples
  String get autorFormatado =>
      autor.toUpperCase(); // Informa em maiúsculo o autor

  String get infoResumida =>
      '$titulo ($genero) - ${paginas}p'; // resumo do livro

  // Método para converter o objeto em Map (útil para persistência/APIs)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'autor': autor,
      'genero': genero,
      'paginas': paginas,
    };
  }

  // Factory method para criar objeto a partir de Map (desserialização)
  factory Livro.fromJson(Map<String, dynamic> json) {
    return Livro(
      id: json['id'],
      titulo: json['titulo'],
      autor: json['autor'],
      genero: json['genero'],
      paginas: json['paginas'],
    );
  }

  // Override do toString para debug mais legível
  @override
  String toString() {
    return 'Book{id: $id, titulo: $titulo, autor: $autor, gênero: $genero, páginas: $paginas}';
  }

  // Override de igualdade e hashCode para comparação de objetos
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Livro &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          titulo == other.titulo &&
          autor == other.autor &&
          genero == other.genero &&
          paginas == other.paginas;

  @override
  int get hashCode =>
      id.hashCode ^
      titulo.hashCode ^
      autor.hashCode ^
      genero.hashCode ^
      paginas.hashCode;

  // Método copyWith para criar cópias modificadas
  Livro copyWith({
    String? id,
    String? titulo,
    String? autor,
    String? genero,
    int? paginas,
  }) {
    return Livro(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      autor: autor ?? this.autor,
      genero: genero ?? this.genero,
      paginas: paginas ?? this.paginas,
    );
  }
}
