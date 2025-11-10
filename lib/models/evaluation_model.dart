class Evaluation {
  final int id;
  final int nota;
  final String cliente;
  final String feedback;
  final String createdAt;
  final String updatedAt;

  Evaluation({
    required this.id,
    required this.nota,
    required this.cliente,
    required this.feedback,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Evaluation.fromJson(Map<String, dynamic> json) {
    return Evaluation(
      id: json['id'],
      nota: json['nota'],
      cliente: json['cliente_nome'],
      feedback: json['feedback'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
