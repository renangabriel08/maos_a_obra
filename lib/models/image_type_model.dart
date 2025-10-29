class ImageType {
  final int id;
  final String name;

  ImageType({required this.id, required this.name});

  factory ImageType.fromJson(Map<String, dynamic> json) {
    return ImageType(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
