class Specialty {
  final int id;
  final String name;

  Specialty({required this.id, required this.name});

  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
