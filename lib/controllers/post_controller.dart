import 'dart:io';
import 'package:flutter/material.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/services/post_service.dart';
import 'package:maos_a_obra/widgets/toast.dart';
import 'package:maos_a_obra/models/post_model.dart';

class PostController {
  final PostService postService;
  final MyToast myToast = MyToast();

  PostController({PostService? postService})
    : postService = postService ?? PostService(baseUrl: baseUrl);

  Future<void> createPost(
    String description,
    List<File> images,
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) async {
    if (formKey.currentState!.validate()) {
      Post? post = await postService.createPost(description, images);

      if (post != null) {
        DataController.user!.posts.add(post);
        myToast.getToast("Post criado com sucesso");
        DataController.pagina.value = 0;
      } else {
        myToast.getToast("Erro ao criar post");
      }
    } else {
      myToast.getToast("Preencha todos os campos corretamente");
    }
  }

  Future<void> getPosts(BuildContext context) async {
    try {
      List<Post> posts = await postService.fetchPosts() ?? [];

      if (posts.isNotEmpty) {
        DataController.feed = posts;
      }
    } catch (e) {
      debugPrint("Erro ao buscar posts: $e");
      myToast.getToast("Erro ao carregar posts");
    }
  }

  Future<void> getPostsByUser(int userId, BuildContext context) async {
    try {
      List<Post> posts = await postService.fetchPostsByUser(userId) ?? [];

      if (posts.isNotEmpty) {
        DataController.selectedUser!.posts = posts;
      }
    } catch (e) {
      debugPrint("Erro ao buscar posts do usuário: $e");
      myToast.getToast("Erro ao carregar posts do usuário");
    }
  }
}
