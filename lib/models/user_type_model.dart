class UserType {
  final int id;
  final String description;

  UserType({required this.id, required this.description});

  factory UserType.fromJson(Map<String, dynamic> json) {
    return UserType(id: json['id'], description: json['description']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'description': description};
  }
}
