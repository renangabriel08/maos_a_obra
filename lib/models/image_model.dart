class ImageModel {
  final int id;
  final String path;
  final int? postId;
  final int? budgetId;

  ImageModel({
    required this.id,
    required this.path,
    this.postId,
    this.budgetId,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      path: json['path'],
      postId: json['postId'],
      budgetId: json['budgetId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'path': path, 'postId': postId, 'budgetId': budgetId};
  }
}
