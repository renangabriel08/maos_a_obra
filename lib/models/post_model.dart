import 'package:maos_a_obra/models/comment_model.dart';
import 'package:maos_a_obra/models/image_model.dart';
import 'package:maos_a_obra/models/user_model.dart';

class Post {
  final int id;
  final String? descricao;
  final int curtidas;
  final DateTime data;
  final List<Comment> comments;
  final List<ImageModel> images;
  final User user;

  Post({
    required this.id,
    this.descricao,
    required this.curtidas,
    required this.data,
    this.comments = const [],
    this.images = const [],
    required this.user,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      descricao: json['descricao'],
      curtidas: json['curtidas'],
      data: DateTime.parse(json['data']),
      comments:
          (json['comments'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e))
              .toList() ??
          [],
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => ImageModel.fromJson(e))
              .toList() ??
          [],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'curtidas': curtidas,
      'data': data.toIso8601String(),
      'comments': comments.map((e) => e.toJson()).toList(),
      'images': images.map((e) => e.toJson()).toList(),
      'user': user.toJson(),
    };
  }
}
