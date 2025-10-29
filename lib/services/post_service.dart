import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/models/comment_model.dart';
import 'package:maos_a_obra/models/post_model.dart';
import 'package:maos_a_obra/widgets/toast.dart';

class PostService {
  final String baseUrl;
  PostService({required this.baseUrl});

  final MyToast toast = MyToast();

  Future<Post?> createPost(String description, List<File> images) async {
    try {
      var uri = Uri.parse('$baseUrl/posts');
      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer ${DataController.user!.token}';
      request.fields['descricao'] = description;

      for (var img in images) {
        request.files.add(
          await http.MultipartFile.fromPath('imagens[]', img.path),
        );
      }

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        var respStr = await response.stream.bytesToString();
        var jsonResp = jsonDecode(respStr);
        return Post.fromJson(jsonResp);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<Post>?> fetchPosts() async {
    try {
      final uri = Uri.parse('$baseUrl/posts');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'authorization': "Bearer ${DataController.user!.token}",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String responseString = utf8.decode(response.bodyBytes);

        String fixedResponseString = responseString;
        if (responseString.isNotEmpty && responseString.trim().endsWith('}')) {
          fixedResponseString = '$responseString]';
        }

        final List<dynamic> responseBody = jsonDecode(fixedResponseString);
        return responseBody.map((e) => Post.fromJson(e)).toList();
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        toast.getToast(responseBody['error']);
      }
    } catch (e) {
      debugPrint("Erro ao buscar posts: $e");
      toast.getToast("Erro de conexão com API");
    }
    return null;
  }

  Future<List<Post>?> fetchPostsByUser(int userId) async {
    try {
      final uri = Uri.parse('$baseUrl/users/$userId/posts');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'authorization': "Bearer ${DataController.user!.token}",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String responseString = utf8.decode(response.bodyBytes);

        String fixedResponseString = responseString;
        if (responseString.isNotEmpty && responseString.trim().endsWith('}')) {
          fixedResponseString = '$responseString]';
        }

        final List<dynamic> responseBody = jsonDecode(fixedResponseString);

        return responseBody.map((e) => Post.fromJson(e)).toList();
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        toast.getToast(responseBody['error']);
      }
    } catch (e) {
      debugPrint("Erro ao buscar posts do usuário: $e");
      toast.getToast("Erro de conexão com API");
    }
    return null;
  }

  Future<bool> likePost(int postId) async {
    try {
      final uri = Uri.parse('$baseUrl/posts/$postId/like');
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseBody = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        toast.getToast(responseBody['message']);
        return true;
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        toast.getToast(responseBody['error']);
      }
    } catch (e) {
      debugPrint("Erro ao adicionar like: $e");
      toast.getToast("Erro de conexão com API");
    }
    return false;
  }

  Future<Comment?> addComment(
    int postId,
    Map<String, dynamic> commentData,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl/posts/$postId/comments');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(commentData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseBody = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        toast.getToast(responseBody['message']);
        return Comment.fromJson(responseBody['data']);
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        toast.getToast(responseBody['error']);
      }
    } catch (e) {
      debugPrint("Erro ao adicionar comentário: $e");
      toast.getToast("Erro de conexão com API");
    }
    return null;
  }

  Future<List<Comment>?> getComments(int postId) async {
    try {
      final uri = Uri.parse('$baseUrl/posts/$postId/comments');
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseBody = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        toast.getToast(responseBody['message']);
        final List<dynamic> data = responseBody['data'];
        return data.map((e) => Comment.fromJson(e)).toList();
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        toast.getToast(responseBody['error']);
      }
    } catch (e) {
      debugPrint("Erro ao buscar comentários: $e");
      toast.getToast("Erro de conexão com API");
    }
    return null;
  }
}
