import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maos_a_obra/controllers/post_controller.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController descricaoController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<File> imagens = [];

  final PostController _postController = PostController();

  Future<void> pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        imagens = pickedFiles.map((e) => File(e.path)).toList();
      });
    }
  }

  Future<void> enviarPost() async {
    await _postController.createPost(
      descricaoController.text,
      imagens,
      context,
      _formKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload fotos
            Text("Imagens", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: pickImages,
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Selecionar Fotos"),
                ),
                const SizedBox(width: 10),
                Text("${imagens.length} selecionadas"),
              ],
            ),
            const SizedBox(height: 20),

            // Campo de descrição
            TextFormField(
              controller: descricaoController,
              decoration: const InputDecoration(
                labelText: "Descrição do serviço",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: (value) => value == null || value.isEmpty
                  ? "Digite uma descrição"
                  : null,
            ),
            const SizedBox(height: 30),

            // Botões
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Voltar"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: enviarPost,
                    icon: const Icon(Icons.send),
                    label: const Text("Enviar"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
