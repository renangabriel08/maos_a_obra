class Comment {
  final int id;
  final String description;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.description,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
