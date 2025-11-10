import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:maos_a_obra/controllers/post_controller.dart';
import 'package:maos_a_obra/styles/style.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _descricaoController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<File> _imagensSelecionadas = [];
  final PostController _postController = PostController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _selecionarImagens() async {
    final List<XFile> imagens = await _picker.pickMultiImage();
    if (imagens.isNotEmpty) {
      setState(() {
        _imagensSelecionadas = imagens.map((img) => File(img.path)).toList();
      });
    }
  }

  Future<void> _enviarPost() async {
    if (_formKey.currentState!.validate()) {
      await _postController.createPost(
        _descricaoController.text,
        _imagensSelecionadas,
        context,
        _formKey,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/imgs/Logo.png', height: 100),
                  const SizedBox(height: 20),
                  Text(
                    'Adicione um serviço ao\nseu portfólio',
                    style: TextStyle(
                      color: Color(AppColors.azulescuro),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  OutlinedButton.icon(
                    onPressed: _selecionarImagens,
                    icon: const Icon(
                      Icons.upload,
                      color: Color(AppColors.roxo),
                      size: 32,
                    ),
                    label: const Text(
                      'Carregar arquivos de mídia',
                      style: TextStyle(
                        color: Color(AppColors.azulescuro),
                        fontSize: 16,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      side: const BorderSide(
                        color: Color(AppColors.azulescuro),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_imagensSelecionadas.isNotEmpty)
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 180,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                      ),
                      items: _imagensSelecionadas.map((file) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            file,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descricaoController,
                    maxLines: 4,
                    decoration: AppDecorations.inputDecoration(
                      'Descrição do serviço',
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Digite uma descrição'
                        : null,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(AppColors.roxo),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fixedSize: Size(width, 50),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                _imagensSelecionadas.isNotEmpty) {
                              _enviarPost();
                            }
                          },
                          child: const Text(
                            'Prosseguir',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
