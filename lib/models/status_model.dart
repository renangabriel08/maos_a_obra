class Status {
  final int id;
  final String descricao;

  Status({required this.id, required this.descricao});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(id: json['id'], descricao: json['descricao']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'descricao': descricao};
  }
}
